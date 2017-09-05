//
//  TTSCollectionViewRequest.h
//  TTSCollectionViewManager
//
//  Created by Gary on 10/04/2017.
//  Copyright © 2017 czy. All rights reserved.
//

#import <BBNetwork/BBNetwork.h>

@interface TTSCollectionViewRequest : BBRequest

@property (nonatomic ,copy) NSString *requestURL;
@property (nonatomic ,strong) NSDictionary *requestArgument;
@property (nonatomic ,assign) NSInteger cacheTimeInSeconds;
@property (strong, nonatomic) id sensitiveData;
- (instancetype)initWithRequestURL:(NSString *)url params:(NSDictionary *)params;


- (void)startWithOutCacheSuccess:(BBRequestCompletionBlock)success failure:(BBRequestCompletionBlock)failure;

@end
