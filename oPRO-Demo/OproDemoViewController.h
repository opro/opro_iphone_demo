//
//  SchneemsViewController.h
//  oPRO-Demo
//
//  Created by Richard Schneeman on 8/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OproDemoViewController : UIViewController
//{
//  NSString *access_token;
//  
//  // button variables
//  IBOutlet UIButton *getUserCredentialsButton;
//  IBOutlet UIButton *getAccessTokenButton;
//
//  // text field variables
//  IBOutlet UITextField *userPasswordField;
//  IBOutlet UITextField *userUsernameField;
//}
//- (IBAction)getUserCredentials:(id)sender;
//- (IBAction)logUserIn:(id)sender;
//
//// button outlets
//@property(retain) IBOutlet UIButton *getUserCredentialsButton;
//@property(retain) IBOutlet UIButton *getAccessTokenButton;

@property (nonatomic, weak) IBOutlet UITextField *usernameTextField;
@property (nonatomic, weak) IBOutlet UITextField *passwordTextField;
@property (nonatomic, weak) IBOutlet UIButton *loginButton;

- (IBAction)createUserButtonPressed:(id)sender;
- (IBAction)loginButtonPressed:(id)sender;

@end


