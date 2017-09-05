//
//  TTSCollectionReusableViewItemView.h
//  TTSCollectionViewManager
//
//  Created by Gary on 14/04/2017.
//  Copyright © 2017 czy. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TTSCollectionViewManager,TTSCollectionReusableViewItem;


@interface TTSCollectionReusableViewItemView : UICollectionReusableView

@property (nonatomic, weak) TTSCollectionViewManager *collectionViewManager;

@property (nonatomic, assign) NSInteger sectionIndex;
@property (nonatomic, strong) TTSCollectionReusableViewItem *item;
@property (assign, readwrite, nonatomic) BOOL loaded;


- (instancetype)initWithCollectionViewItem:(TTSCollectionReusableViewItem *)collectionReusableViewItem;


/**
 返回cell的尺寸
 
 @param item 数据item
 @param manager 管理类
 @return cell的尺寸
 */
+(CGSize)sizeWithItem:(TTSCollectionReusableViewItem*)item collectionManager:(TTSCollectionViewManager*)manager;

/**
 初始化view
 */
- (void)viewDidLoad;

/**
 view元素赋值
 */
- (void)viewWillAppear;

/**
 view元素值清零
 */
- (void)viewDidDisappear;




@end
