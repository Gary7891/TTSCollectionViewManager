//
//  TTSCollectionViewManager.h
//  TTSCollectionViewManager
//
//  Created by Gary on 05/04/2017.
//  Copyright © 2017 czy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TTSCollectionViewItem.h"
#import "TTSCollectionReusableViewItem.h"
#import "TTSCollectionViewSection.h"
#import "TTSCollectionViewItemCell.h"
#import "TTSCollectionReusableViewItemView.h"


@protocol TTSCollectionViewManagerDelegate;

@interface TTSCollectionViewManager : NSObject <UICollectionViewDelegateFlowLayout,UICollectionViewDataSource>

@property (nonatomic, strong) NSArray *sections;

/**
 *  UICollectionView
 */
@property (weak, nonatomic) UICollectionView *collectionView;
@property (assign, nonatomic) id<TTSCollectionViewManagerDelegate> delegate;
@property (strong, nonatomic) NSMutableDictionary *registeredClasses;



- (instancetype)initWithCollectionView:(UICollectionView *)collectionView delegate:(id<TTSCollectionViewManagerDelegate>)delegate;
- (instancetype)initWithCollectionView:(UICollectionView*)collectionView;
- (void)registerClass:(NSString *)objectClass forCellWithReuseIdentifier:(NSString *)identifier;
- (Class)classForCellAtIndexPath:(NSIndexPath *)indexPath;
- (Class)classForSupplementaryHeaderAtSection:(NSInteger)section;
- (Class)classForSupplementaryFooterAtSection:(NSInteger)section;
- (id)objectAtKeyedSubscript:(id <NSCopying>)key;
- (void)setObject:(id)obj forKeyedSubscript:(id <NSCopying>)key;

- (void)addSection:(TTSCollectionViewSection *)section;
- (void)addSectionsFromArray:(NSArray *)array;
- (void)insertSection:(TTSCollectionViewSection *)section atIndex:(NSUInteger)index;
- (void)insertSections:(NSArray *)sections atIndexes:(NSIndexSet *)indexes;
- (void)removeSection:(TTSCollectionViewSection *)section;
- (void)removeAllSections;
- (void)removeSectionIdenticalTo:(TTSCollectionViewSection *)section inRange:(NSRange)range;
- (void)removeSectionIdenticalTo:(TTSCollectionViewSection *)section;
- (void)removeSectionsInArray:(NSArray *)otherArray;
- (void)removeSectionsInRange:(NSRange)range;
- (void)removeSection:(TTSCollectionViewSection *)section inRange:(NSRange)range;
- (void)removeLastSection;
- (void)removeSectionAtIndex:(NSUInteger)index;
- (void)removeSectionsAtIndexes:(NSIndexSet *)indexes;
- (void)replaceSectionAtIndex:(NSUInteger)index withSection:(TTSCollectionViewSection *)section;
- (void)replaceSectionsWithSectionsFromArray:(NSArray *)otherArray;
- (void)replaceSectionsAtIndexes:(NSIndexSet *)indexes withSections:(NSArray *)sections;
- (void)replaceSectionsInRange:(NSRange)range withSectionsFromArray:(NSArray *)otherArray range:(NSRange)otherRange;
- (void)replaceSectionsInRange:(NSRange)range withSectionsFromArray:(NSArray *)otherArray;
- (void)exchangeSectionAtIndex:(NSUInteger)idx1 withSectionAtIndex:(NSUInteger)idx2;
- (void)sortSectionsUsingFunction:(NSInteger (*)(id, id, void *))compare context:(void *)context;
- (void)sortSectionsUsingSelector:(SEL)comparator;

@end


@protocol TTSCollectionViewManagerDelegate <UICollectionViewDelegateFlowLayout>



@end
