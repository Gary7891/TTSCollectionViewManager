//
//  ASDemoHeaderItem.m
//  TTSCollectionViewManager
//
//  Created by Gary on 07/06/2017.
//  Copyright © 2017 czy. All rights reserved.
//

#import "ASDemoHeaderItem.h"

@implementation ASDemoHeaderItem

+(ASDemoHeaderItem*)itemWithOnViewClick:(void (^)(ASDemoHeaderItem *, ViewActionType, NSInteger))clickHandler {
    ASDemoHeaderItem *item = [[ASDemoHeaderItem alloc]init];
    item.onViewClickHandler = clickHandler;
    return item;
}

@end
