//
//  SchneemsViewController.m
//  oPRO-Demo
//
//  Created by Richard Schneeman on 8/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "OproDemoViewController.h"
#import "OproAPIClient.h"

#import "EditUserViewController.h"

@interface OproDemoViewController ()

@end

@implementation OproDemoViewController
@synthesize getUserCredentialsButton;
@synthesize getAccessTokenButton;

// Calls /users/random.json which will generate a random username and password on the server.
// The server then returns the username and password that we can then use to log in.
// You wouldn't want to do this in your actual app, but it provides for an easy iPhone app demo
// oClientBaseURLString is defined in OproClient.h
- (IBAction)getUserCredentials:(id)sender {  
  [getUserCredentialsButton setEnabled:NO];
  NSURL *url = [NSURL URLWithString:[oClientBaseURLString stringByAppendingString:@"users/random.json"]];
  NSURLRequest *request = [NSURLRequest requestWithURL:url];
  AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
    [userUsernameField setText:[JSON objectForKey:@"username"]];
    [userPasswordField setText:[JSON objectForKey:@"password"]];
    [getAccessTokenButton setEnabled:YES];
    [getAccessTokenButton setHighlighted:YES];
  } failure:nil];
  

  [operation start];
  
}


// Once we have a username and password we can then request an OAuth 2 access token.
// We send the username, password, along with client id and secret found in OproClient.h
// once we get the access_token back we can set the auth headers for any future OproClient requests
// oClientBaseURLString is also defined in OproClient.h
- (IBAction)getAccessToken:(id)sender {
  
  NSURL *url = [NSURL URLWithString:oClientBaseURLString];
  AFOAuth2Client *OAuthClient = [[AFOAuth2Client alloc] initWithBaseURL:url];
  
  [OAuthClient registerHTTPOperationClass:[AFJSONRequestOperation class]];
  [OAuthClient authenticateUsingOAuthWithPath:@"oauth/token.json" username:userUsernameField.text  password:userPasswordField.text clientID:oClientID secret:oClientSecret success:^(AFOAuthAccount *account) {
    // NSLog(@"Success: %@", account);
    // NSLog(@"Token from account: %@", account.credential.accessToken);

    [OproAPIClient setAccessToken:account.credential.accessToken];

    EditUserViewController *viewController = [[EditUserViewController alloc] initWithNibName:@"OproEditUserViewController" bundle:nil];
    [self.navigationController pushViewController:viewController animated:YES];

  } failure:^(NSError *error) {
    NSLog(@"Error: %@", error);
  }];
  

  
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // if username and password fields are present allow the user to submit them
    [userUsernameField addTarget:self action:@selector(checkPasswordUsernamePresence:) forControlEvents:UIControlEventEditingChanged];
    [userPasswordField addTarget:self action:@selector(checkPasswordUsernamePresence:) forControlEvents:UIControlEventEditingChanged];

}

// if username and password fields are present allow the user to submit them
- (void)checkPasswordUsernamePresence:(id)sender
{
  if (![userUsernameField.text isEqualToString:@""] && ![userPasswordField.text isEqualToString:@""]) {
    [getAccessTokenButton setEnabled:YES];
    [getAccessTokenButton setHighlighted:YES];
  }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
  return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

@end
