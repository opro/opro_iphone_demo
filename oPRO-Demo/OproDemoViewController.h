//
//  SchneemsViewController.h
//  oPRO-Demo
//
//  Created by Richard Schneeman on 8/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AFHTTPClient.h"
#import "AFJSONRequestOperation.h"


@interface OproDemoViewController : UIViewController
{
  NSString *access_token;
  
  // button variables
  IBOutlet UIButton *getUserCredentialsButton;
  IBOutlet UIButton *getAccessTokenButton;

  // text field variables
  IBOutlet UITextField *userPasswordField;
  IBOutlet UITextField *userUsernameField;
}
- (IBAction)getUserCredentials:(id)sender;
- (IBAction)getAccessToken:(id)sender;

// button outlets
@property(retain) IBOutlet UIButton *getUserCredentialsButton;
@property(retain) IBOutlet UIButton *getAccessTokenButton;

// text field outlets
//@property(retain) IBOutlet UITextField *userUsernameField;
//@property(retain) IBOutlet UITextField *userPasswordField;

@end


