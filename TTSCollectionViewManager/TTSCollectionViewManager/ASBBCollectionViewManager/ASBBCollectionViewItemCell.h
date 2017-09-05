//
//  ASBBCollectionViewItemCell.h
//  ASBBCollectionViewManager
//
//  Created by Gary on 01/06/2017.
//  Copyright © 2017 czy. All rights reserved.
//

#import <AsyncDisplayKit/AsyncDisplayKit.h>

@class ASBBCollectionViewManager,ASBBCollectionViewItem;

@interface ASBBCollectionViewItemCell : ASCellNode


@property (nonatomic, weak) ASBBCollectionViewManager *collectionViewManager;
@property (nonatomic, assign) NSInteger rowIndex;
@property (nonatomic, assign) NSInteger sectionIndex;
@property (nonatomic, strong) ASBBCollectionViewItem *item;

@property (nonatomic ,strong) ASDisplayNode *dividerNode;


- (instancetype)initWithCollectionViewItem:(ASBBCollectionViewItem *)collectionViewItem;
- (void)initCell;


@end
