//
//  ASBBCollectionViewSection.m
//  ASBBCollectionViewManager
//
//  Created by Gary on 01/06/2017.
//  Copyright © 2017 czy. All rights reserved.
//

#import "ASBBCollectionViewSection.h"
#import "ASBBCollectionViewManager.h"

@interface ASBBCollectionViewSection ()

@property (nonatomic ,strong) NSMutableArray *mutableItems;

@end

@implementation ASBBCollectionViewSection

+ (instancetype)section
{
    return [[self alloc] init];
}



- (id)init
{
    self = [super init];
    if (!self)
        return nil;
    
    _mutableItems = [[NSMutableArray alloc] init];
    _cellTitlePadding = 5;
    
    return self;
}




#pragma mark -
#pragma mark Reading information

- (NSUInteger)index
{
    ASBBCollectionViewManager *collectionViewManager = self.collectionManager;
//    NSLog(@"section index = %@",@([collectionViewManager.sections indexOfObject:self]));
    return [collectionViewManager.sections indexOfObject:self];
}

#pragma mark -
#pragma mark Managing items

- (void)setHeaderItem:(ASBBCollectionReusableViewItem *)headerItem {
    if ([headerItem isKindOfClass:[ASBBCollectionReusableViewItem class]]) {
        headerItem.section = self;
    }
    _headerItem = headerItem;
}

- (void)setFooterItem:(ASBBCollectionReusableViewItem *)footerItem {
    if ([footerItem isKindOfClass:[ASBBCollectionReusableViewItem class]]) {
        footerItem.section = self;
    }
    _footerItem = footerItem;
}

- (NSArray *)items
{
    return self.mutableItems;
}


- (void)addItem:(id)item
{
    if ([item isKindOfClass:[ASBBCollectionViewItem class]])
        ((ASBBCollectionViewItem *)item).section = self;
    
    [self.mutableItems addObject:item];
}

- (void)addItemsFromArray:(NSArray *)array
{
    for (ASBBCollectionViewItem *item in array)
        if ([item isKindOfClass:[ASBBCollectionViewItem class]])
            ((ASBBCollectionViewItem *)item).section = self;
    
    [self.mutableItems addObjectsFromArray:array];
}

- (void)insertItem:(id)item atIndex:(NSUInteger)index
{
    if ([item isKindOfClass:[ASBBCollectionViewItem class]])
        ((ASBBCollectionViewItem *)item).section = self;
    
    [self.mutableItems insertObject:item atIndex:index];
}

- (void)insertItems:(NSArray *)items atIndexes:(NSIndexSet *)indexes
{
    for (ASBBCollectionViewItem *item in items)
        if ([item isKindOfClass:[ASBBCollectionViewItem class]])
            ((ASBBCollectionViewItem *)item).section = self;
    
    [self.mutableItems insertObjects:items atIndexes:indexes];
}

- (void)removeItem:(id)item inRange:(NSRange)range
{
    [self.mutableItems removeObject:item inRange:range];
}

- (void)removeLastItem
{
    [self.mutableItems removeLastObject];
}

- (void)removeItemAtIndex:(NSUInteger)index
{
    [self.mutableItems removeObjectAtIndex:index];
}

- (void)removeItem:(id)item
{
    [self.mutableItems removeObject:item];
}

- (void)removeAllItems
{
    [self.mutableItems removeAllObjects];
}

- (void)removeItemIdenticalTo:(id)item inRange:(NSRange)range
{
    [self.mutableItems removeObjectIdenticalTo:item inRange:range];
}

- (void)removeItemIdenticalTo:(id)item
{
    [self.mutableItems removeObjectIdenticalTo:item];
}

- (void)removeItemsInArray:(NSArray *)otherArray
{
    [self.mutableItems removeObjectsInArray:otherArray];
}

- (void)removeItemsInRange:(NSRange)range
{
    [self.mutableItems removeObjectsInRange:range];
}

- (void)removeItemsAtIndexes:(NSIndexSet *)indexes
{
    [self.mutableItems removeObjectsAtIndexes:indexes];
}

- (void)replaceItemAtIndex:(NSUInteger)index withItem:(id)item
{
    if ([item isKindOfClass:[ASBBCollectionViewItem class]])
        ((ASBBCollectionViewItem *)item).section = self;
    
    [self.mutableItems replaceObjectAtIndex:index withObject:item];
}

- (void)replaceItemsWithItemsFromArray:(NSArray *)otherArray
{
    [self removeAllItems];
    [self addItemsFromArray:otherArray];
}

- (void)replaceItemsInRange:(NSRange)range withItemsFromArray:(NSArray *)otherArray range:(NSRange)otherRange
{
    for (ASBBCollectionViewItem *item in otherArray)
        if ([item isKindOfClass:[ASBBCollectionViewItem class]])
            ((ASBBCollectionViewItem *)item).section = self;
    
    [self.mutableItems replaceObjectsInRange:range withObjectsFromArray:otherArray range:otherRange];
}

- (void)replaceItemsInRange:(NSRange)range withItemsFromArray:(NSArray *)otherArray
{
    for (ASBBCollectionViewItem *item in otherArray)
        if ([item isKindOfClass:[ASBBCollectionViewItem class]])
            ((ASBBCollectionViewItem *)item).section = self;
    
    [self.mutableItems replaceObjectsInRange:range withObjectsFromArray:otherArray];
}

- (void)replaceItemsAtIndexes:(NSIndexSet *)indexes withItems:(NSArray *)items
{
    for (ASBBCollectionViewItem *item in items)
        if ([item isKindOfClass:[ASBBCollectionViewItem class]])
            ((ASBBCollectionViewItem *)item).section = self;
    
    [self.mutableItems replaceObjectsAtIndexes:indexes withObjects:items];
}

- (void)exchangeItemAtIndex:(NSUInteger)idx1 withItemAtIndex:(NSUInteger)idx2
{
    [self.mutableItems exchangeObjectAtIndex:idx1 withObjectAtIndex:idx2];
}

- (void)sortItemsUsingFunction:(NSInteger (*)(id, id, void *))compare context:(void *)context
{
    [self.mutableItems sortUsingFunction:compare context:context];
}

- (void)sortItemsUsingSelector:(SEL)comparator
{
    [self.mutableItems sortUsingSelector:comparator];
}

#pragma mark -
#pragma mark Manipulating table view section

- (void)reloadSectionWithAnimation
{
    
    [self.collectionManager.collectionView reloadSections:[NSIndexSet indexSetWithIndex:self.index]];
}

@end
