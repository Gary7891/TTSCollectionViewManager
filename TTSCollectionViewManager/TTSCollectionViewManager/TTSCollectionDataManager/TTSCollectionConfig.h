//
//  TTSCollectionConfig.h
//  TTSCollectionViewManager
//
//  Created by Gary on 07/04/2017.
//  Copyright © 2017 czy. All rights reserved.
//

#import <Foundation/Foundation.h>

#define TTSCollectionViewLogDebug(frmt, ...)\
if ([TTSCollectionConfig isLogEnable]) {\
NSLog(@"[TTSCollectionViewDataSource Debug]: %@", [NSString stringWithFormat:(frmt), ##__VA_ARGS__]);\
}


static BOOL isEnable = YES;

static NSInteger kTTSPageSize = 20;

extern NSString *const kTTSCollectionDataSourceClassKey;
extern NSString *const kTTSCollectionUrlKey;
extern NSString *const kTTSCollectionDataManagerClassKey;

@interface TTSCollectionConfig : NSObject

+ (void)enableLog;

+ (void)disableLog;

+ (BOOL)isLogEnable;

+ (void)setPageSize:(NSInteger)size;

+ (NSInteger)pageSize;

+ (TTSCollectionConfig *)sharedInstance;

- (void)mapWithMappingInfo:(NSDictionary *)mapInfo;


- (Class)dataSourceByListType:(NSInteger)listType;

- (NSString*)urlByListType:(NSInteger)listType;

- (Class)dataManagerByListType:(NSInteger)listType;

@end
