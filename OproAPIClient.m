//
//  OproClient.m
//  
//
//  Created by Richard Schneeman on 8/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "OproAPIClient.h"

#import "AFJSONRequestOperation.h"

static NSString *oauthAccessToken;

@implementation OproAPIClient

+ (OproAPIClient *) sharedClient{
  static OproAPIClient *_sharedClient = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    _sharedClient = [[self alloc] initWithBaseURL:[NSURL URLWithString:oClientBaseURLString]];
  });
  return _sharedClient;
}

+ (void) setAccessToken:(NSString *)access_token {
  if (oauthAccessToken != access_token) {
    oauthAccessToken = [access_token copy];
  }
}

+ (NSString*)oauthAccessToken {
  return oauthAccessToken;
}

- (id)initWithBaseURL:(NSURL *)url {
  self = [super initWithBaseURL:url];
  if (!self) {
    return nil;
  }
  [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
	[self setDefaultHeader:@"Accept" value:@"application/json"];
  if (oauthAccessToken) {
    [self setAuthorizationHeaderWithToken:oauthAccessToken];
  }
  return self;
}

@end
