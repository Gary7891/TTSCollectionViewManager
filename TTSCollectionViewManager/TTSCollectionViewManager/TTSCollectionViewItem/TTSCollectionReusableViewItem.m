//
//  TTSCollectionReusableViewItem.m
//  TTSCollectionViewManager
//
//  Created by Gary on 14/04/2017.
//  Copyright © 2017 czy. All rights reserved.
//

#import "TTSCollectionReusableViewItem.h"
#import "TTSCollectionViewSection.h"
#import "TTSCollectionViewManager.h"

@implementation TTSCollectionReusableViewItem

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
