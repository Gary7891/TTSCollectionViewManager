//
//  BBAppDotNetAPIClient.m
//  BBNetwork
//
//  Created by Gary on 12/04/2017.
//  Copyright © 2017 Gary. All rights reserved.
//

#import "BBAppDotNetAPIClient.h"

static NSString * const BBAppDotNetAPIBaseURLString = @"https://api.app.net/";

@implementation BBAppDotNetAPIClient


+ (instancetype)sharedClient {
    static BBAppDotNetAPIClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[BBAppDotNetAPIClient alloc] initWithBaseURL:[NSURL URLWithString:BBAppDotNetAPIBaseURLString]];
        _sharedClient.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    });
    
    return _sharedClient;
}

@end
