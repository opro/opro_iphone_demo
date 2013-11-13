# iOS OAuth Client

## What

This client shows how to trade a username and password for an access token on an [OAuth powered website](http://opro-demo.herokuapp.com) which is running on [Heroku](http://heroku.com). This token can then be used to access the API as an authenticated user. The website is written in Ruby on Rails and is using the [oPRO library](http://github.com/opro/opro) to provide OAuth authentication to their services.

This demo leverages [AFNetworking](https://github.com/AFNetworking/AFNetworking) for networking and to exchange the email and password for an access token. More information is available below.

To view the code running on the server you can look at the [oPRO Demo Rails app](http://github.com/opro/opro_rails_demo).

If you are new to OAuth or to client side authentication it may be useful to check the [built in OAuth docs](http://opro-demo.herokuapp.com/oauth_docs) generated from the [oPRO library](http://github.com/opro/opro).

## Why

The purpose of this demo is to give you an idea of how you could implement an iOS client for an OAuth enabled Ruby on Rails website running on [Heroku](http://heroku.com).

![](http://i.imgur.com/73JGlWE.png)

## Setup

This app requires a current version of Xcode installed on your computer and uses cocoapods to install `AFNetworking`:

```sh
$ cd opro_iphone_demo
$ gem install cocoapods
$ pod install
$ open "oPRO-Demo.xcworkspace"
```

## Run


Make sure the target is oPRO-Demo, build and run the program. You can sign up for the service with your own credentials at http://opro-demo.herokuapp.com/users/sign_up or you can randomly generate some and have them returned to the iOS application (this is for demo purposes only, never do this in a real app) by pressing the "Create a Random user" button. Once you have entered a valid email and password, click the "log in" button and you will be taken to a form where you can edit that user account.

Change some fields on that page and click "done" this will send an authenticated `PUT` request to the server as a user. The changed fields will be saved on the server and a json representation will be returned to the iOS client for your verification.

If you close the application and re-open it you will see that the "log in" button is enabled already and you can do so without having to re-enter your user credentials, we can do this because we are saving the access token to disk and reading it in on application start.

## Next Steps

This demo is purposefully bare bones, it is intended to be simple in nature, but to demonstrate token exchange and making authenticated requests. You could fork this project and add additional API endpoints to the client. You can use this project as the boilerplate for your own iOS client for an oPRO backed website.

Make sure to replace the `oClientBaseURLString` the `oClientID` and `oClientSecret` in your `OproAPIClient.h`

``` objective-c
    #define oClientBaseURLString @"https://opro-demo.herokuapp.com/"
    #define oClientID            @"5e163ed8c70cc28e993109c788325307"
    #define oClientSecret        @"898ca5b48548bb3988b3c8469081fcfb"
```

The code in this library will not automatically refresh a stored access token, you will need to implement that behavior. You might also want to add other log in features such as Facebook, twitter, etc.

# iOS Concepts

If you're new to this type of authentication or new to iOS there are some important concepts that will help you modifying this project, or implementing your own project. At a high level we need to first send a valid username and password to the server along with client id and secret. The server will return an access_token we can use to authenticate future requests. We store this access_token and add it as a default header to a shared API client. Now any future web requests will carry the access_token so the server knows that our iOS app is acting on the behalf of the user.

## Get an Access Token with AFNetworking

Before we can make authenticated requests we must exchange our user credentials for an auth token. Once you have the library in your project you will need a client application registered at http://opro-demo.herokuapp.com/oauth_client_apps/new this will return a client_id and a client secret.

In this example we will use these application credentials

    client id:      3234myClientId5678
    client Secret:  14321myClientSecret8765


These are not valid credentials and should be changed to your credentials that you got at http://opro-demo.herokuapp.com/oauth_client_apps/new. Once you have those credentials you can use them to trade a user's email and password for an auth token.

For this example we will use these user credentials:

    email:    foo@example.com
    password: p4ssw0rd

These are not valid credentials and should be changed to a user's credentials that can be obtained at http://opro-demo.herokuapp.com/users/sign_up. Once changed, we can use AFNetworking to send all of these credentials and return an access token:

``` objective-c
    NSDictionary *params = @{ @"username"       : @"foo@example.com",
                              @"password"       : @"p4ssw0rd",
                              @"client_id"      : @"3234myClientId5678",
                              @"client_secret"  : @"14321myClientSecret8765" };
    
    [self POST:@"oauth/token.json"
    parameters:params
       success:^(NSURLSessionDataTask *task, id responseObject) {
            NSLog("Response: %@", responseObject);
       } failure:^(NSURLSessionDataTask *task, NSError *error) {
            NSLog("Error: %@", error);
       }];
```


Again, make sure to replace the username, password, client id, and client secret with your own. Use HTTPS or your request ill not be secure. If you run the above you should get a dictionary printed in your log with an access token and refresh token. We can extract this logic into the method `authenticateUsingOAuthWithUsername` inside the `OproAPIClient.m`. Once we have the access token we can store it to disk for later use, and we can add it to our shared API client to authenticate future requests.


# Making authenticated requests with AFNetworking

We can use AFNetworking to easily make requests to our server.


## Build a Shared Instance of AFHTTPClient subclass

To make authenticated requests we need to set the Authorization header so that every request will have the access token we received. To do this we must subclass `AFHTTPSessionManager`. An example of this subclass is `OproAPIClient` in the project. We can use a shared instance of this subclass to make future requests.

We extracted this to a function so we can store the token to disk so it is available the next time the client application boots:

``` objective-c
    - (void)setAuthorizationWithToken:(NSString *)accessToken refreshToken:(NSString *)refreshToken
    {
        if (accessToken != nil && ![accessToken isEqualToString:@""]) {
            [self setIsAuthenticated:YES];
            [[NSUserDefaults standardUserDefaults] setObject:accessToken forKey:@"kAccessToken"];
            [[NSUserDefaults standardUserDefaults] setObject:refreshToken forKey:@"kRefreshToken"];
        
            [[self requestSerializer] setAuthorizationHeaderFieldWithToken:accessToken];
        }
    }
```

We also set the BOOL property `isAuthenticated` so our shared client knows if it has been authenticated or not.

Next we need to overwrite the `initWithBaseURL`. We can then set our authorization header from the stored value if we want like this:

``` objective-c
    - (id)initWithBaseURL:(NSURL *)url
    {
        self = [super initWithBaseURL:url];
    
        if (self) {
            NSString *accessToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"kAccessToken"];
            NSString *refreshToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"kRefreshToken"];
        
            [self setAuthorizationWithToken:accessToken refreshToken:refreshToken];
        }
    
        return self;
    }
```

Finally we put all of this together to provide a standard interface through a shared client:

``` objective-c
    + (OproAPIClient *) sharedClient
    {
        static OproAPIClient *_sharedClient = nil;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            _sharedClient = [[self alloc] initWithBaseURL:[NSURL URLWithString:oClientBaseURLString]];
        });
        
        return _sharedClient;
    }
```

Make sure to change the value of `oClientBaseURLString` from `https://opro-demo.herokuapp.com/` to your own url. Also be sure to use HTTPS, if anyone sees the header passed to the server they can steal the credentials of that user. This is how programs like firesheep work, by using HTTPS we mitigate and eliminate most of the risks. Now we are ready to set our Authorization header. We can do that like this:

``` objective-c
    - (void)authenticateUsingOAuthWithUsername:(NSString *)username
                                      password:(NSString *)password
                                       success:(void (^)(NSString *accessToken, NSString *refreshToken))success
                                       failure:(void (^)(NSError *))failure
    {
        NSDictionary *params = @{ @"username"       : username,
                                  @"password"       : password,
                                  @"client_id"      : oClientID,
                                  @"client_secret"  : oClientSecret };
        
        [self POST:@"oauth/token.json"
        parameters:params
           success:^(NSURLSessionDataTask *task, id responseObject) {
               NSString *accessToken = responseObject[@"access_token"];
               NSString *refreshToken = responseObject[@"refresh_token"];
               
               [self setAuthorizationWithToken:accessToken refreshToken:refreshToken];
               
               if (success) success(accessToken, refreshToken);
           } failure:^(NSURLSessionDataTask *task, NSError *error) {
               if (failure) failure(error);
           }];
    }
```

### Make Authenticated Request with Shared Interface of OproAPIClient

Once we've set the access token in our `OproAPIClient` we can use the client to make authenticated calls. For example we could get a json representation of a user by getting `/users/me` on our server while authenticated:

``` objective-c
        [[OproAPIClient sharedClient] GET:@"/users/me.json"
                            parameters:nil
                              success:^(NSURLSessionDataTask *task, id responseObject) {
                                    NSLog(@"== Response: %@", responseObject);      
                              } failure:^(NSURLSessionDataTask *task, NSError *error) {
                                  NSLog(@"== Error: %@", [error localizedDescription]);
                              }];
```

If you run that code you will get your authenticated user in JSON representation. In addition to issuing GET requests you can also POST, PUT, and DELETE. For example to update this user you need to PUT to the same path (/users/me). To update attributes you can build a dictionary. For example if we wanted to set the email and twitter we could build this dictionary:

``` objective-c
        NSDictionary *params = @{ @"user":
                                  @{ @"email"   : @"awesome@example.com",
                                     @"twitter" : @"schneems",
                                     @"zip"     : @"11111" }};
```

Then we can pass that dictionary into our request under the "user" key:
``` objective-c
        [[OproAPIClient sharedClient] PUT:@"/users/me.json"
                           parameters:params
                              success:^(NSURLSessionDataTask *task, id responseObject) {
                                    NSLog(@"Success: %@", responseObject);
                              } failure:^(NSURLSessionDataTask *task, NSError *error) {
                                    NSLog(@"== Error: %@", [error localizedDescription]);
                              }];
```

This will show up in the Rails server as a `params` of:

    "user" => {"twitter" => "schneems", "email" => "awesome@example.com"}

To view the code running on the server you can look at the [oPRO Demo Rails app](http://github.com/opro/opro_rails_demo). The call to `/users/me` with a PUT request will hit the update method in `app/controllers/user_controller.rb`.

## Recap

So what did we learn? We need to exchange a username and password for an access token with `AFNetworking` then we can set our authorization header in a shared subclass of `AFHTTPSessionManager`, and finally we can use that authorization header to make authenticated requests to an OAuth powered Ruby on Rails server (using the [oPRO library](http://github.com/opro/opro)). There are problems you can run into every step of the way. Below are some troubleshooting steps that should help.

## Troubleshooting


## Troubleshooting with on the Client

Use `NSLog` liberally to make sure that you have set the authorization header correctly and to make sure you are passing the correct parameters. You may need to do this inside of `OproAPIClient`.

Making authenticated calls to the built in OAuth test controller can give you better error messages. With an authenticated header send a GET request to the `/oauth_tests/show_me_the_money` path. If there are any problems with the request they will be returned to you in a JSON response.

The [oPRO library](http://github.com/opro/opro) has [built in OAuth docs](http://opro-demo.herokuapp.com/oauth_docs) which might be useful if you are new to OAuth, or client side authentication.

## Troubleshooting with access to the Rails Server and logs:

If you cannot get this demo to work with your own oPRO powered Rails app, and you have access to the server and the logs, these are some debugging steps that might help:


If you see CSRF warnings or unexpected redirects in your server log it might be possible that the client is not be sending a proper authorization header. You can double check this by adding this code to your controller:


    Rails.logger.info request.env["HTTP_AUTHORIZATION"].inspect

For a access token of 8bnsyha7ajbmahdujna, you can expect to see a header of something like:

    "Token token=\"8bnsyha7ajbmahdujna\""

You can add this in a before filter in `ApplicationController`


    before_filter :debug


    def debug
      Rails.logger.info "======= Debugging Header ======="
      Rails.logger.info request.env["HTTP_AUTHORIZATION"].inspect
    end

If the header is not present, you need to check the client code to make sure that the Authorization header is being set by calling `setAuthorizationHeaderWithToken` with a valid access_token.

If you see the header being sent you can verify that it is a valid `access_token`, you can do this in the console:

    $ rails console
    > auth_grant = Opro::Oauth::AuthGrant.where(:access_token => "8bnsyha7ajbmahdujna").first
    > puts auth_grant.expired?

If the authorization grant does not exist then the token is not correct. If the grant has expired, the client needs to refresh the token.

If you are not getting a valid access_token from the server while exchanging the username and password, You can also verify that the client id and client secret are correct via the `params` in the server log. On Heroku you can get to your logs by running:

    $ heroku logs --tail


