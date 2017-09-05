//
//  TTSCollectionViewItemCell.m
//  TTSCollectionViewManager
//
//  Created by Gary on 05/04/2017.
//  Copyright © 2017 czy. All rights reserved.
//

#import "TTSCollectionViewItemCell.h"
#import "TTSCollectionViewManager.h"
#import "TTSCollectionViewItem.h"

@implementation TTSCollectionViewItemCell



+(CGSize)sizeWithItem:(TTSCollectionViewItem *)item collectionManager:(TTSCollectionViewManager *)manager {
    return CGSizeMake(50, 50);
}

- (void)cellDidLoad {
    self.loaded = YES;
}

- (void)cellWillAppear {
    
}

- (void)cellDidDisappear {
    
}

@end
