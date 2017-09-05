//
//  TTSCollectionViewRequest.m
//  TTSCollectionViewManager
//
//  Created by Gary on 10/04/2017.
//  Copyright © 2017 czy. All rights reserved.
//

#import "TTSCollectionViewRequest.h"

@implementation TTSCollectionViewRequest


- (instancetype)initWithRequestURL:(NSString *)url params:(NSDictionary *)params {
    self = [super init];
    if (self) {
        _requestURL = url;
        _requestArgument = params;
        _cacheTimeInSeconds = -1;
    }
    return self;
}

- (NSInteger)cacheTimeInSeconds {
    return _cacheTimeInSeconds;
}

- (NSString *)requestUrl {
    return _requestURL;
}

- (id)requestArgument {
    return _requestArgument;
}

- (BBRequestMethod)requestMethod {
    return BBRequestMethodGet;
}

- (BBRequestSerializerType)requestSerializerType {
    return BBRequestSerializerTypeHTTP;
}

- (BBResponseSerializerType)responseSerializerType {
    return BBResponseSerializerTypeJSON;
}

- (id)cacheSensitiveData {
    return self.sensitiveData;
}

#pragma mark - Public
- (void)startWithOutCacheSuccess:(BBRequestCompletionBlock)success failure:(BBRequestCompletionBlock)failure {
    [self setCompletionBlockWithSuccess:success failure:failure];
    [self startWithoutCache];
}

@end
