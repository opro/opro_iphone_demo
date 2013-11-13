//
//  OproClient.m
//  
//
//  Created by Richard Schneeman on 8/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "OproAPIClient.h"

@interface OproAPIClient ()
- (void)setAuthorizationWithToken:(NSString *)accessToken refreshToken:(NSString *)refreshToken;
@end

@implementation OproAPIClient

////////////////////////////////////////////////////////////////////////
+ (instancetype)sharedClient
{
    static OproAPIClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[OproAPIClient alloc] initWithBaseURL:[NSURL URLWithString:oClientBaseURLString]];
    });
    
    return _sharedClient;
}

////////////////////////////////////////////////////////////////////////
- (id)initWithBaseURL:(NSURL *)url
{
    self = [super initWithBaseURL:url];
    
    if (self) {
        NSString *accessToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"kAccessToken"];
        NSString *refreshToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"kRefreshToken"];
        
        [self setAuthorizationWithToken:accessToken refreshToken:refreshToken];
    }
    
    return self;
}

////////////////////////////////////////////////////////////////////////
- (void)authenticateUsingOAuthWithUsername:(NSString *)username
                                  password:(NSString *)password
                                   success:(void (^)(NSString *accessToken, NSString *refreshToken))success
                                   failure:(void (^)(NSError *))failure
{
    NSDictionary *params = @{ @"username"       : username,
                              @"password"       : password,
                              @"client_id"      : oClientID,
                              @"client_secret"  : oClientSecret };
    
    [self POST:@"oauth/token.json"
    parameters:params
       success:^(NSURLSessionDataTask *task, id responseObject) {
           NSString *accessToken = responseObject[@"access_token"];
           NSString *refreshToken = responseObject[@"refresh_token"];
           
           [self setAuthorizationWithToken:accessToken refreshToken:refreshToken];
           
           if (success) success(accessToken, refreshToken);
       } failure:^(NSURLSessionDataTask *task, NSError *error) {
           if (failure) failure(error);
       }];
}

////////////////////////////////////////////////////////////////////////
- (void)createRandomUserWithSuccess:(void (^)(NSString *username, NSString *password))success
                            failure:(void (^)(NSError *error))failure
{
    [self GET:@"users/random.json"
   parameters:nil
      success:^(NSURLSessionDataTask *task, id responseObject) {
          NSString *username = responseObject[@"username"];
          NSString *password = responseObject[@"password"];
          
          if (success) success(username, password);
      } failure:^(NSURLSessionDataTask *task, NSError *error) {
          if (error) failure(error);
      }];
}

////////////////////////////////////////////////////////////////////////
- (void)logout
{
    [self setIsAuthenticated:NO];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"kAccessToken"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"kRefreshToken"];
    
    [[self requestSerializer] setAuthorizationHeaderFieldWithToken:nil];
}

#pragma mark - Private

////////////////////////////////////////////////////////////////////////
- (void)setAuthorizationWithToken:(NSString *)accessToken refreshToken:(NSString *)refreshToken
{
    if (accessToken != nil && ![accessToken isEqualToString:@""]) {
        [self setIsAuthenticated:YES];
        [[NSUserDefaults standardUserDefaults] setObject:accessToken forKey:@"kAccessToken"];
        [[NSUserDefaults standardUserDefaults] setObject:refreshToken forKey:@"kRefreshToken"];
        
        [[self requestSerializer] setAuthorizationHeaderFieldWithToken:accessToken];
    }
}

@end
