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

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  [[OproAPIClient sharedClient] getPath:@"/users/me" parameters:[NSDictionary dictionary] success:^(AFHTTPRequestOperation *operation, id responseObject) {
    // NSLog(@"Success: %@", responseObject);
    [userEmailField setText:[responseObject objectForKey:@"email"]];
    NSString *twitter = [responseObject objectForKey:@"twitter"];
    NSString *zip = [responseObject objectForKey:@"zip"];
    
    if (twitter != (id)[NSNull null]) {
      [userTwitterField setText:twitter];
    }
    
    if (zip != (id)[NSNull null]) {
      [userZipField setText:zip];
    }
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(updateUser:)];
    self.navigationItem.rightBarButtonItem.enabled = YES;
    
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    NSLog(@"Error: %@", error);
  }];

  
}


- (void)updateUser:(id)sender {  
  
  NSMutableDictionary *mutableUserParameters = [NSMutableDictionary dictionary];
  [mutableUserParameters setValue:userEmailField.text forKey:@"email"];
  [mutableUserParameters setValue:userTwitterField.text forKey:@"twitter"];
  [mutableUserParameters setValue:userZipField.text forKey:@"zip"];

  [[OproAPIClient sharedClient] putPath:@"/users/me" parameters:[NSDictionary dictionaryWithObject:mutableUserParameters forKey:@"user"] success:^(AFHTTPRequestOperation *operation, id responseObject) {
    // NSLog(@"Success: %@", responseObject);
    [successLabel setText: [NSString stringWithFormat:@"Updated User with attributes:%@ ", responseObject] ];
    [userEmailField resignFirstResponder];
    [userTwitterField resignFirstResponder];
    [userZipField resignFirstResponder];
    
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    NSLog(@"Error: %@", error);
  }];
  
}



@end


