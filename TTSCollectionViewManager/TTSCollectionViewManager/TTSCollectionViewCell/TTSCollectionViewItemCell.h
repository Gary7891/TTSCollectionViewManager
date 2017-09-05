//
//  TTSCollectionViewItemCell.h
//  TTSCollectionViewManager
//
//  Created by Gary on 05/04/2017.
//  Copyright © 2017 czy. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TTSCollectionViewManager,TTSCollectionViewItem;

@interface TTSCollectionViewItemCell : UICollectionViewCell

@property (nonatomic, weak) TTSCollectionViewManager *collectionViewManager;
@property (nonatomic, assign) NSInteger rowIndex;
@property (nonatomic, assign) NSInteger sectionIndex;
@property (nonatomic, strong) TTSCollectionViewItem *item;
@property (assign, readwrite, nonatomic) BOOL loaded;




/**
 返回cell的尺寸

 @param item 数据item
 @param manager 管理类
 @return cell的尺寸
 */
+(CGSize)sizeWithItem:(TTSCollectionViewItem*)item collectionManager:(TTSCollectionViewManager*)manager;

/**
 初始化cell
 */
- (void)cellDidLoad;

/**
 cell元素赋值
 */
- (void)cellWillAppear;

/**
 cell元素值清零
 */
- (void)cellDidDisappear;


@end
