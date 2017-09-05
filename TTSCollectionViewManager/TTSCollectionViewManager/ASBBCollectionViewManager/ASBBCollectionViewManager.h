//
//  ASBBCollectionViewManager.h
//  ASBBCollectionViewManager
//
//  Created by Gary on 01/06/2017.
//  Copyright © 2017 czy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AsyncDisplayKit/AsyncDisplayKit.h>

#import "ASBBCollectionViewItem.h"
#import "ASBBCollectionViewSection.h"
#import "ASBBCollectionViewItemCell.h"
#import "ASBBCollectionReusableViewItem.h"
#import "ASBBCollectionReusableViewItemView.h"


@protocol ASBBCollectionViewManagerDelegate;


@interface ASBBCollectionViewManager : NSObject <ASCollectionDelegateFlowLayout,ASCollectionDataSource>

@property (nonatomic, strong) NSArray *sections;

/**
 *  UICollectionView
 */
@property (weak, nonatomic) ASCollectionNode *collectionView;
@property (assign, nonatomic) id<ASBBCollectionViewManagerDelegate> delegate;
@property (strong, nonatomic) NSMutableDictionary *registeredClasses;



- (instancetype)initWithCollectionView:(ASCollectionNode *)collectionView delegate:(id<ASBBCollectionViewManagerDelegate>)delegate;
- (instancetype)initWithCollectionView:(ASCollectionNode*)collectionView;
- (void)registerClass:(NSString *)objectClass forCellWithReuseIdentifier:(NSString *)identifier;
- (Class)classForCellAtIndexPath:(NSIndexPath *)indexPath;
- (Class)classForSupplementaryHeaderAtSection:(NSInteger)section;
- (Class)classForSupplementaryFooterAtSection:(NSInteger)section;
- (id)objectAtKeyedSubscript:(id <NSCopying>)key;
- (void)setObject:(id)obj forKeyedSubscript:(id <NSCopying>)key;

- (void)addSection:(ASBBCollectionViewSection *)section;
- (void)addSectionsFromArray:(NSArray *)array;
- (void)insertSection:(ASBBCollectionViewSection *)section atIndex:(NSUInteger)index;
- (void)insertSections:(NSArray *)sections atIndexes:(NSIndexSet *)indexes;
- (void)removeSection:(ASBBCollectionViewSection *)section;
- (void)removeAllSections;
- (void)removeSectionIdenticalTo:(ASBBCollectionViewSection *)section inRange:(NSRange)range;
- (void)removeSectionIdenticalTo:(ASBBCollectionViewSection *)section;
- (void)removeSectionsInArray:(NSArray *)otherArray;
- (void)removeSectionsInRange:(NSRange)range;
- (void)removeSection:(ASBBCollectionViewSection *)section inRange:(NSRange)range;
- (void)removeLastSection;
- (void)removeSectionAtIndex:(NSUInteger)index;
- (void)removeSectionsAtIndexes:(NSIndexSet *)indexes;
- (void)replaceSectionAtIndex:(NSUInteger)index withSection:(ASBBCollectionViewSection *)section;
- (void)replaceSectionsWithSectionsFromArray:(NSArray *)otherArray;
- (void)replaceSectionsAtIndexes:(NSIndexSet *)indexes withSections:(NSArray *)sections;
- (void)replaceSectionsInRange:(NSRange)range withSectionsFromArray:(NSArray *)otherArray range:(NSRange)otherRange;
- (void)replaceSectionsInRange:(NSRange)range withSectionsFromArray:(NSArray *)otherArray;
- (void)exchangeSectionAtIndex:(NSUInteger)idx1 withSectionAtIndex:(NSUInteger)idx2;
- (void)sortSectionsUsingFunction:(NSInteger (*)(id, id, void *))compare context:(void *)context;
- (void)sortSectionsUsingSelector:(SEL)comparator;

@end

@protocol ASBBCollectionViewManagerDelegate <ASCollectionDelegateFlowLayout>



@end
