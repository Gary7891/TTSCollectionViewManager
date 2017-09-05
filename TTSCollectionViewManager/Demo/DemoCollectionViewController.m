//
//  DemoCollectionViewController.m
//  TTSCollectionViewManager
//
//  Created by Gary on 11/04/2017.
//  Copyright © 2017 czy. All rights reserved.
//

#import "DemoCollectionViewController.h"
#import "DemoItem.h"
#import "DemoHeaderItem.h"
#import "ASDemoItem.h"
#import "ASDemoHeaderItem.h"
#import "YYFPSLabel.h"

@interface DemoCollectionViewController ()

@property (nonatomic, strong) YYFPSLabel *fpsLabel;

@end

@implementation DemoCollectionViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.usePullReload = YES;
        self.listType = ListTypeRecommandProductList;
        self.useAS = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.requestParams setObject:@"1" forKey:@"equCode"];
    [self.requestParams setObject:@"1" forKey:@"pageNum"];
    [self.requestParams setObject:@"20" forKey:@"pageSize"];
    
//    [self registerCell:[DemoItem class]];
//    [self registerSupplementaryView:[DemoHeaderItem class]];
    [self.asCollectionNode registerSupplementaryNodeOfKind:UICollectionElementKindSectionHeader];
    
    _fpsLabel = [YYFPSLabel new];
    [_fpsLabel sizeToFit];
    CGRect frmae = _fpsLabel.frame;
    frmae.origin.x = 12;
    frmae.origin.y = 12 + 64;
    _fpsLabel.frame = frmae;
    [self.view addSubview:_fpsLabel];
}

- (void)actionOnView:(id)item actionType:(NSInteger)actionType {
    NSLog(@"%@",item);
}

- (void)actionItemClick:(id)item {
    NSLog(@"%@",item);
}

- (void)actionOnSupplementView:(id)item actionType:(NSInteger)actionType viewType:(SupplementaryViewType)viewType {
    NSLog(@"item = %@, viewType = %@",item,@(viewType));
}

- (void)actionWithPullRefresh {
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
