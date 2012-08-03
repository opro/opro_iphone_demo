//
//  OproClient.h
//  
//
//  Created by Richard Schneeman on 8/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AFHTTPClient.h"

@interface OproClient : AFHTTPClient

+ (OproClient *) sharedClient;
+ (void)setAccessToken:(NSString *)access_token;
#define oClientBaseURLString @"https://opro-demo.herokuapp.com/"

@end
