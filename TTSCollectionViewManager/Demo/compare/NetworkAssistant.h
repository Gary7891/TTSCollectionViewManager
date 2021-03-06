//
//  NetworkAssistant.h
//  TFProject
//
//  Created by Gary on 8/20/14.
//  Copyright (c) 2014 BBFoundation. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>



extern NSString*  BB_APP_ERROR_DOMAIN;
/////////////////////////////////////////////Common Error Code//////////////////////////////////////
extern NSInteger const kBBErrorCodeUnknown         ;
extern NSInteger const kBBErrorCodeAPI             ;
extern NSInteger const kBBErrorCodeHTTP            ;
extern NSInteger const kBBErrorCodeNetwork         ;
extern NSInteger const kBBErrorCodeEmpty           ;

typedef NS_ENUM(NSInteger, NetWorkActionType)
{
    NetWorkActionTypeGet  = 0,
    NetWorkActionTypePost = 1,
    NetWorkActionTypePut  = 2
};

typedef void (^NetWorkProgressBlock)(double percentDone,long totalBytesWritten);

typedef NSString* (^NetWorkUrlBlock)(NSString *interface) ;

typedef void (^NetWorkErrorCodeBlock)(NSInteger errorCode);


@interface NetworkAssistant : NSObject

+ (instancetype)sharedAssistant;

@property (nonatomic ,assign) double progress;
/**
 *  请求头信息字典
 */
@property (nonatomic, copy) NSDictionary *headerDic;
@property (nonatomic, strong) NetWorkErrorCodeBlock errorCodeBlock;

@property (nonatomic, strong) NetWorkUrlBlock urlBlock;

- (void)getDataByURL:(NSString *)url
              params:(NSDictionary *)params
            fileData:(NSMutableArray *)fileData
                 hud:(NSString *)hud
               start:(void (^)(id cacheResult))startBlock
           completed:(void (^)(id result,NSError *error))completedBlock;

- (void)postDataByURL:(NSString *)url
               params:(NSDictionary *)params
             fileData:(NSMutableArray *)fileData
                  hud:(NSString *)hud
                start:(void (^)(id cacheResult))startBlock
            completed:(void (^)(id result,NSError *error))completedBlock
             progress:(NetWorkProgressBlock)progressBlock;


- (void)putImageData:(UIImage *)image hashID:(NSUInteger)hashID  ;

- (void)searchImageData:(UIImage *)image;


@end
