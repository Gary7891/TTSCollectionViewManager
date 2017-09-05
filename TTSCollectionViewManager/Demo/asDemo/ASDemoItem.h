//
//  ASDemoItem.h
//  TTSCollectionViewManager
//
//  Created by Gary on 05/06/2017.
//  Copyright © 2017 czy. All rights reserved.
//

#import "ASBBCollectionViewItem.h"
#import "DemoModel.h"

@interface ASDemoItem : ASBBCollectionViewItem

@property (nonatomic, strong) DemoModel                     *model;

@property (copy, readwrite, nonatomic) void (^onViewClickHandler)(id item,ViewActionType actionType);

+(ASDemoItem *)itemWithModel:(DemoModel *)model
              clickHandler:(void(^)(ASDemoItem *item,ViewActionType actionType))clickHandler
          selectionHandler:(void(^)(ASDemoItem *item))selectionHandler;

@end
