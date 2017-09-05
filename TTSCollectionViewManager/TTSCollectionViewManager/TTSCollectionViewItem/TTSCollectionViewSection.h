//
//  TTSCollectionViewSection.h
//  TTSCollectionViewManager
//
//  Created by Gary on 05/04/2017.
//  Copyright © 2017 czy. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TTSCollectionViewManager,TTSCollectionReusableViewItem;

@interface TTSCollectionViewSection : NSObject

@property (strong, readonly, nonatomic) NSArray *items;

@property (strong, readwrite, nonatomic) TTSCollectionReusableViewItem *headerItem;

@property (strong, readwrite, nonatomic) TTSCollectionReusableViewItem *footerItem;

@property (weak, readwrite, nonatomic) TTSCollectionViewManager *collectionManager;

@property (assign, readonly, nonatomic) NSUInteger index;

@property (copy, readwrite, nonatomic) NSString *indexTitle;

@property (assign, readwrite, nonatomic) CGFloat cellTitlePadding;

/**
 指定section里，cell的最小行距
 */
@property (assign, readwrite, nonatomic) CGFloat minimumLineSpace;

/**
 指定section里，cell的最小列间距
 */
@property (assign, readwrite, nonatomic) CGFloat minimumInteritemSpacing;

@property (assign, readwrite, nonatomic) UIEdgeInsets  sectionEdgeInsets;

+ (instancetype)section;



- (void)addItem:(id)item;

- (void)addItemsFromArray:(NSArray *)array;

- (void)insertItem:(id)item atIndex:(NSUInteger)index;

- (void)insertItems:(NSArray *)items atIndexes:(NSIndexSet *)indexes;

- (void)removeItem:(id)item;

- (void)removeAllItems;

- (void)removeItemIdenticalTo:(id)item inRange:(NSRange)range;

- (void)removeItemIdenticalTo:(id)item;

- (void)removeItemsInArray:(NSArray *)otherArray;

- (void)removeItemsInRange:(NSRange)range;

- (void)removeItem:(id)item inRange:(NSRange)range;

- (void)removeLastItem;

- (void)removeItemAtIndex:(NSUInteger)index;

- (void)removeItemsAtIndexes:(NSIndexSet *)indexes;

- (void)replaceItemAtIndex:(NSUInteger)index withItem:(id)item;

- (void)replaceItemsWithItemsFromArray:(NSArray *)otherArray;

- (void)replaceItemsAtIndexes:(NSIndexSet *)indexes withItems:(NSArray *)items;

- (void)replaceItemsInRange:(NSRange)range withItemsFromArray:(NSArray *)otherArray range:(NSRange)otherRange;

- (void)replaceItemsInRange:(NSRange)range withItemsFromArray:(NSArray *)otherArray;

- (void)exchangeItemAtIndex:(NSUInteger)idx1 withItemAtIndex:(NSUInteger)idx2;

- (void)sortItemsUsingFunction:(NSInteger (*)(id, id, void *))compare context:(void *)context;

- (void)sortItemsUsingSelector:(SEL)comparator;

- (void)reloadSectionWithAnimation;

@end
