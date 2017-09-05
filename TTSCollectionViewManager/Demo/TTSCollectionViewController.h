//
//  TTSCollectionViewController.h
//  TTSCollectionViewManager
//
//  Created by Gary on 10/04/2017.
//  Copyright © 2017 czy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTSCollectionViewDataSource.h"

@interface TTSCollectionViewController : UIViewController <TTSCollectionViewDataSourceDelegate>

@property (nonatomic, strong ,readwrite) NSMutableDictionary           *requestParams;

@property (nonatomic ,assign) NSInteger                    listType;
@property (nonatomic ,assign) BOOL                         loaded;
@property (nonatomic ,assign) BOOL                         usePullReload;

@property (nonatomic, assign) BOOL                         useAS;

@property (nonatomic ,strong ,readwrite) UICollectionView              *collectionView;

@property (nonatomic, strong, readwrite) ASCollectionNode              *asCollectionNode;

@property (nonatomic ,strong ,readwrite) TTSCollectionViewDataSource   *dataSource;

- (void)registerCell:(Class)className;
- (void)registerSupplementaryView:(Class)className;
- (void)initCollectionLayout;



@end
