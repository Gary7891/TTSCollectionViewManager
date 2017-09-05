//
//  ASBBCollectionReusableViewItem.h
//  ASBBCollectionViewManager
//
//  Created by Gary on 01/06/2017.
//  Copyright © 2017 czy. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, ASSupplementaryViewType) {
    /**
     *追加视图的类型，页眉
     */
    ASSupplementaryViewTypeHeader               =    1,
    /**
     * 追加视图的类型，页脚
     */
    ASSupplementaryViewTypeFooter               =    2
};

@class ASBBCollectionViewSection;

@interface ASBBCollectionReusableViewItem : NSObject


@property (nonatomic, weak) ASBBCollectionViewSection                *section;


@property (nonatomic, assign) NSInteger                             sectionIndex;


+ (instancetype)item;

@end
