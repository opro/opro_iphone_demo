//
//  EditUserViewController.m
//  oPRO-Demo
//
//  Created by schneems on 8/8/12.
//
//

#import "EditUserViewController.h"
#import "OproDemoViewController.h"
#import "OproAPIClient.h"

@interface EditUserViewController () <OproDemoViewControllerDelegate>
- (void)getCurrentUser;
- (void)updateUser;
- (void)logoutUser;
- (void)presentLoginIfNotAuthenticated;
- (void)clearInputFields;
@end

@implementation EditUserViewController

#pragma mark - View Lifecycle

////////////////////////////////////////////////////////////////////////
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self presentLoginIfNotAuthenticated];
}

////////////////////////////////////////////////////////////////////////
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"LoginSegue"]) {
        UINavigationController *navController = [segue destinationViewController];
        OproDemoViewController *viewController = [[navController viewControllers] lastObject];
        [viewController setDelegate:self];
    }
}

#pragma mark - OproDemoViewControllerDelegate;

////////////////////////////////////////////////////////////////////////
- (void)oproDemoViewControllerDidAuthenticate:(OproDemoViewController *)viewController
{
    [self dismissViewControllerAnimated:YES completion:nil];
    [self getCurrentUser];
}

#pragma mark - Custom Actions

////////////////////////////////////////////////////////////////////////
- (IBAction)updateAccountButtonPressed:(id)sender
{
    [self updateUser];
}

////////////////////////////////////////////////////////////////////////
- (IBAction)logoutButtonPressed:(id)sender
{
    [self logoutUser];
}

#pragma mark - Private

////////////////////////////////////////////////////////////////////////
- (void)presentLoginIfNotAuthenticated
{
    if (![[OproAPIClient sharedClient] isAuthenticated]) {
        [self performSegueWithIdentifier:@"LoginSegue" sender:self];
    } else {
        [self getCurrentUser];
    }
}

////////////////////////////////////////////////////////////////////////
// Retrieve the user attributes from the server here, by now we are relying
// on our shared client to have it's authorization header set.
- (void)getCurrentUser
{
    NSLog(@"== Using OAuth credentials to retrieve user data");

    [[OproAPIClient sharedClient] GET:@"/users/me.json"
                           parameters:nil
                              success:^(NSURLSessionDataTask *task, id responseObject) {
                                  NSString *email = responseObject[@"email"];
                                  NSString *twitter = responseObject[@"twitter"];
                                  NSString *zip = responseObject[@"zip"];
                                  
                                  [[self emailTextField] setText:email];
                                  
                                  if (twitter != (id)[NSNull null]) {
                                      [[self twitterTextField] setText:twitter];
                                  }
                                  
                                  if (zip != (id)[NSNull null]) {
                                      [[self zipTextField] setText:zip];
                                  }
                              } failure:^(NSURLSessionDataTask *task, NSError *error) {
                                  NSLog(@"== Error: %@", [error localizedDescription]);
                              }];
}

////////////////////////////////////////////////////////////////////////
// Update the user on the server by sending the fields to '/users/me' via a PUT request
- (void)updateUser
{
    NSString *email = [[self emailTextField] text];
    NSString *twitter = [[self twitterTextField] text];
    NSString *zip = [[self zipTextField] text];
    
    NSDictionary *params = @{ @"user":
                                  @{ @"email"   : email,
                                     @"twitter" : twitter,
                                     @"zip"     : zip }};
    
    NSLog(@"== Setting data on server via PUT request: user: %@ ", params);
    
    [[OproAPIClient sharedClient] PUT:@"/users/me.json"
                           parameters:params
                              success:^(NSURLSessionDataTask *task, id responseObject) {
                                  NSString *successText = [NSString stringWithFormat:@"User: %@", responseObject];
                                  [[self successLabel] setText:successText];
                                  [[self successLabel] sizeToFit];
                                  [[self emailTextField] resignFirstResponder];
                                  [[self twitterTextField] resignFirstResponder];
                                  [[self zipTextField] resignFirstResponder];
                              } failure:^(NSURLSessionDataTask *task, NSError *error) {
                                  NSLog(@"== Error: %@", [error localizedDescription]);
                              }];
}

////////////////////////////////////////////////////////////////////////
- (void)clearInputFields
{
    [[self successLabel] setText:@""];
    [[self emailTextField] setText:@""];
    [[self twitterTextField] setText:@""];
    [[self zipTextField] setText:@""];
}

////////////////////////////////////////////////////////////////////////
- (void)logoutUser
{
    [[OproAPIClient sharedClient] logout];
    [self clearInputFields];
    [self presentLoginIfNotAuthenticated];
}

@end


