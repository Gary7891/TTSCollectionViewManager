//
//  TTSCollectionViewDataManager.m
//  TTSCollectionViewManager
//
//  Created by Gary on 07/04/2017.
//  Copyright © 2017 czy. All rights reserved.
//

#import "TTSCollectionViewDataManager.h"


@implementation TTSCollectionViewDataManager


- (instancetype)initWithDataSource:(TTSCollectionViewDataSource *)collectionViewDataSource listType:(NSInteger)listType {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _addIndexPathArray = [[NSMutableArray alloc]init];
    
    _collectionViewDataSource = collectionViewDataSource;
    __weak __typeof(self)weakSelf = self;
    _cellViewClickHandler = ^ (id item ,NSInteger actionType) {
        if ([item isKindOfClass:[TTSCollectionViewItem class]]) {
            weakSelf.currentIndexPath = ((TTSCollectionViewItem*)item).indexPath;
            [((TTSCollectionViewItem*)item) deselectRowAnimated:YES];
        }
        
        if ([item isKindOfClass:[ASBBCollectionViewItem class]]) {
            weakSelf.currentIndexPath = ((ASBBCollectionViewItem*)item).indexPath;
            [((ASBBCollectionViewItem*)item) deselectRowAnimated:YES];
        }
        
        if ([weakSelf.collectionViewDataSource.delegate respondsToSelector:@selector(actionOnView:actionType:)]) {
            [weakSelf.collectionViewDataSource.delegate actionOnView:item actionType:actionType];
        }
        [weakSelf cellViewClickHandler:item actionType:actionType];
    };
    _selectionHandler = ^(id item) {
        if ([item isKindOfClass:[TTSCollectionViewItem class]]) {
            weakSelf.currentIndexPath = ((TTSCollectionViewItem*)item).indexPath;
            [((TTSCollectionViewItem*)item) deselectRowAnimated:YES];
        }
        if ([item isKindOfClass:[ASBBCollectionViewItem class]]) {
            weakSelf.currentIndexPath = ((ASBBCollectionViewItem*)item).indexPath;
            [((ASBBCollectionViewItem*)item) deselectRowAnimated:YES];
        }
        
        
        if ([weakSelf.collectionViewDataSource.delegate respondsToSelector:@selector(actionItemClick:)]) {
            [weakSelf.collectionViewDataSource.delegate actionItemClick:item];
            
        }
        [weakSelf selectionHandler:item];
    };
    
    _supplementaryViewClickHandler = ^(id item, NSInteger actionType,SupplementaryViewType viewType) {

        if ([weakSelf.collectionViewDataSource.delegate respondsToSelector:@selector(actionOnSupplementView:actionType:viewType:)]) {
            [weakSelf.collectionViewDataSource.delegate actionOnSupplementView:item actionType:actionType viewType:viewType];
        }
    };

    self.serialQueue = dispatch_queue_create("com.tticar.www", DISPATCH_QUEUE_SERIAL);
    return self;
    
}


- (void)reloadView:(NSDictionary *)result block:(CollectionViewReloadCompletionBlock)completionBlock {
    
}

- (void)refreshCell:(NSInteger)actionType dataId:(NSString *)dataId {
    
}

- (void)cellViewClickHandler:(id)item actionType:(NSInteger)actionType {
    
}
- (void)selectionHandler:(id)item {
    
}

- (void)supplementaryViewClickHandler:(id)item actionType:(NSInteger)actionType viewType:(NSInteger)viewType{
    
}
- (void)deleteHanlder:(id)item completion:(void (^)(void))completion {
    
}

- (void)configureSection {
    
}

- (void)updateCollectionViewData:(id)section {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (!_section) {
            NSInteger sectionCount = 0;
            if (self.collectionViewDataSource.manager) {
                sectionCount = [self.collectionViewDataSource.manager.sections count];
                [self.collectionViewDataSource.manager addSection:section];
            }else {
                sectionCount = [self.collectionViewDataSource.asManager.sections count];
                [self.collectionViewDataSource.asManager addSection:section];
            }
            
            if (sectionCount > 0) {
                if (self.collectionViewDataSource.collectionView) {
                    if ([self.collectionViewDataSource.collectionView numberOfSections] == sectionCount) {
                        [self.collectionViewDataSource.collectionView insertSections:[NSIndexSet indexSetWithIndex:sectionCount]];
                    }
                }else {
                    [self.collectionViewDataSource.asCollectionView performBatchAnimated:YES updates:^{
                        [self.collectionViewDataSource.asCollectionView insertSections:[NSIndexSet indexSetWithIndex:sectionCount]];
                    } completion:self.collectionViewDataSource.asBtchCompletionBlock];
                    
                    
                }
                
            }
            else {
                if (self.collectionViewDataSource.collectionView) {
                    [self.collectionViewDataSource.collectionView reloadData];
                }else {
                    [self.collectionViewDataSource.asCollectionView reloadData];
                }
                
            }
        }else {
            if (section == _section) {
                if ([_section isKindOfClass:[TTSCollectionViewSection class]]) {
                    if (![self.collectionViewDataSource.manager.sections containsObject:section]) {
                        [self.collectionViewDataSource.manager addSection:section];
                    }
                    [self.collectionViewDataSource.collectionView reloadData];
                }else {
                    if (![self.collectionViewDataSource.asManager.sections containsObject:section]) {
                        [self.collectionViewDataSource.asManager addSection:section];
                        [self.collectionViewDataSource.asCollectionView reloadData];
                    }else {
                        if (self.collectionViewDataSource.currentPage != 1) {
                            [self.collectionViewDataSource.asCollectionView performBatchAnimated:YES updates:^{
                                [self.collectionViewDataSource.asCollectionView insertItemsAtIndexPaths:self.addIndexPathArray];
                            } completion:self.collectionViewDataSource.asBtchCompletionBlock];
                        }else {
                            [self.collectionViewDataSource.asCollectionView reloadSections:[NSIndexSet indexSetWithIndex:0]];
                        }
                        
                    }
                    
                }
                
            }
        }
        
    });
}



@end
