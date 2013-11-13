//
//  OproClient.h
//  
//
//  Created by Richard Schneeman on 8/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFHTTPSessionManager.h>

@interface OproAPIClient : AFHTTPSessionManager

@property (nonatomic, assign) BOOL isAuthenticated;

+ (instancetype)sharedClient;

- (void)createRandomUserWithSuccess:(void (^) (NSString *username, NSString *password))success
                            failure:(void (^)(NSError *error))failure;
- (void)authenticateUsingOAuthWithUsername:(NSString *)username
                                  password:(NSString *)password
                                   success:(void (^)(NSString *accessToken, NSString *refreshToken))success
                                   failure:(void (^)(NSError *error))failure;
- (void)logout;

// Credentials for the opro demo server you will can modify oClientID and oClientSecret
#define oClientBaseURLString @"https://opro-demo.herokuapp.com/"
#define oClientID            @"bd443d6eb471fb36fb80481079bbc226"
#define oClientSecret        @"0065ff3ac5940e42577756e0d8a74272"

// Credentials if the server is local, you will need to modify oClientID and oClientSecret
//#define oClientBaseURLString @"http://localhost:3000/"
//#define oClientID            @"26fd86d45627c8a5b8cf358f47a71d0c"
//#define oClientSecret        @"f22a76c88f5af8937ad64abefcf1ff37"




@end
