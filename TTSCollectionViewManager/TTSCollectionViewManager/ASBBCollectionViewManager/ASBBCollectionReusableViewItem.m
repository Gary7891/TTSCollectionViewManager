//
//  ASBBCollectionReusableViewItem.m
//  ASBBCollectionViewManager
//
//  Created by Gary on 01/06/2017.
//  Copyright © 2017 czy. All rights reserved.
//

#import "ASBBCollectionReusableViewItem.h"

#import "ASBBCollectionViewSection.h"
#import "ASBBCollectionViewManager.h"

@implementation ASBBCollectionReusableViewItem




+ (instancetype)item {
    return [[self alloc] init];
}

- (id)init
{
    self = [super init];
    if (!self)
        return nil;
    
    return self;
}



- (NSInteger)sectionIndex {
    return self.section.index;
}

@end
