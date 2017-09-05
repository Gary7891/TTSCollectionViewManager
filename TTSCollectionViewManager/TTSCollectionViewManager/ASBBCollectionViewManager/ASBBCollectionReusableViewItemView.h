//
//  ASBBCollectionReusableViewItemView.h
//  ASBBCollectionViewManager
//
//  Created by Gary on 01/06/2017.
//  Copyright © 2017 czy. All rights reserved.
//

#import <AsyncDisplayKit/AsyncDisplayKit.h>

@class ASBBCollectionViewManager,ASBBCollectionReusableViewItem;

@interface ASBBCollectionReusableViewItemView : ASCellNode


@property (nonatomic, weak) ASBBCollectionViewManager *collectionViewManager;

@property (nonatomic, assign) NSInteger sectionIndex;
@property (nonatomic, strong) ASBBCollectionReusableViewItem *item;
@property (assign, readwrite, nonatomic) BOOL loaded;

/**
 返回cell的尺寸
 
 @param item 数据item
 @param manager 管理类
 @return cell的尺寸
 */
//+(CGSize)sizeWithItem:(ASBBCollectionReusableViewItem*)item collectionManager:(ASBBCollectionViewManager*)manager;

- (instancetype)initWithCollectionViewItem:(ASBBCollectionReusableViewItem *)collectionReusableViewItem;
- (void)initView;

@end
