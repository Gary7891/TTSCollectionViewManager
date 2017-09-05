//
//  CompareCollectionCollectionViewController.m
//  TTSCollectionViewManager
//
//  Created by Gary on 11/04/2017.
//  Copyright © 2017 czy. All rights reserved.
//

#import "CompareCollectionCollectionViewController.h"
#import "CompareCellCollectionViewCell.h"
#import "DemoModel.h"
#import <UIImageView+WebCache.h>
#import <BBNetwork.h>
#import "CompareRequest.h"
#import "NetworkAssistant.h"
#import <MJRefresh/MJRefresh.h>

@interface CompareCollectionCollectionViewController ()<UICollectionViewDelegateFlowLayout,UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) NSMutableArray         *dataArray;

@property (nonatomic, strong) CompareRequest         *dataRequest;

@property (nonatomic, strong) UICollectionView       *collectionView;

@end

@implementation CompareCollectionCollectionViewController

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    UIBarButtonItem *barButtonSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    [barButtonSpacer setWidth:10];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"刷新" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
//    UIImage *buttomImage = [UIImage imageNamed:imageName];
//    UIImage *buttomImageH = [UIImage imageNamed:selectedImageName];
//    [button setSize:buttomImage.size];
//    [button setImage:buttomImage forState:UIControlStateNormal];
//    [button setImage:buttomImageH forState:UIControlStateHighlighted];
//    [button setImage:buttomImageH forState:UIControlStateSelected];
    [button sizeToFit];
    [button addTarget:self action:@selector(getDataFromServer) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    self.navigationItem.rightBarButtonItems = @[barButtonSpacer,barButtonItem];
    
    
    UICollectionViewFlowLayout *floaLayout = [[UICollectionViewFlowLayout alloc]init];
    floaLayout.sectionInset = UIEdgeInsetsMake(5, 14, 0, 14);
    floaLayout.itemSize = CGSizeMake(167, 167);
    _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:floaLayout ];
    _collectionView.frame = self.view.bounds;
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    
    _collectionView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_collectionView];
    
    // Register cell classes
    [self.collectionView registerClass:[CompareCellCollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    _dataArray = [[NSMutableArray alloc]init];
    
    [self getDataFromServer];
     __weak __typeof(self) weakSelf = self;
    
    _collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        NSLog(@"addd  refresh");
        
        [weakSelf getDataFromServer];
        
    }];
    
    self.collectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [weakSelf loadMore];
        
    }];
    self.collectionView.mj_footer.hidden = YES;
}

- (void)getDataFromServer {
    
    NSDictionary *params = @{
                             @"equCode"     :    @"1",
                             @"pageNum"     :    @"1",
                             @"pageSize"    :    @"20"
                             };
//    __weak __typeof(self) weakSelf = self;
    // 请求成功后的操作
    void (^successCompletionBlock)(BBBaseRequest *request) = ^(__kindof BBBaseRequest *request){

        id result = request.responseObject;
        NSDictionary *result_dic = [result objectForKey:@"result"];
        NSArray *dataList = [result_dic objectForKey:@"goodses"];
        
        NSError *error = nil;
        for (NSDictionary *entry in dataList) {
            DemoModel *model = [[DemoModel alloc]initWithDictionary:entry error:&error];
            if(!error) {
                [_dataArray addObject:model];
            }
        }
        [self.collectionView reloadData];
        [self.collectionView.mj_header endRefreshing];
        [self.collectionView.mj_footer endRefreshing];
        
        self.collectionView.mj_footer.hidden = NO;
        
    };
    // 请求失败后的操作
    void (^failureCompletionBlock)(BBBaseRequest *request) = ^(__kindof BBBaseRequest *request){
       [self.collectionView.mj_header endRefreshing];
        [self.collectionView.mj_footer endRefreshing];
    };
    
    _dataRequest = [[CompareRequest alloc]init];
    
    NSString *url = INTERFACE_PRODUCTS;
    _dataRequest.requestURL = url;
    _dataRequest.requestArgument = params;
    [_dataRequest startWithOutCacheSuccess:successCompletionBlock failure:failureCompletionBlock];
    
//    [[NetworkAssistant sharedAssistant] getDataByURL:url
//                                              params:params
//                                            fileData:nil
//                                                 hud:nil
//                                               start:nil
//                                           completed:^(id result, NSError *error) {
//                                               NSLog(@"result = %@",result);
//                                           }];
    
}

- (void)loadMore {
    // 请求成功后的操作
    void (^successCompletionBlock)(BBBaseRequest *request) = ^(__kindof BBBaseRequest *request){
        
        id result = request.responseObject;
        NSDictionary *result_dic = [result objectForKey:@"result"];
        NSArray *dataList = [result_dic objectForKey:@"goodses"];
        
        NSError *error = nil;
        for (NSDictionary *entry in dataList) {
            DemoModel *model = [[DemoModel alloc]initWithDictionary:entry error:&error];
            if(!error) {
                [_dataArray addObject:model];
            }
        }
        [self.collectionView reloadData];
        [self.collectionView.mj_header endRefreshing];
        [self.collectionView.mj_footer endRefreshing];
    };
    // 请求失败后的操作
    void (^failureCompletionBlock)(BBBaseRequest *request) = ^(__kindof BBBaseRequest *request){
        [self.collectionView.mj_header endRefreshing];
        [self.collectionView.mj_footer endRefreshing];
    };
    NSDictionary *params = _dataRequest.requestArgument;
    NSInteger pageNum = [[params objectForKey:@"pageNum"] integerValue];
    pageNum++;
    [_dataRequest.requestArgument setValue:[NSString stringWithFormat:@"%@",@(pageNum)] forKey:@"pageNum"];
    [_dataRequest startWithOutCacheSuccess:successCompletionBlock failure:failureCompletionBlock];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {

    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CompareCellCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    if (!cell) {
        cell = [[CompareCellCollectionViewCell alloc]init];
        
    }
    if (!cell.loaded) {
        [cell cellDidLoad];
    }
    
   
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    UIImageView *imageView = [cell viewWithTag:1];
    UILabel *productLabel = [cell viewWithTag:2];
    UILabel *priceLabel = [cell viewWithTag:3];
    DemoModel *model = [self.dataArray objectAtIndex:indexPath.row];
    if (model.path.length) {
        NSString *urlStr = IMAGESCALESCHEME(TT_Global_Photo_Domain,model.path, 167, 167);
        [imageView sd_setImageWithURL:[NSURL URLWithString:urlStr]];
    }
    
    if (model.name.length) {
        productLabel.text = model.name;
    }
    
    if (model.price.length) {
        priceLabel.text = model.price;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    CompareCellCollectionViewCell *demoCell = (CompareCellCollectionViewCell*)cell;
    demoCell.imageView.image = nil;
    demoCell.productNameLabel.text = nil;
    demoCell.priceLabel.text = nil;
}

#pragma mark <UICollectionViewDelegate>

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

@end
