//
//  DemoHeaderItemView.m
//  TTSCollectionViewManager
//
//  Created by Gary on 14/04/2017.
//  Copyright © 2017 czy. All rights reserved.
//

#import "DemoHeaderItemView.h"

@implementation DemoHeaderItemView
@dynamic item;

+(CGSize)sizeWithItem:(TTSCollectionReusableViewItem *)item collectionManager:(TTSCollectionViewManager *)manager {
    return CGSizeMake(300, 20);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.backgroundColor = [UIColor greenColor];
    [self addSubview:self.titleLabel];
    
}

- (void)viewWillAppear {
    [super viewWillAppear];
    NSLog(@"index = %@",@(self.item.sectionIndex));
    _titleLabel.text = [NSString stringWithFormat:@"这是第%@个section的头",@(self.item.sectionIndex)];
    
}

- (void)viewDidDisappear {
    [super viewDidDisappear];
    _titleLabel.text = nil;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [_titleLabel sizeToFit];
    _titleLabel.frame = CGRectMake(15, 0, 200, 20);
    
}

- (void)onViewClick:(id)sender {
    if (self.item.onViewClickHandler) {
        self.item.onViewClickHandler(self.item, 0, SupplementaryViewTypeHeader);
    }
}




#pragma mark - Create View

- (UILabel*)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.font = [UIFont systemFontOfSize:14];
        _titleLabel.textColor = [UIColor redColor];
        _titleLabel.userInteractionEnabled = YES;
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onViewClick:)];
        [_titleLabel addGestureRecognizer:gesture];
        
    }
    return _titleLabel;
}

@end
