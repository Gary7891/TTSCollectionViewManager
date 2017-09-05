//
//  ASDemoHeaderItem.h
//  TTSCollectionViewManager
//
//  Created by Gary on 07/06/2017.
//  Copyright © 2017 czy. All rights reserved.
//

#import "ASBBCollectionReusableViewItem.h"

@interface ASDemoHeaderItem : ASBBCollectionReusableViewItem

@property (copy, readwrite, nonatomic) void (^onViewClickHandler)(id item,ViewActionType actionType,NSInteger viewType);

+(ASDemoHeaderItem*)itemWithOnViewClick:(void(^)(ASDemoHeaderItem *item,ViewActionType actionType,NSInteger viewType))clickHandler;

@end
