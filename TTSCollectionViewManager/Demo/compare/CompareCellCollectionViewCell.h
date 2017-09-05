//
//  CompareCellCollectionViewCell.h
//  TTSCollectionViewManager
//
//  Created by Gary on 12/04/2017.
//  Copyright © 2017 czy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CompareCellCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView            *imageView;

@property (nonatomic, strong) UILabel                      *productNameLabel;

@property (nonatomic, strong) UILabel                      *priceLabel;

@property (nonatomic, assign) BOOL                       loaded;

- (void)cellDidLoad;

@end
