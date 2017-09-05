//
//  ASDemoItem.m
//  TTSCollectionViewManager
//
//  Created by Gary on 05/06/2017.
//  Copyright © 2017 czy. All rights reserved.
//

#import "ASDemoItem.h"
//#import <ASAssert.h>

@implementation ASDemoItem

+(ASDemoItem *)itemWithModel:(DemoModel *)model
                            clickHandler:(void(^)(ASDemoItem *item,ViewActionType actionType))clickHandler
                        selectionHandler:(void(^)(ASDemoItem *item))selectionHandler {
    ASDemoItem *item = [[ASDemoItem alloc]init];
    item.model = model;
    item.onViewClickHandler = clickHandler;
    item.selectionHandler = selectionHandler;
//    item.preferredSize = CGSizeMake(167, 167);
//    ASDisplayNodeAssertMainThread();
    return item;
}

@end
