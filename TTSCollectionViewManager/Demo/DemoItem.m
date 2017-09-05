//
//  DemoItem.m
//  TTSCollectionViewManager
//
//  Created by Gary on 10/04/2017.
//  Copyright © 2017 czy. All rights reserved.
//

#import "DemoItem.h"

@implementation DemoItem


+(DemoItem*)itemWithModel:(DemoModel *)model
             clickHandler:(void (^)(DemoItem *, ViewActionType))clickHandler
         selectionHandler:(void (^)(DemoItem *))selectionHandler {
    
    DemoItem *item = [[DemoItem alloc]init];
    item.model = model;
    item.onViewClickHandler = clickHandler;
    item.selectionHandler = selectionHandler;
    return item;
    
}

@end
