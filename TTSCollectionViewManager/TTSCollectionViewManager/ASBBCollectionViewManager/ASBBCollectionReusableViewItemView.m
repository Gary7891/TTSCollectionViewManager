//
//  ASBBCollectionReusableViewItemView.m
//  ASBBCollectionViewManager
//
//  Created by Gary on 01/06/2017.
//  Copyright © 2017 czy. All rights reserved.
//

#import "ASBBCollectionReusableViewItemView.h"
#import "ASBBCollectionReusableViewItem.h"
#import "ASBBCollectionViewManager.h"

@implementation ASBBCollectionReusableViewItemView

+(CGSize)sizeWithItem:(ASBBCollectionReusableViewItem *)item collectionManager:(ASBBCollectionViewManager *)manager {
    return CGSizeZero;
}

- (instancetype)initWithCollectionViewItem:(ASBBCollectionReusableViewItem *)collectionReusableViewItem {
    self = [super init];
    if(self) {
        self.item = collectionReusableViewItem;
        
        // hairline cell separator
        
        
        
        [self initView];
    }
    return self;
}

- (void)initView {
    
}

- (void)didLoad {
    // enable highlighting now that self.layer has loaded -- see ASHighlightOverlayLayer.h
    self.layer.as_allowsHighlightDrawing = YES;
    [super didLoad];
}

@end
