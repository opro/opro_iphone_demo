//
//  SchneemsViewController.m
//  oPRO-Demo
//
//  Created by Richard Schneeman on 8/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SchneemsViewController.h"
#import "OproClient.h"


@interface SchneemsViewController ()

@end

@implementation SchneemsViewController
@synthesize getUserCredentialsButton;
@synthesize getAccessTokenButton;


- (IBAction)getUserCredentials:(id)sender {  
  [getUserCredentialsButton setEnabled:NO];
  NSURL *url = [NSURL URLWithString:[oClientBaseURLString stringByAppendingString:@"users/random.json"]];
  NSURLRequest *request = [NSURLRequest requestWithURL:url];
  AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
    // NSLog(@"Response: %@", JSON);
    password = [JSON objectForKey:@"password"];
    username = [JSON objectForKey:@"username"];
    [getAccessTokenButton setEnabled:YES];
    [getAccessTokenButton setHighlighted:YES];
  } failure:nil];
  

  [operation start];
  
}

- (IBAction)getAccessToken:(id)sender {
NSLog(@"Foo");
  
  NSURL *url = [NSURL URLWithString:oClientBaseURLString];
  AFOAuth2Client *OAuthClient = [[AFOAuth2Client alloc] initWithBaseURL:url];
  //    AFJSONRequestOperation.set
  
  [OAuthClient registerHTTPOperationClass:[AFJSONRequestOperation class]];

  NSLog(@"Username: %@", username);  
  NSLog(@"Password: %@", password);
  
  [OAuthClient authenticateUsingOAuthWithPath:@"oauth/token.json" username:username password:password clientID:@"5e163ed8c70cc28e993109c788325307" secret:@"898ca5b48548bb3988b3c8469081fcfb" success:^(AFOAuthAccount *account) {
    NSLog(@"Success: %@", account);
    NSLog(@"Foo: %@", account.credential.accessToken);
    [OproClient setAccessToken:account.credential.accessToken];
//    [AFHTTPClient setAuthorizationHeaderWithToken:account.credential.accessToken];
  } failure:^(NSError *error) {
    NSLog(@"Error: %@", error);
  }];
  password = @"";
  username = @"";
  
  
  
  [[OproClient sharedClient] getPath:@"/users/me" parameters:[NSDictionary dictionary] success:^(AFHTTPRequestOperation *operation, id responseObject) {
    NSLog(@"Success: %@", responseObject);
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    NSLog(@"Error: %@", error);
  }];
  
  
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
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
