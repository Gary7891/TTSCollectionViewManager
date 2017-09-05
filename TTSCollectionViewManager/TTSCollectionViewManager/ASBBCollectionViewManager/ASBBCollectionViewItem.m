//
//  ASBBCollectionViewItem.m
//  ASBBCollectionViewManager
//
//  Created by Gary on 01/06/2017.
//  Copyright © 2017 czy. All rights reserved.
//

#import "ASBBCollectionViewItem.h"
#import "ASBBCollectionViewSection.h"
#import "ASBBCollectionViewManager.h"


@implementation ASBBCollectionViewItem

+ (instancetype)item {
    return [[self alloc] init];
}

- (id)init
{
    self = [super init];
    if (!self)
        return nil;
        _dividerColor = [UIColor lightGrayColor];
    return self;
}

- (NSIndexPath *)indexPath {
    //    return nil;
    return [NSIndexPath indexPathForRow:[self.section.items indexOfObject:self] inSection:self.section.index];
}

#pragma mark -
#pragma mark Manipulating collection view row

- (void)selectRowAnimated:(BOOL)animated {
    [self selectRowAnimated:animated scrollPosition:UICollectionViewScrollPositionNone];
}

- (void)selectRowAnimated:(BOOL)animated scrollPosition:(UICollectionViewScrollPosition)scrollPosition {
    
    [self.section.collectionManager.collectionView selectItemAtIndexPath:self.indexPath animated:animated scrollPosition:scrollPosition];
}

- (void)deselectRowAnimated:(BOOL)animated {
    
    [self.section.collectionManager.collectionView deselectItemAtIndexPath:self.indexPath animated:animated];
}

- (void)reloadRowWithAnimation {
    [self.section.collectionManager.collectionView reloadItemsAtIndexPaths:@[self.indexPath]];
}

- (void)deleteRowWithAnimation {
    ASBBCollectionViewSection *section = self.section;
    NSInteger row = self.indexPath.row;
    [section removeItemAtIndex:self.indexPath.row];
    [section.collectionManager.collectionView deleteItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:row inSection:section.index]]];
}

@end
