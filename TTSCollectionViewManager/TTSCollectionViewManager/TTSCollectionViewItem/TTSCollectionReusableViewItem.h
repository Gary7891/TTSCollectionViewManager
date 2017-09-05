//
//  TTSCollectionReusableViewItem.h
//  TTSCollectionViewManager
//
//  Created by Gary on 14/04/2017.
//  Copyright © 2017 czy. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, SupplementaryViewType) {
    /**
     *追加视图的类型，页眉
     */
    SupplementaryViewTypeHeader               =    1,
    /**
     * 追加视图的类型，页脚
     */
    SupplementaryViewTypeFooter               =    2
};

@class TTSCollectionViewSection;


@interface TTSCollectionReusableViewItem : NSObject

@property (nonatomic, weak) TTSCollectionViewSection                *section;


@property (nonatomic, assign) NSInteger                             sectionIndex;


+ (instancetype)item;


@end
