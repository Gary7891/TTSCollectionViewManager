//
//  DemoDataManager.m
//  TTSCollectionViewManager
//
//  Created by Gary on 10/04/2017.
//  Copyright © 2017 czy. All rights reserved.
//

#import "DemoDataManager.h"
#import "DemoItem.h"
#import "DemoHeaderItem.h"

@interface DemoDataManager ()



@end

@implementation DemoDataManager



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
            [self configureSection];
            TTSCollectionViewSection *section = self.section;
            
            
            
            NSDictionary *result_dic = [result objectForKey:@"result"];
            NSArray *dataList = [result_dic objectForKey:@"goodses"];
            NSInteger currentCount = dataList.count;
            
            for (NSDictionary *entry in dataList) {
                DemoModel *model = [[DemoModel alloc]initWithDictionary:entry error:&error];
                if(!error) {
                    DemoItem *item = [DemoItem itemWithModel:model
                                                clickHandler:weakSelf.cellViewClickHandler
                                            selectionHandler:weakSelf.selectionHandler];
                    [section addItem:item];
                }
                

            }

            [weakSelf updateCollectionViewData:section];
            weakSelf.collectionViewDataSource.itemCount += currentCount;
            completionBlock(YES,nil,nil,currentCount);
        }
        
    });
}

-(void)refreshCell:(NSInteger)actionType dataId:(NSString *)dataId{
    if (!self.currentIndexPath) {
        return;
    }
    TTSCollectionViewSection *section =[[self.collectionViewDataSource.manager sections]objectAtIndex:self.currentIndexPath.section];
    if (section && [[section items] count] > 0) {
        
    }
    //刷新
    [self.collectionViewDataSource.collectionView reloadItemsAtIndexPaths:@[self.currentIndexPath]];
}

-(void)cellViewClickHandler:(TTSCollectionViewItem *)item actionType:(NSInteger)actionType{
    self.currentIndexPath = item.indexPath;
    NSLog(@"cellViewClickHandler");
}

-(void)selectionHandler:(TTSCollectionViewItem *)item{
    self.currentIndexPath = item.indexPath;
    NSLog(@"selectionHandler");
    
    
}

- (void)configureSection {
    if (!self.section) {
        self.section = [TTSCollectionViewSection section];
        TTSCollectionViewSection *tts_section = (TTSCollectionViewSection*)self.section;
        tts_section.minimumLineSpace = 5;
        tts_section.minimumInteritemSpacing = 5;
        CGFloat topInset = 0;
//        if (self.collectionViewDataSource.currentPage != 1) {
//            topInset = 5;
//        }
        tts_section.sectionEdgeInsets = UIEdgeInsetsMake(topInset, 14, 0, 14);
        
        DemoHeaderItem *headerItem = [DemoHeaderItem itemWithOnViewClick:self.supplementaryViewClickHandler];
        tts_section.headerItem = headerItem;
    }
}




@end
