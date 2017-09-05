//
//  ASBBCollectionViewItemCell.m
//  ASBBCollectionViewManager
//
//  Created by Gary on 01/06/2017.
//  Copyright © 2017 czy. All rights reserved.
//

#import "ASBBCollectionViewItemCell.h"
#import "ASBBCollectionViewItem.h"
#import "ASBBCollectionViewManager.h"

@interface ASBBCollectionViewItemCell()



@end

@implementation ASBBCollectionViewItemCell


- (instancetype)initWithCollectionViewItem:(ASBBCollectionViewItem *)collectionViewItem {
    self = [super init];
    if(self) {
        self.item = collectionViewItem;
        
        // hairline cell separator
        
        _dividerNode = [[ASDisplayNode alloc] init];
        _dividerNode.backgroundColor = self.item.dividerColor;
        [self addSubnode:_dividerNode];
        
        [self initCell];
    }
    return self;
}



- (void)initCell {
    
}

- (void)didLoad {
    // enable highlighting now that self.layer has loaded -- see ASHighlightOverlayLayer.h
    self.layer.as_allowsHighlightDrawing = YES;
    [super didLoad];
}

//- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize {
//    return nil;
//}

- (void)layout {
    [super layout];
    CGFloat pixelHeight = 1.0f / [[UIScreen mainScreen] scale];
    _dividerNode.frame = CGRectMake(0.0f, 0.0f, self.calculatedSize.width, pixelHeight);
}

@end
