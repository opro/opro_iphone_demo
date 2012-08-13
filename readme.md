# iOS OAuth Client

## What

This client shows how to trade a username and password for an access token on an [OAuth powered website](http://opro-demo.herokuapp.com) which is running on [Heroku](http://heroku.com). This token can then be used to access the API as an authenticated user. The website is written in Ruby on Rails and is using the [oPRO](http://github.com/opro/opro) library to provide OAuth authentication to their services.

This demo leverages [AFNetworking](https://github.com/AFNetworking/AFNetworking) for it's networking library and [AFOauth2Client](https://github.com/AFNetworking/AFOAuth2Client) to exchange the email and password for an access token. More information is available below.


## Why

The purpose of this demo is to give you an idea of how you could implement an iOS client for an OAuth enabled Ruby on Rails website running on [Heroku](http://heroku.com).

![](http://f.cl.ly/items/0M121e3j2y2x0i060o3i/Screen%20Shot%202012-08-10%20at%203.47.47%20PM.png)


## Setup

This app requires a current version of Xcode installed on your computer:

```sh
$ cd oPRO-Demo
$ gem install cocoapods
$ pod install
$ open "oPRO-Demo.xcworkspace"
```


## Run



Make sure the target is oPRO-Demo, build and run the program. When the app launches you can enter your credentials that you signed up for http://opro-demo.herokuapp.com/users/sign_up or if you don't want to enter your own credentials you can randomly generate some and have them returned to the iOS application (this is for demo purposes only, never do this in a real app). Once you have entered a valid email and password, click the "log in" button and you will be taken to a form where you can edit that user account.

Change some fields on that page and click "done" this will send an authenticated `PUT` request to the server as a user. The changed fields will be saved on the server and a json representation will be returned to the iOS client for your verification.

## Next Steps

This demo is purposfully bare bones, it is intended to be simple in nature, but to demonstrate token exchange and making authenticated requests. You could fork this project and add additional API endpoints to the client. You can use this project as the boilerplate for your own iOS client for an oPRO backed website.

Typically you would want to store this token on the iOS device, so the next time a user opens the app, they don't have to re-enter their credentials.

Make sure to replace the `oClientBaseURLString` the `oClientID` and `oClientSecret` in your `OproAPIClient.h`

    #define oClientBaseURLString @"https://opro-demo.herokuapp.com/"
    #define oClientID            @"5e163ed8c70cc28e993109c788325307"
    #define oClientSecret        @"898ca5b48548bb3988b3c8469081fcfb"


# iOS Concepts

If you're new to this type of authentication or new to iOS there are some important concepts that will help you modifying this project, or implementing your own project.

## Get an Access Token with AFOauth2Client

Before we can make authenticated requests we must exchange our user credentials for an auth token. [AFOauth2Client](https://github.com/AFNetworking/AFOAuth2Client) can do this for us. Once you have the library in your project you will need a client application registered at http://opro-demo.herokuapp.com/oauth_client_apps/new this will return a client_id and a client secret.

In this example we will use these application credentials

    client id:      3234myClientId5678
    client Secret:  14321myClientSecret8765


These are not valid credentials and should be changed to your credentials that you got at http://opro-demo.herokuapp.com/oauth_client_apps/new. Once you have those credentials you can use them to trade a user's email and password for an auth token.

For this example we will use these user credentials:

    email:    foo@example.com
    password: p4ssw0rd

These are not valid credentials and should be changed to a user's credentials that can be obtained at http://opro-demo.herokuapp.com/users/sign_up. Once we have all of these credentials you can do add this in your code:


      NSURL *url = [NSURL URLWithString:@"https://opro-demo.herokuapp.com/"];
      AFOAuth2Client *OAuthClient = [[AFOAuth2Client alloc] initWithBaseURL:url];

      [OAuthClient registerHTTPOperationClass:[AFJSONRequestOperation class]];
      [OAuthClient authenticateUsingOAuthWithPath:@"oauth/token.json" username:@"foo@example.com"  password:@"p4ssw0rd" clientID:@"3234myClientId5678" secret:@"14321myClientSecret8765" success:^(AFOAuthAccount *account) {
        NSLog(@"Success: %@", account);
      } failure:^(NSError *error) {
        NSLog(@"Error: %@", error);
      }];


Again, make sure to replace the username, password, client id, and client secret with your own. Use HTTPS or your request ill not be secure. If you run the above you should get a dictionary printed in your log with an access token and refresh token.


# Making authenticated requests with AFNetworking

We can use the AFNetworking to easily make requests to our server.


## Build a Shared Instance of AFHTTPClient subclass

To make authenticated requests we need to set the Authorization header so that every request will have the access token we received using AFOauth2Client. To do this we must subclass AFHTTPClient. An example of this subclass is `OproAPIClient` in the project. We can use a shared instance of this subclass to make future requests.

First we will want to set the access token for this shared instance:

    + (void) setAccessToken:(NSString *)access_token {
      if (oauthAccessToken != access_token) {
        oauthAccessToken = [access_token copy];
      }
    }


Then we need to overwrite the `initWithBaseURL` to set the default accept and request to JSON. Here we also set the Authorization header:

    - (id)initWithBaseURL:(NSURL *)url {
      if (!self) {
        return nil;
      }
      [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
      [self setDefaultHeader:@"Accept" value:@"application/json"];
      if (oauthAccessToken) {
        [self setAuthorizationHeaderWithToken:oauthAccessToken];
      }
      return self;
    }

Finally we put all of this together to provide a standard interface through a shared client:

    + (OproAPIClient *) sharedClient{
      static OproAPIClient *_sharedClient = nil;
      static dispatch_once_t onceToken;
      dispatch_once(&onceToken, ^{
        _sharedClient = [[self alloc] initWithBaseURL:[NSURL URLWithString:@"https://opro-demo.herokuapp.com/"]];
      });
      return _sharedClient;
    }

Make sure to change `https://opro-demo.herokuapp.com/` to your own url. Be sure to use HTTPS. Once you've got your. Now we are ready to set our Authorization header using AFOauth2Client. We can do that like this:

      NSURL *url = [NSURL URLWithString:@"https://opro-demo.herokuapp.com/"];
      AFOAuth2Client *OAuthClient = [[AFOAuth2Client alloc] initWithBaseURL:url];

      [OAuthClient registerHTTPOperationClass:[AFJSONRequestOperation class]];
      [OAuthClient authenticateUsingOAuthWithPath:@"oauth/token.json" username:@"foo@example.com"  password:@"p4ssw0rd" clientID:@"3234myClientId5678" secret:@"14321myClientSecret8765" success:^(AFOAuthAccount *account) {
        [OproAPIClient setAccessToken:account.credential.accessToken];
      } failure:^(NSError *error) {
        NSLog(@"Error: %@", error);
      }];


Note the new line where we are setting the access token, we must do this before we initialize our shared client:

    [OproAPIClient setAccessToken:account.credential.accessToken];


### Make Authenticated Request with Shared Interface of OproAPIClient

Once we've set the access token in our `OproAPIClient` we can use the client to make authenticated calls. For example we could get a json representation of a user by getting `/users/me` on our server while authenticated:


    [[OproAPIClient sharedClient] getPath:@"/users/me" parameters:[NSDictionary dictionary] success:^(AFHTTPRequestOperation *operation, id responseObject) {
      NSLog(@"Success: %@", responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
      NSLog(@"Error: %@", error);
    }];


If you run that code you will get your authenticated user in json representation. In addition to issuing GET requests you can also post, put, and delete. For example to update this user you need to PUT to the same path. To update attributes you can build a dictionary. For example if we wanted to set the email and twitter we could build this dictionary:

    NSMutableDictionary *mutableUserParameters = [NSMutableDictionary dictionary];
    [mutableUserParameters setValue:@"awesome@example.com" forKey:@"email"];
    [mutableUserParameters setValue:@"schneems" forKey:@"twitter"];

Then we can pass that dictionary into our request under the "user" key:

    [[OproAPIClient sharedClient] putPath:@"/users/me" parameters:[NSDictionary dictionaryWithObject:mutableUserParameters forKey:@"user"] success:^(AFHTTPRequestOperation *operation, id responseObject) {
      NSLog(@"Success: %@", responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
      NSLog(@"Error: %@", error);
    }];

This will show up in the Rails server as a `params` of:

    "user" => {"twitter" => "schneems", "email" => "awesome@example.com"}


## Recap

So what did we learn? We need to exchange a username and password for an access token with `AFOauth2Client` then we can set our authorization header in a shared subclass of `AFHTTPClient`, and finally we can use that authorization header to make authenticated requests to an oPRO powered Ruby on Rails server. There are problems you can run into every step of the way. Below are some troubleshooting steps that should help.

## Troubleshooting


## Troubleshooting with access to the Rails Server and logs:

If you see CSRF warnings and unexpected redirects in your server log it might be possible that the client is not be sending a proper authorization header. You can double check this by adding:


    puts request.env["HTTP_AUTHORIZATION"].inspect

I will sometimes add this in a before filter in ApplicationController


    before_filter :debug


    def debug
      puts request.env["HTTP_AUTHORIZATION"].inspect
    end

If the header is not present, you need to check your client code to make sure that the Authorization header is being set.

You can also verify that the client id and client secret are correct via the `params`. Making authenticated calls to the built in OAuth test controller can give you better error messages like GET `/oauth_tests/show_me_the_money.

## Troubleshooting with on the Client

Similar to debugging on the client with `puts` you need to use `NSLog` liberally to make sure that you have set the authorization header correctly and to make sure you are passing the correct parameters. You may need to do this inside of OproAPIClient.


Making authenticated calls to the built in oauth test controller can give you better error messages like GET `/oauth_tests/show_me_the_money.