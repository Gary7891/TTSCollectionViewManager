//
//  DemoHeaderItem.m
//  TTSCollectionViewManager
//
//  Created by Gary on 14/04/2017.
//  Copyright © 2017 czy. All rights reserved.
//

#import "DemoHeaderItem.h"

@implementation DemoHeaderItem


+(DemoHeaderItem*)itemWithOnViewClick:(void (^)(DemoHeaderItem *, ViewActionType, NSInteger))clickHandler {
    DemoHeaderItem *item = [[DemoHeaderItem alloc]init];
    item.onViewClickHandler = clickHandler;
    return item;
}

@end
