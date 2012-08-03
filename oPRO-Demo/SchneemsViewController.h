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

#import "AFOAuth2Client.h"

@interface SchneemsViewController : UIViewController
{
NSString *password;
NSString *username;
NSString *access_token;
  
  IBOutlet UIButton *getUserCredentialsButton;
  IBOutlet UIButton *getAccessTokenButton;

}
- (IBAction)getUserCredentials:(id)sender;
- (IBAction)getAccessToken:(id)sender;


@property(retain) IBOutlet UIButton *getUserCredentialsButton;
@property(retain) IBOutlet UIButton *getAccessTokenButton;


@end


