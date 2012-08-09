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

+ (NSString *)oauthAccessToken;

+ (OproAPIClient *) sharedClient;



+ (void)setAccessToken:(NSString *)access_token;

// Credentials for the opro demo server you will can modify oClientID and oClientSecret
#define oClientBaseURLString @"https://opro-demo.herokuapp.com/"
#define oClientID            @"5e163ed8c70cc28e993109c788325307"
#define oClientSecret        @"898ca5b48548bb3988b3c8469081fcfb"

// Credentials if the server is local, you will need to modify oClientID and oClientSecret
//#define oClientBaseURLString @"http://localhost:3000/"
//#define oClientID            @"26fd86d45627c8a5b8cf358f47a71d0c"
//#define oClientSecret        @"f22a76c88f5af8937ad64abefcf1ff37"




@end
