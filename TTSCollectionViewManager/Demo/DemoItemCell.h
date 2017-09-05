//
//  DemoItemCell.h
//  TTSCollectionViewManager
//
//  Created by Gary on 10/04/2017.
//  Copyright © 2017 czy. All rights reserved.
//

#import "TTSCollectionViewItemCell.h"
#import "DemoItem.h"

@interface DemoItemCell : TTSCollectionViewItemCell

@property (nonatomic, strong) DemoItem                     *item;

@property (nonatomic, strong) UIImageView                  *imageView;

@property (nonatomic, strong) UILabel                      *productNameLabel;

@property (nonatomic, strong) UILabel                      *priceLabel;

@end
