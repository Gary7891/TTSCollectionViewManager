//
//  DemoDataSource.m
//  TTSCollectionViewManager
//
//  Created by Gary on 11/04/2017.
//  Copyright © 2017 czy. All rights reserved.
//

#import "DemoDataSource.h"
#import <MJRefresh/MJRefresh.h>

@implementation DemoDataSource


- (void)addPullRefresh {
    __weak __typeof(self) weakSelf = self;
    if (self.collectionView) {
        self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            
            NSLog(@"addd  refresh");
            
            [weakSelf reloadCollectionViewData:YES];
            
        }];
    }else if (self.asCollectionView) {
        self.asCollectionView.view.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            
            NSLog(@"addd  refresh");
            
            [weakSelf reloadCollectionViewData:YES];
            
        }];
    }
    
   
}

- (void)startPullRefresh {
//    [self.collectionView.mj_header beginRefreshing];
    [super startPullRefresh];
}

- (void)stopPullRefresh {
    if (self.collectionView) {
        [self.collectionView.mj_header endRefreshing];
    }else if (self.asCollectionView) {
        [self.asCollectionView.view.mj_header endRefreshing];
    }
    
}

- (void)addLoadingMoreView {
    __weak __typeof(self) weakSelf = self;
    if (self.collectionView) {
        self.collectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            [weakSelf loadMore];
            
        }];
        self.collectionView.mj_footer.hidden = YES;
    }
//    else if (self.asCollectionView) {
//        self.asCollectionView.view.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
//            [weakSelf loadMore];
//            
//        }];
//        self.asCollectionView.view.mj_footer.hidden = YES;
//    }
    
    
}

- (void)setFooterViewState {
    if (self.collectionView) {
        if (self.currentPage < self.totalPage) {
            self.collectionView.mj_footer.hidden = NO;
        }else {
            self.collectionView.mj_footer.hidden = YES;
        }
    }
//    else if (self.asCollectionView) {
//        if (self.currentPage < self.totalPage) {
//            self.asCollectionView.view.mj_footer.hidden = NO;
//        }else {
//            self.asCollectionView.view.mj_footer.hidden = YES;
//        }
//    }
    
}

- (void)stopLoadMore {
    if (self.collectionView) {
        [self.collectionView.mj_footer endRefreshing];
    }
//    else if (self.asCollectionView) {
//        [self.asCollectionView.view.mj_footer endRefreshing];
//    }
    
}



@end
