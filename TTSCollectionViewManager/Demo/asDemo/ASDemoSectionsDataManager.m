//
//  ASDemoSectionsDataManager.m
//  TTSCollectionViewManager
//
//  Created by Gary on 26/06/2017.
//  Copyright © 2017 czy. All rights reserved.
//

#import "ASDemoSectionsDataManager.h"
#import "ASDemoItem.h"
#import "ASDemoHeaderItem.h"

@implementation ASDemoSectionsDataManager

- (void)reloadView:(NSDictionary *)result block:(CollectionViewReloadCompletionBlock)completionBlock {
    NSLog(@"result = %@",result);
    __weak __typeof (self) weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        @autoreleasepool {
            NSError *error = nil;
            
            //如果是单个section的情况，可以使用父类里的一个section，每次分页请求数据回来往里塞数据即可，但是要重写configure方法，初始化section
            //            TTSCollectionViewSection *section = [TTSCollectionViewSection section];
            //            section.minimumLineSpace = 5;
            //            section.minimumInteritemSpacing = 5;
            //            CGFloat topInset = 0;
            //            if (weakSelf.collectionViewDataSource.currentPage != 1) {
            //                topInset = 5;
            //            }
            //            section.sectionEdgeInsets = UIEdgeInsetsMake(topInset, 14, 0, 14);
            //
            //            DemoHeaderItem *headerItem = [DemoHeaderItem itemWithOnViewClick:weakSelf.supplementaryViewClickHandler];
            //            section.headerItem = headerItem;
//            [self configureSection];
//            ASBBCollectionViewSection *section = self.section;
            
            
            
            NSDictionary *result_dic = [result objectForKey:@"result"];
            NSArray *dataList = [result_dic objectForKey:@"goodses"];
            NSInteger currentCount = dataList.count;
            
//            [self.addIndexPathArray removeAllObjects];
            ASBBCollectionViewSection *demoSection = nil;
            for (int i = 0;i < dataList.count;i++) {
                NSDictionary *entry = [dataList objectAtIndex:i];
                if (!(i % 2)) {
                    demoSection = [ASBBCollectionViewSection section];
                    ASBBCollectionViewSection *tts_section = (ASBBCollectionViewSection*)demoSection;
                    tts_section.minimumLineSpace = 5;
                    tts_section.minimumInteritemSpacing = 5;
                    CGFloat topInset = 0;
                    //        if (self.collectionViewDataSource.currentPage != 1) {
                    //            topInset = 5;
                    //        }
                    tts_section.sectionEdgeInsets = UIEdgeInsetsMake(topInset, 14, 0, 14);
                    
                    ASDemoHeaderItem *headerItem = [ASDemoHeaderItem itemWithOnViewClick:self.supplementaryViewClickHandler];
                    tts_section.headerItem = headerItem;
                }
                DemoModel *model = [[DemoModel alloc]initWithDictionary:entry error:&error];
                if(!error) {
                    ASDemoItem *item = [ASDemoItem itemWithModel:model
                                                    clickHandler:weakSelf.cellViewClickHandler
                                                selectionHandler:weakSelf.selectionHandler];
                    [demoSection addItem:item];
                }
                if ((i % 2)) {
                    [weakSelf updateCollectionViewData:demoSection];
                }
                
            }
            
            
            weakSelf.collectionViewDataSource.itemCount += currentCount;
            completionBlock(YES,nil,nil,currentCount);
        }
        
    });
}

-(void)refreshCell:(NSInteger)actionType dataId:(NSString *)dataId{
    if (!self.currentIndexPath) {
        return;
    }
    ASBBCollectionViewSection *section =[[self.collectionViewDataSource.manager sections]objectAtIndex:self.currentIndexPath.section];
    if (section && [[section items] count] > 0) {
        
    }
    //刷新
    [self.collectionViewDataSource.collectionView reloadItemsAtIndexPaths:@[self.currentIndexPath]];
}

-(void)cellViewClickHandler:(ASBBCollectionViewItem *)item actionType:(NSInteger)actionType{
    self.currentIndexPath = item.indexPath;
    NSLog(@"cellViewClickHandler");
}

-(void)selectionHandler:(ASBBCollectionViewItem *)item{
    self.currentIndexPath = item.indexPath;
    NSLog(@"selectionHandler");
    
    
}

- (void)configureSection {
    if (!self.section) {
        self.section = [ASBBCollectionViewSection section];
        ASBBCollectionViewSection *tts_section = (ASBBCollectionViewSection*)self.section;
        tts_section.minimumLineSpace = 5;
        tts_section.minimumInteritemSpacing = 5;
        CGFloat topInset = 0;
        //        if (self.collectionViewDataSource.currentPage != 1) {
        //            topInset = 5;
        //        }
        tts_section.sectionEdgeInsets = UIEdgeInsetsMake(topInset, 14, 0, 14);
        
        ASDemoHeaderItem *headerItem = [ASDemoHeaderItem itemWithOnViewClick:self.supplementaryViewClickHandler];
        tts_section.headerItem = headerItem;
    }
}

@end
