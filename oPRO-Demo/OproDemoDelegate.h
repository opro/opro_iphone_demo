//
//  SchneemsAppDelegate.h
//  oPRO-Demo
//
//  Created by Richard Schneeman on 8/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OproDemoViewController;

@interface OproDemoDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) OproDemoViewController *viewController;

@end
