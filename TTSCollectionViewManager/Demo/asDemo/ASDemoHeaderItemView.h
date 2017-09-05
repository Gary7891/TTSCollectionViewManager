//
//  ASDemoHeaderItemView.h
//  TTSCollectionViewManager
//
//  Created by Gary on 07/06/2017.
//  Copyright © 2017 czy. All rights reserved.
//
#import "ASBBCollectionReusableViewItemView.h"

#import "ASDemoHeaderItem.h"

@interface ASDemoHeaderItemView : ASBBCollectionReusableViewItemView

@property (nonatomic, strong) ASDemoHeaderItem  *item;

@property (nonatomic, strong) ASTextNode           *titleNode;

@end
