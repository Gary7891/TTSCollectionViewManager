//
//  DemoHeaderItemView.h
//  TTSCollectionViewManager
//
//  Created by Gary on 14/04/2017.
//  Copyright © 2017 czy. All rights reserved.
//

#import "TTSCollectionReusableViewItemView.h"
#import "DemoHeaderItem.h"

@interface DemoHeaderItemView : TTSCollectionReusableViewItemView


@property (nonatomic, strong) DemoHeaderItem  *item;

@property (nonatomic, strong) UILabel         *titleLabel;





@end
