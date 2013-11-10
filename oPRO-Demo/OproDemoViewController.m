//
//  SchneemsViewController.m
//  oPRO-Demo
//
//  Created by Richard Schneeman on 8/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "OproDemoViewController.h"
#import "OproAPIClient.h"

@interface OproDemoViewController ()
- (void)createUserCredentials;
- (void)authenticate;
@end

@implementation OproDemoViewController

#pragma mark - View Lifecycle

////////////////////////////////////////////////////////////////////////
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // if username and password fields are present allow the user to submit them
    [[self usernameTextField] addTarget:self
                                 action:@selector(checkPasswordUsernamePresence:)
                       forControlEvents:UIControlEventEditingChanged];
    [[self passwordTextField] addTarget:self
                                 action:@selector(checkPasswordUsernamePresence:)
                       forControlEvents:UIControlEventEditingChanged];
}

////////////////////////////////////////////////////////////////////////
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

////////////////////////////////////////////////////////////////////////
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark - Custom Actions

////////////////////////////////////////////////////////////////////////
- (IBAction)createUserButtonPressed:(id)sender
{
    [self createUserCredentials];
}

////////////////////////////////////////////////////////////////////////
- (IBAction)loginButtonPressed:(id)sender
{
    [self authenticate];
}

#pragma mark - Private

////////////////////////////////////////////////////////////////////////
// Calls /users/random.json which will generate a random username and password on the server.
// The server then returns the username and password that we can then use to log in.
// You wouldn't want to do this in your actual app, but it provides for an easy iPhone app demo
// this request needs to be a GET request since the APIClient is not yet authenticated
- (void)createUserCredentials
{
    NSLog(@"== Retrieving username and password from server");
    
    [[OproAPIClient sharedClient] createRandomUserWithSuccess:^(NSString *username, NSString *password) {
        NSLog(@"== Successfully retrieved username and password from server");
        
        [[self usernameTextField] setText:username];
        [[self passwordTextField] setText:password];
        [[self loginButton] setEnabled:YES];
    } failure:^(NSError *error) {
        NSLog(@"== Error: %@", [error localizedDescription]);
    }];
}

////////////////////////////////////////////////////////////////////////
// Once we have a username and password we can then request an OAuth 2 access token.
// We send the username, password, along with client id and secret found in OproClient.h
// once we get the access_token back we can set the auth headers for any future OproClient requests.
// If the client was previously authorized and the credentials stored to disk we don't need to re-auth
// we can direct the user to the next view where they should be authorized.
- (void)authenticate
{
    NSLog(@"== Authenticating username and password from server");
    
    NSString *username = [[self usernameTextField] text];
    NSString *password = [[self passwordTextField] text];
    
    [[OproAPIClient sharedClient] authenticateUsingOAuthWithUsername:username
                                                            password:password
                                                             success:^(NSString *accessToken, NSString *refreshToken) {
                                                                 NSLog(@"== Auth success: %@", accessToken);
                                                                 [[self delegate] oproDemoViewControllerDidAuthenticate:self];
                                                             } failure:^(NSError *error) {
                                                                 NSLog(@"== Auth failure: %@", [error localizedDescription]);
                                                             }];
}

////////////////////////////////////////////////////////////////////////
// if username and password fields are present allow the user to submit them
- (void)checkPasswordUsernamePresence:(id)sender
{
    NSString *username = [[self usernameTextField] text];
    NSString *password = [[self passwordTextField] text];
    
    if (![username isEqualToString:@""] && ![password isEqualToString:@""]) {
        [[self loginButton] setEnabled:YES];
    }
}

@end
