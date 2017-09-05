//
//  ASDemoHeaderItemView.m
//  TTSCollectionViewManager
//
//  Created by Gary on 07/06/2017.
//  Copyright © 2017 czy. All rights reserved.
//

#import "ASDemoHeaderItemView.h"

@implementation ASDemoHeaderItemView
@dynamic item;

//+(CGSize)sizeWithItem:(ASBBCollectionReusableViewItem *)item collectionManager:(ASBBCollectionViewManager *)manager {
//    return CGSizeMake([UIScreen mainScreen].bounds.size.width, 20);
//}


- (void)initView {
    [super initView];
    
    self.backgroundColor = [UIColor yellowColor];
    
    _titleNode = [[ASTextNode alloc]init];
    NSInteger index = self.item.sectionIndex;
    NSString *string = [NSString stringWithFormat:@"这是第%@个section",@(index)];
    _titleNode.attributedText = [[NSAttributedString alloc]initWithString:string
                                                               attributes:@{
                                                                            NSFontAttributeName    :  [UIFont systemFontOfSize:14],
                                                                            NSForegroundColorAttributeName : [UIColor blackColor]
                                                                            }];
    _titleNode.userInteractionEnabled = YES;
    [self addSubnode:_titleNode];
    
}

- (void)didLoad {
    [super didLoad];
    
    [_titleNode addTarget:self action:@selector(onViewClick:) forControlEvents:ASControlNodeEventTouchUpInside];
    
}


- (ASLayoutSpec*)layoutSpecThatFits:(ASSizeRange)constrainedSize {
    ASInsetLayoutSpec *specer = [ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsMake(5, 14, 5, 14)
                                                                       child:_titleNode];
    return specer;
    
}

- (void)layout {
    [super layout];
  
}

- (void)onViewClick:(id)sender {
    if (self.item.onViewClickHandler) {
        self.item.onViewClickHandler(self.item, ViewActionTypeUpdateCart, ASSupplementaryViewTypeHeader);
    }
}


@end
