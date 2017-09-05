//
//  ASDemoItemCell.m
//  TTSCollectionViewManager
//
//  Created by Gary on 05/06/2017.
//  Copyright © 2017 czy. All rights reserved.
//

#import "ASDemoItemCell.h"

#define kCellWidth         167
#define kCellHeight        167
#define kBottomHeight      30

@interface ASDemoItemCell () <ASNetworkImageNodeDelegate>

@property (nonatomic, strong) ASNetworkImageNode                *imageNode;

@property (nonatomic, strong) ASTextNode                        *textNode;

@property (nonatomic, strong) ASScrollNode                      *scrollNode;

@property (nonatomic, strong) ASDisplayNode                     *bgNode;

@end

@implementation ASDemoItemCell
@dynamic item;

//+(CGSize)sizeWithItem:(ASBBCollectionViewItem *)item collectionManager:(ASBBCollectionViewManager *)manager {
//    return CGSizeMake(kCellWidth, kCellHeight);
//}

- (void)initCell {
    [super initCell];
    
    NSLog(@"self.frame = %@",NSStringFromCGRect(self.frame));
    
    _bgNode = [[ASDisplayNode alloc]init];
    _bgNode.backgroundColor = [UIColor clearColor];
    _bgNode.style.preferredSize = CGSizeMake(kCellWidth, kCellHeight);
    [self addSubnode:_bgNode];
    
    _imageNode = [[ASNetworkImageNode alloc]init];
    _imageNode.backgroundColor = ASDisplayNodeDefaultPlaceholderColor();
    if (self.item.model.path.length) {
        NSString *urlStr = IMAGESCALESCHEME(TT_Global_Photo_Domain, self.item.model.path, kCellWidth, kCellHeight);
        _imageNode.URL = [NSURL URLWithString:urlStr];
        _imageNode.delegate = self;
    }
    _imageNode.style.preferredSize = CGSizeMake(kCellWidth, kCellHeight);
    [self addSubnode:_imageNode];
    
    
    _textNode = [[ASTextNode alloc]init];
    _textNode.maximumNumberOfLines = 1;
    if (self.item.model.name.length) {
        NSMutableAttributedString *nameAttr = [[NSMutableAttributedString alloc]initWithString:self.item.model.name
    attributes:@{
                 NSForegroundColorAttributeName : [UIColor blackColor],
                 NSFontAttributeName            : [UIFont systemFontOfSize:14]
                 }];
        _textNode.attributedText = nameAttr;
    }
    _textNode.userInteractionEnabled = YES;
    [self addSubnode:_textNode];
    
    
    
    
}

- (void)didLoad {
    [super didLoad];
    
    [_textNode addTarget:self action:@selector(onViewClick:) forControlEvents:ASControlNodeEventTouchUpInside];
}

- (void)onViewClick:(id)sender {
    if (self.item.onViewClickHandler) {
        self.item.onViewClickHandler(self.item, ViewActionTypeUpdateCart);
    }
}

- (ASLayoutSpec*)layoutSpecThatFits:(ASSizeRange)constrainedSize {
   
    
    ASStackLayoutSpec *stackLayoutSpec = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionVertical
                                                                                 spacing:0.0
                                                                          justifyContent:ASStackLayoutJustifyContentStart alignItems:ASStackLayoutAlignItemsCenter
                                                                                children:@[_imageNode,_textNode]];
    
    ASBackgroundLayoutSpec *bgSpecer = [ASBackgroundLayoutSpec backgroundLayoutSpecWithChild:_bgNode background:stackLayoutSpec];
    
  
    return bgSpecer;
}

- (void)layout {
    [super layout];
    
    NSLog(@"layout self.frame = %@",NSStringFromCGRect(self.frame));

    _imageNode.frame = CGRectMake(0, 0, self.calculatedSize.width, self.calculatedSize.height);
    
    _textNode.frame = CGRectMake(0, self.calculatedSize.height - kBottomHeight, self.calculatedSize.width, kBottomHeight);
}











#pragma mark -
#pragma mark ASNetworkImageNodeDelegate methods.

- (void)imageNode:(ASNetworkImageNode *)imageNode didLoadImage:(UIImage *)image {
    CATransition *animation = [CATransition animation];
    animation.duration = .35;
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    animation.type = kCATransitionFade;
    [[imageNode layer] addAnimation:animation forKey:@"animation"];
}
- (void)imageNodeDidFinishDecoding:(ASNetworkImageNode *)imageNode {
}


@end
