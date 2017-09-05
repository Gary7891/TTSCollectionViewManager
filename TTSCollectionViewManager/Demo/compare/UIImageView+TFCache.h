//
//  UIImageView+TFCache.h
//  BBFoundation
//
//  Created by Gary on 5/26/15.
//  Copyright (c) 2014 BBFoundation. All rights reserved.
//

#import "SDWebImageManager.h"

@interface UIImageView (TFCache)

/**
 *  加载网络图片
 *
 *  @param url 图片url
 *  @param placeholder 占位图
 *  @param animated 是否启用动画
 *  @param faceAware 是否启用人脸识别
 */
- (void)tf_setImageWithURL:(NSURL *)url
          placeholderImage:(UIImage *)placeholder
                  animated:(BOOL)animated
                 faceAware:(BOOL)faceAware;

- (void)tf_setImageWithURL:(NSURL *)url
          placeholderImage:(UIImage *)placeholder
                 completed:(SDExternalCompletionBlock)completedBlock
                  animated:(BOOL)animated
                 faceAware:(BOOL)faceAware;

- (void)tf_setImageWithURL:(NSURL *)url
          placeholderImage:(UIImage *)placeholder
                   options:(SDWebImageOptions)options
                  progress:(SDWebImageDownloaderProgressBlock)progressBlock
                 completed:(SDExternalCompletionBlock)completedBlock
                  animated:(BOOL)animated
                 faceAware:(BOOL)faceAware;


@end
