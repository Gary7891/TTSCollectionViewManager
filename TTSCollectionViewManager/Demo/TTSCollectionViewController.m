//
//  TTSCollectionViewController.m
//  TTSCollectionViewManager
//
//  Created by Gary on 10/04/2017.
//  Copyright © 2017 czy. All rights reserved.
//

#import "TTSCollectionViewController.h"
#import "TTSCollectionConfig.h"



@interface TTSCollectionViewController ()

@property (nonatomic, strong) UICollectionViewLayout *layout;



@end

@implementation TTSCollectionViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.usePullReload = YES;
        
    }
    return self;
}

- (void)loadView {
    [super loadView];
    
    if (!_useAS) {
        if (!_collectionView) {
            [self initCollectionLayout];
            _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:_layout ];
            _collectionView.frame = self.view.bounds;
            
            _collectionView.backgroundColor = [UIColor whiteColor];
            [self.view addSubview:_collectionView];
        }
    }else {
        if (!_asCollectionNode) {
            [self initCollectionLayout];
            _asCollectionNode = [[ASCollectionNode alloc]initWithFrame:self.view.bounds collectionViewLayout:_layout];
            _asCollectionNode.frame = self.view.bounds;
            _asCollectionNode.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
            _asCollectionNode.backgroundColor = [UIColor clearColor];
            [self.view addSubnode:_asCollectionNode];
        }
    }
    
    
    
}

- (void)initCollectionLayout {
    _layout = [[UICollectionViewFlowLayout alloc]init];
}

- (void)createDataSource {
    
    
    Class class = [[TTSCollectionConfig sharedInstance] dataSourceByListType:self.listType];
    if(_useAS) {
        self.dataSource = [[class alloc]initWithASCollectionView:self.asCollectionNode
                                                        listType:self.listType
                                                        delegate:self];
    }else {
        self.dataSource = [[class alloc]initWithCollectionView:self.collectionView
                                                      listType:self.listType
                                                      delegate:self];
    }
    
    
    
    
    
    
    
    //    if (_useASKit) {
    //        self.dataSource = [[BBTableViewDataSource alloc] initWithASTableView:self.asTableView
    //                                                                    listType:self.listType
    //                                                                    delegate:self];
    //    }
    //    else {
    //        self.dataSource = [[BBTableViewDataSource alloc] initWithTableView:self.tableView
    //                                                                  listType:self.listType
    //                                                                  delegate:self];
    //    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = YES;
    [self createDataSource];
    
    _requestParams = [[NSMutableDictionary alloc]init];
    
}

- (void)registerCell:(Class)className {
    NSString *itemName = NSStringFromClass(className);
    NSString *cellName = [NSString stringWithFormat:@"%@Cell",itemName];
    Class cellClass = NSClassFromString(cellName);
    [_collectionView registerClass:cellClass forCellWithReuseIdentifier:[NSString stringWithFormat:@"TTSCollectionViewManager_%@iCell", className]];

}

- (void)registerSupplementaryView:(Class)className {
    NSString *itemName = NSStringFromClass(className);
    NSString *cellName = [NSString stringWithFormat:@"%@View",itemName];
    Class cellClass = NSClassFromString(cellName);
    if(!_useAS) {
        [_collectionView registerClass:cellClass forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:[NSString stringWithFormat:@"TTSCollectionViewManager_%@iView", className]];
    }else {
        [_asCollectionNode registerSupplementaryNodeOfKind:cellName];
    }
    
}


- (void)dealloc {
    [self.dataSource stopLoading];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (animated) {
        //        [self.tableView flashScrollIndicators];
    }
    if (self.listType) {
        [self startLoadData];
    }
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:kBBReloadCellNotification object:nil];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(autoReload:)
//                                                 name:kBBAutoLoadNotification
//                                               object:nil];
}
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:kBBAutoLoadNotification
//                                                  object:nil];
//    
//    
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(reloadCell:)
//                                                 name:kBBReloadCellNotification
//                                               object:nil];
    
    
}

- (void)autoReload:(NSNotification *)notification {
    _loaded = NO;
    [self startLoadData];
}

//- (void)scrollTableViewToSearchBarAnimated:(BOOL)animated {
//    NSAssert(YES, @"This method should be handled by a subclass!");
//}



- (void)startLoadData {
    if (!_loaded) {
        [self.dataSource startLoading:NO params:self.requestParams];
        _loaded = YES;
    }
}


- (void)reloadData {
//    self.collectionView.tableFooterView = [[UIView alloc]init];
//    [self removeStateView];
    [self.dataSource reloadCollectionViewData:YES];
}

- (void)reloadCell:(NSNotification *)notification {
    NSDictionary *userInfo = [notification userInfo];
    if (userInfo) {
        NSInteger actionType = [[userInfo objectForKey:@"type"] integerValue];
        NSString *timeId = [userInfo objectForKey:@"timeId"];
        [self.dataSource refreshCell:actionType dataId:timeId];
    }
}
#pragma mark - Privare
- (void)onLeftNavClick:(id)sender {
    
}
- (void)onRightNavClick:(id)sender {
    
}

#pragma mark - TableViewDataSourceDelegate

- (void)actionOnView:(id)item actionType:(NSInteger)actionType {
    NSLog(@"%@",item);
}

- (void)actionItemClick:(id)item {
    NSLog(@"%@",item);
}

- (void)actionOnSupplementView:(id)item actionType:(NSInteger)actionType viewType:(SupplementaryViewType)viewType {
    
}

- (BOOL)showPullRefresh {
    return _usePullReload;
}


- (void)didStartLoad {
    NSLog(@"%s",__func__);
//    [self showStateView:kBBViewStateLoading];
}


- (CGPoint)offseBBorStateView:(UIView *)view {
    return CGPointMake(0, 0);
}

- (void)didFinishLoad:(TTSDataLoadPolicy)loadPolicy error:(NSError *)error {
    NSLog(@"%s",__func__);
    if (!error) {
//        [self removeStateView];
//        self.tableView.tableFooterView = [[UIView alloc] init];
    }
    else {
        NSLog(@"%s",__func__);
//        if ([error.domain isEqualToString:BB_APP_ERROR_DOMAIN]) {
//            NSInteger state = kBBViewStateNone;
//            if (error.code == kBBErrorCodeAPI ||
//                error.code == kBBErrorCodeHTTP ||
//                error.code == kBBErrorCodeUnknown) {
//                state = kBBViewStateDataError;
//            }
//            if (error.code == kBBErrorCodeNetwork) {
//                state = kBBViewStateNetError;
//            }
//            if (error.code == kBBErrorCodeEmpty) {
//                state = kBBViewStateNoData;
//            }
//            if (error.code == kBBErrorCodeLocationError) {
//                state = kBBViewStateLocationError;
//            }
//            if (error.code == kBBErrorCodePhotosError) {
//                state = kBBViewStatePhotosError;
//            }
//            if (error.code == kBBErrorCodeMicrophoneError) {
//                state = kBBViewStateMicrophoneError;
//            }
//            if (error.code == kBBErrorCodeCameraError) {
//                state = kBBViewStateCameraError;
//            }
//            if (error.code == kBBErrorCodeContactsError) {
//                state = kBBViewStateContactsError;
//            }
//            [self showStateView:state];
//        }
//        else {
//            [self showStateView:kBBViewStateDataError];
//        }
    }
}

- (void)didFinishLoad:(TTSDataLoadPolicy)loadPolicy object:(id)object error:(NSError *)error {
    [self didFinishLoad:loadPolicy error:error];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
