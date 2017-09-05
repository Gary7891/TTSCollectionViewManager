//
//  DemoHeaderItem.h
//  TTSCollectionViewManager
//
//  Created by Gary on 14/04/2017.
//  Copyright © 2017 czy. All rights reserved.
//

#import "TTSCollectionReusableViewItem.h"

@interface DemoHeaderItem : TTSCollectionReusableViewItem


@property (copy, readwrite, nonatomic) void (^onViewClickHandler)(id item,ViewActionType actionType,NSInteger viewType);

+(DemoHeaderItem*)itemWithOnViewClick:(void(^)(DemoHeaderItem *item,ViewActionType actionType,NSInteger viewType))clickHandler;

@end
