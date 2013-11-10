//
//  EditUserViewController.m
//  oPRO-Demo
//
//  Created by schneems on 8/8/12.
//
//

#import "EditUserViewController.h"

#import "OproAPIClient.h"

@implementation EditUserViewController

- (void)viewDidLoad {
//
//  NSLog(@"== Opening Edit User View");
//  [super viewDidLoad];
//  self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(updateUser:)];
//  self.navigationItem.rightBarButtonItem.enabled = NO;
//  
//  // Retrieve the user attributes from the server here, by now we are relying
//  // on our shared client to have it's authorization header set.
//  NSLog(@"== Using OAuth credentials to retrieve user data");
//  [[OproAPIClient sharedClient] getPath:@"/users/me" parameters:[NSDictionary dictionary] success:^(AFHTTPRequestOperation *operation, id responseObject) {
//    NSLog(@"== Received User data: %@", responseObject);
//    [userEmailField setText:[responseObject objectForKey:@"email"]];
//    NSString *twitter = [responseObject objectForKey:@"twitter"];
//    NSString *zip = [responseObject objectForKey:@"zip"];
//    
//    if (twitter != (id)[NSNull null]) {
//      [userTwitterField setText:twitter];
//    }
//    
//    if (zip != (id)[NSNull null]) {
//      [userZipField setText:zip];
//    }
//    
//    self.navigationItem.rightBarButtonItem.enabled = YES;
//    
//    NSLog(@"== Edit fields and select 'done' to modify entry on server");
//  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//    NSLog(@"Error: %@", error);
//  }];
}


// Update the user on the server by sending the fields to '/users/me' via a PUT request
- (void)updateUser:(id)sender {  
//  
//  NSMutableDictionary *mutableUserParameters = [NSMutableDictionary dictionary];
//  [mutableUserParameters setValue:userEmailField.text forKey:@"email"];
//  [mutableUserParameters setValue:userTwitterField.text forKey:@"twitter"];
//  [mutableUserParameters setValue:userZipField.text forKey:@"zip"];
//
//  NSLog(@"== Setting data on server via PUT request: user: %@ ", mutableUserParameters);
//  [[OproAPIClient sharedClient] putPath:@"/users/me" parameters:[NSDictionary dictionaryWithObject:mutableUserParameters forKey:@"user"] success:^(AFHTTPRequestOperation *operation, id responseObject) {
//    [successLabel setText: [NSString stringWithFormat:@"Updated User with attributes:%@ ", responseObject] ];
//    [userEmailField resignFirstResponder];
//    [userTwitterField resignFirstResponder];
//    [userZipField resignFirstResponder];
//    
//  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//    NSLog(@"Error: %@", error);
//  }];
}



@end


