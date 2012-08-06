//
//  OproClient.h
//  
//
//  Created by Richard Schneeman on 8/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AFHTTPClient.h"

@interface OproAPIClient : AFHTTPClient

+ (OproAPIClient *) sharedClient;
+ (void)setAccessToken:(NSString *)access_token;

#define oClientBaseURLString @"https://opro-demo.herokuapp.com/"
#define oClientID            @"5e163ed8c70cc28e993109c788325307"
#define oClientSecret        @"898ca5b48548bb3988b3c8469081fcfb"

@end
