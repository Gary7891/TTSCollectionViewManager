//
//  TTSCollectionViewDataManagerProtocol.h
//  TTSCollectionViewManager
//
//  Created by Gary on 07/04/2017.
//  Copyright © 2017 czy. All rights reserved.
//

#import "TTSCollectionViewDataSource.h"




//事件完成block
typedef void (^Completion)(void);
//列表内View事件
typedef void (^CellViewClickHandler)(id item ,NSInteger actionType);
//列表点击事件
typedef void (^SelectionHandler)(id item);
//页眉或者页脚内点击事件
typedef void (^SupplementaryViewClickHandler)(id item, NSInteger actionType,NSInteger viewType);

//列表Cell load 完成block
typedef void(^CollectionViewReloadCompletionBlock)(BOOL finished,id object,NSError *error,NSInteger currentItemCount);

@protocol TTSCollectionViewManagerProtocol <NSObject>

@required
/**
 *  列表业务类初始化
 *
 *  @param collectionViewDataSource 列表数据源
 *  @param listType            列表类型
 *
 *  @return TTSCollectionViewDataSourceManager
 */
- (instancetype)initWithDataSource:(TTSCollectionViewDataSource *)collectionViewDataSource
                          listType:(NSInteger)listType;

/**
 *  显示列表数据
 *
 *  @param result          数据字典
 *  @param completionBlock 回调block
 */
- (void)reloadView:(NSDictionary *)result block:(CollectionViewReloadCompletionBlock)completionBlock;
/**
 *  列表内View事件处理
 *
 *  @param item 数据模型
 *  @param actionType 操作类型
 */
- (void)cellViewClickHandler:(id)item actionType:(NSInteger)actionType;
/**
 *  列表点击事件处理
 *
 *  @param item 数据模型
 */
- (void)selectionHandler:(id)item;

/**
 页眉或者页脚内view点击事件处理

 @param item 页眉或者页脚的数据模型
 @param actionType 操作类型
 */
- (void)supplementaryViewClickHandler:(id)item actionType:(NSInteger)actionType viewType:(NSInteger)viewType;


/**
 *  刷新指定Cell
 *
 *  @param actionType 操作类型
 *  @param dataId 数据ID
 */
- (void)refreshCell:(NSInteger)actionType dataId:(NSString *)dataId;

/**
 *  刷新列表数据
 */
- (void)updateCollectionViewData:(id)section;
/**
 * 配置section相关东西
 */
- (void)configureSection;



@optional

@end
