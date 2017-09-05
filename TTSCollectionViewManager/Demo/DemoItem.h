//
//  DemoItem.h
//  TTSCollectionViewManager
//
//  Created by Gary on 10/04/2017.
//  Copyright © 2017 czy. All rights reserved.
//

#import "TTSCollectionViewItem.h"
#import "DemoModel.h"

@interface DemoItem : TTSCollectionViewItem

@property (nonatomic, strong) DemoModel                     *model;

@property (copy, readwrite, nonatomic) void (^onViewClickHandler)(id item,ViewActionType actionType);

+(DemoItem *)itemWithModel:(DemoModel *)model
              clickHandler:(void(^)(DemoItem *item,ViewActionType actionType))clickHandler
          selectionHandler:(void(^)(DemoItem *item))selectionHandler;

@end
