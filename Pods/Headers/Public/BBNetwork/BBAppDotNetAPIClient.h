//
//  BBAppDotNetAPIClient.h
//  BBNetwork
//
//  Created by Gary on 12/04/2017.
//  Copyright © 2017 Gary. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>

@interface BBAppDotNetAPIClient : AFHTTPSessionManager


+ (instancetype)sharedClient;

@end
