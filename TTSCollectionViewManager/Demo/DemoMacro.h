//
//  DemoMacro.h
//  TTSCollectionViewManager
//
//  Created by Gary on 10/04/2017.
//  Copyright © 2017 czy. All rights reserved.
//

// 列表类型定义
typedef NS_ENUM(NSInteger, ListType) {
    /**
     *  正常加载
     */
    ListTypeNone                           = 0,
    /**
     * 商品推荐列表
     */
    ListTypeRecommandProductList           =  1,
    
    
};

// View操作类型定义
typedef NS_ENUM (NSInteger, ViewActionType) {
    /**
     *  列表Cell点击
     */
    ViewActionTypeItemClick                     = 0,
    /**
     *  列表Cell点击
     */
    ViewActionTypeUpdateCart                     = 1,
    
};

#define TT_Global_Api_Domain  @"http://120.55.164.111:8084/api"
#define TT_Global_Photo_Domain   @"http://tticarpre.oss-cn-shanghai.aliyuncs.com/"
#define INTERFACE_PRODUCTS    @"/visitor/goods"
#define DEFAULT_ACCESS_TOKEN        @"Basic Zm9vOmJhcg=="
#define APP_VERSION                 [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]
#define IMAGESCALESCHEME(pre,url,width,height) [NSString stringWithFormat:@"%@%@?x-oss-process=image/resize,w_%@,h_%@",pre,url,@(width * [UIScreen mainScreen].scale),@(height * [UIScreen mainScreen].scale)]
