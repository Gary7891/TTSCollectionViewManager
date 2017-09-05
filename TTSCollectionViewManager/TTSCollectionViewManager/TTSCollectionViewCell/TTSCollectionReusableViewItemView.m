//
//  TTSCollectionReusableViewItemView.m
//  TTSCollectionViewManager
//
//  Created by Gary on 14/04/2017.
//  Copyright © 2017 czy. All rights reserved.
//

#import "TTSCollectionReusableViewItemView.h"
#import "TTSCollectionReusableViewItem.h"
#import "TTSCollectionViewManager.h"

@implementation TTSCollectionReusableViewItemView

- (instancetype)initWithCollectionViewItem:(TTSCollectionReusableViewItem *)collectionViewItem {
    self = [super init];
    if (self) {
        [self viewDidLoad];
    }
    return self;
}

+(CGSize)sizeWithItem:(TTSCollectionReusableViewItem *)item collectionManager:(TTSCollectionViewManager *)manager {
    return CGSizeMake(50, 50);
}

- (void)viewDidLoad {
    self.loaded = YES;
}

- (void)viewWillAppear {
    
}

- (void)viewDidDisappear {
    
}


@end
