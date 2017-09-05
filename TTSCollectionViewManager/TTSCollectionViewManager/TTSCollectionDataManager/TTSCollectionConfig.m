//
//  TTSCollectionConfig.m
//  TTSCollectionViewManager
//
//  Created by Gary on 07/04/2017.
//  Copyright © 2017 czy. All rights reserved.
//

#import "TTSCollectionConfig.h"



NSString *const kTTSCollectionDataSourceClassKey   = @"kTTSCollectionDataSourceClassKey";
NSString *const kTTSCollectionUrlKey               = @"kTTSCollectionUrlKey";
NSString *const kTTSCollectionDataManagerClassKey  = @"kTTSCollectionDataManagerClassKey";


@interface TTSCollectionConfig ()

@property (nonatomic ,strong) NSMutableDictionary *mappingInfo;

@end

@implementation TTSCollectionConfig


+ (void)enableLog {
    isEnable = YES;
}

+ (void)disableLog {
    isEnable = NO;
}

+ (BOOL)isLogEnable {
    return isEnable;
}


+ (void)setPageSize:(NSInteger)size {
    kTTSPageSize = size;
}

+ (NSInteger)pageSize {
    return kTTSPageSize;
}

+ (TTSCollectionConfig *)sharedInstance {
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _mappingInfo = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)mapWithMappingInfo:(NSDictionary *)mapInfo {
    [_mappingInfo setValuesForKeysWithDictionary:mapInfo];
}

- (Class)dataSourceByListType:(NSInteger)listType {
    NSDictionary *entry = [_mappingInfo objectForKey:[NSNumber numberWithInteger:listType]];
    if (!entry) {
        entry = [_mappingInfo objectForKey:[NSNumber numberWithInteger:0]];
    }
    NSString *dataSourceClassName =[entry objectForKey:kTTSCollectionDataSourceClassKey];
    if (!dataSourceClassName) {
        dataSourceClassName = @"TTSCollectionViewDataSource";
    }
    return NSClassFromString(dataSourceClassName);
}

- (NSString*)urlByListType:(NSInteger)listType {
    NSDictionary *entry = [_mappingInfo objectForKey:[NSNumber numberWithInteger:listType]];
    if (!entry) {
        entry = [_mappingInfo objectForKey:[NSNumber numberWithInteger:0]];
    }
    NSString *url = [entry objectForKey:kTTSCollectionUrlKey];
    if (!url) {
        url = @"/defaulturl";
    }
    return url;
}

- (Class)dataManagerByListType:(NSInteger)listType {
    NSDictionary *entry = [_mappingInfo objectForKey:[NSNumber numberWithInteger:listType]];
    if (!entry) {
        entry = [_mappingInfo objectForKey:[NSNumber numberWithInteger:0]];
    }
    NSString *dataMnagerClassName = [entry objectForKey:kTTSCollectionDataManagerClassKey];
    if (!dataMnagerClassName) {
        dataMnagerClassName = @"TTSCollectionViewDataManager";
    }
    return NSClassFromString(dataMnagerClassName) ;
}

@end
