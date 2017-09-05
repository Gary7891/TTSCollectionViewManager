//
//  DemoItemCell.m
//  TTSCollectionViewManager
//
//  Created by Gary on 10/04/2017.
//  Copyright © 2017 czy. All rights reserved.
//

#import "DemoItemCell.h"
//#import <UIImageView+WebCache.h>
#import "UIImageView+TFCache.h"


#define kCellWidth         167
#define kCellHeight        167


@implementation DemoItemCell
@dynamic item;

+(CGSize)sizeWithItem:(TTSCollectionViewItem *)item collectionManager:(TTSCollectionViewManager *)manager {
    return CGSizeMake(kCellWidth, kCellHeight);
}

- (void)cellDidLoad {
    [super cellDidLoad];
    
    [self addSubview:self.imageView];
    [self addSubview:self.productNameLabel];
    [self addSubview:self.priceLabel];
}

- (void)cellWillAppear {
    [super cellWillAppear];
    
    if (self.item.model.path.length) {
        NSString *urlStr = IMAGESCALESCHEME(TT_Global_Photo_Domain, self.item.model.path, kCellWidth, kCellHeight);
//        NSString *urlStr = [NSString stringWithFormat:@"%@%@",TT_Global_Photo_Domain,self.item.model.path];
//        [[SDImageCache sharedImageCache] setValue:nil forKey:@"memCache"];
//        [_imageView sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:[UIImage imageNamed:@"tupianjiazaibuchu"] options:SDWebImageRetryFailed | SDWebImageLowPriority];
        [_imageView tf_setImageWithURL:[NSURL URLWithString:urlStr]
                      placeholderImage:nil
                              animated:NO
                             faceAware:NO];
        
        
    }
    
    if (self.item.model.name.length) {
        _productNameLabel.text = self.item.model.name;
    }
    
    if (self.item.model.price.length) {
        _priceLabel.text = self.item.model.price;
    }
}



- (void)cellDidDisappear {
    [super cellDidDisappear];
    
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
    if (self.item.onViewClickHandler) {
        self.item.onViewClickHandler(self.item, ViewActionTypeUpdateCart);
    }
}


#pragma  CreateView

- (UIImageView*)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc]init];
        _imageView.backgroundColor = [UIColor clearColor];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.clipsToBounds = YES;
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
