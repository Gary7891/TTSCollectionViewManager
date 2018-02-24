//
//  TTSCollectionViewDataManager.h
//  TTSCollectionViewManager
//
//  Created by Gary on 07/04/2017.
//  Copyright © 2017 czy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TTSCollectionViewDataManagerProtocol.h"
#import "TTSCollectionViewDataSource.h"

@interface TTSCollectionViewDataManager : NSObject <TTSCollectionViewManagerProtocol>

@property (nonatomic ,weak  ) TTSCollectionViewDataSource *collectionViewDataSource;
/**
 *  列表内点击事件 block
 */
@property (nonatomic ,strong) CellViewClickHandler   cellViewClickHandler;
/**
 *  列表行点击事件 block
 */
@property (nonatomic ,strong) SelectionHandler       selectionHandler;

@property (nonatomic, strong) SupplementaryViewClickHandler supplementaryViewClickHandler;

/**
 串行队列
 */
@property (nonatomic, strong) dispatch_queue_t serialQueue;


/**
 *  当前
 */
@property (nonatomic ,strong) NSIndexPath            *currentIndexPath;
/**
 *  列表类型
 */
@property (nonatomic ,assign) NSInteger                       listType;

@property (nonatomic, strong) id        section;

@property (nonatomic, strong) NSMutableArray       *addIndexPathArray;






@end
