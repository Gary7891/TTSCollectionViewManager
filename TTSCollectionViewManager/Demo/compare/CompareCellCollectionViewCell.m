//
//  CompareCellCollectionViewCell.m
//  TTSCollectionViewManager
//
//  Created by Gary on 12/04/2017.
//  Copyright © 2017 czy. All rights reserved.
//

#import "CompareCellCollectionViewCell.h"

@implementation CompareCellCollectionViewCell

-(instancetype)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)cellDidLoad {
    _loaded = YES;
    [self addSubview:self.imageView];
    [self addSubview:self.productNameLabel];
    [self addSubview:self.priceLabel];
}

- (void)prepareForReuse {
    [super prepareForReuse];
    _imageView.image = nil;
    _productNameLabel.text = nil;
    _priceLabel.text = nil;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.top.equalTo(self);
        make.bottom.equalTo(self);
    }];
    
    [_productNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(10);
        make.right.equalTo(self.mas_right).offset(-10);
        make.bottom.mas_equalTo(-10);
        make.height.mas_equalTo(20);
    }];
}

#pragma mark - Action

- (void)onViewClick:(id)sender {
    
}



#pragma  CreateView

- (UIImageView*)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc]init];
        _imageView.backgroundColor = [UIColor clearColor];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        _imageView.layer.borderWidth = 1;
        _imageView.tag = 1;
    }
    return _imageView;
}

- (UILabel*)productNameLabel {
    if (!_productNameLabel) {
        _productNameLabel = [[UILabel alloc]init];
        _productNameLabel.textColor = [UIColor blackColor];
        _productNameLabel.font = [UIFont systemFontOfSize:14];
        _productNameLabel.backgroundColor = [UIColor clearColor];
        _productNameLabel.layer.borderWidth = 1;
        _productNameLabel.userInteractionEnabled = YES;
        _productNameLabel.tag = 2;
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onViewClick:)];
        [_productNameLabel addGestureRecognizer:gesture];
    }
    return _productNameLabel;
}

- (UILabel*)priceLabel {
    if (!_priceLabel) {
        _priceLabel = [[UILabel alloc]init];
        _priceLabel.backgroundColor = [UIColor clearColor];
        _priceLabel.font = [UIFont systemFontOfSize:14];
        _priceLabel.textColor = [UIColor redColor];
        _priceLabel.layer.borderWidth = 1;
        _priceLabel.layer.borderColor = [UIColor redColor].CGColor;
        _priceLabel.tag = 3;
    }
    return _priceLabel;
}

@end
