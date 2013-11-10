//
//  SchneemsViewController.h
//  oPRO-Demo
//
//  Created by Richard Schneeman on 8/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OproDemoViewController : UIViewController

@property (nonatomic, weak) IBOutlet UITextField *usernameTextField;
@property (nonatomic, weak) IBOutlet UITextField *passwordTextField;
@property (nonatomic, weak) IBOutlet UIButton *createUserButton;
@property (nonatomic, weak) IBOutlet UIButton *loginButton;

- (IBAction)createUserButtonPressed:(id)sender;
- (IBAction)loginButtonPressed:(id)sender;

@end


