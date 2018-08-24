//
//  TTSCollectionViewDataSource.m
//  TTSCollectionViewManager
//
//  Created by Gary on 07/04/2017.
//  Copyright © 2017 czy. All rights reserved.
//

#import "TTSCollectionViewDataSource.h"
#import "TTSCollectionViewManager.h"
#import "TTSCollectionViewItem.h"
#import "TTSClassList.h"
#import "TTSCollectionConfig.h"
#import "TTSCollectionViewDataManager.h"
#import "TTSCollectionViewRequest.h"

@interface TTSCollectionViewDataSource () <TTSCollectionViewManagerDelegate,ASBBCollectionViewManagerDelegate>

/**
 *  向上滚动阈值
 */
@property (nonatomic ,assign) CGFloat                        upThresholdY;
/**
 *  向下阈值
 */
@property (nonatomic ,assign) CGFloat                        downThresholdY;
/**
 *  当前滚动方向
 */
@property (nonatomic ,assign) NSInteger                previousScrollDirection;
/**
 *  Y轴偏移
 */
@property (nonatomic ,assign) CGFloat                        previousOffsetY;
/**
 *  Y积累总量
 */
@property (nonatomic ,assign) CGFloat                        accumulatedY;

/**
 *  当前列表 NSIndexPath
 */
@property (nonatomic ,strong) NSIndexPath                    *currentIndexPath;
/**
 *  当前列表缓存key
 */
@property (nonatomic ,copy  ) NSString                       *cacheKey;

@property (nonatomic, strong) TTSCollectionViewRequest       *collectionViewRequest;


@property (nonatomic ,assign) BOOL buildingView;

@property (nonatomic ,assign) BOOL loadCacheData;

@end

@implementation TTSCollectionViewDataSource

- (id)initWithCollectionView:(UICollectionView *)collectionView
               listType:(NSInteger)listType
               delegate:(id /**<TTSCollectionViewDataSourceDelegate>*/)delegate {
    self = [super init];
    if (!self)
        return nil;
    //列表管理器
    _delegate  = delegate;
    _listType  = listType;
    _collectionView = collectionView;
    _manager = [[TTSCollectionViewManager alloc] initWithCollectionView:collectionView delegate:self];
    
    
    [self setupDataSource];
    return self;
}

- (id)initWithASCollectionView:(ASCollectionNode *)collectionView
                      listType:(NSInteger)listType
                      delegate:(id)delegate {
    self = [super init];
    if (!self)
        return nil;
    //列表管理器
    _delegate  = delegate;
    _listType  = listType;
    _asCollectionView = collectionView;
    _asCollectionView.view.leadingScreensForBatching = 2;
    _asManager = [[ASBBCollectionViewManager alloc] initWithCollectionView:collectionView delegate:self];
    
    
    [self setupDataSource];
    return self;
}

/**
 *  初始化方法
 */
- (void)setupDataSource {
    //注册Cell
    [self registerClass];
    
    if (self.listType && [self.delegate showPullRefresh]) {
        [self addPullRefresh];
    }
    [self addLoadingMoreView];
    _downThresholdY = 200.0;
    _upThresholdY = 25.0;
    _collectionViewRequest = [[TTSCollectionViewRequest alloc] init];
    Class className = [[TTSCollectionConfig sharedInstance] dataManagerByListType:_listType];
    if (className) {

        _collectionViewDataManager = [[className alloc] initWithDataSource:self listType:_listType];
        _collectionViewDataManager.listType = _listType;
    }

    
}

- (void)addPullRefresh {
    
}

- (void)startPullRefresh {
    [self load:TTSDataLoadPolicyReload params:_params];
    if (self.delegate && [self.delegate respondsToSelector:@selector(actionWithPullRefresh)]) {
        [self.delegate actionWithPullRefresh];
    }
    
}

- (void)stopPullRefresh {
    
}

- (void)addLoadingMoreView {
    
}

- (void)stopLoadMore {
    
}

- (void)setFooterViewState {
    
}


#pragma mark - Private 
/**
 *  注册列表Cell类型
 */
- (void)registerClass {
    NSArray *collectionViewViewItemlist = [TTSClassList subclassesOfClass:[TTSCollectionViewItem class]];
        for (Class itemClass in collectionViewViewItemlist) {
        NSString *itemName = NSStringFromClass(itemClass);
        
        self.manager[itemName]   = [itemName stringByAppendingString:@"Cell"];
        
    }
    
    NSArray *asCollectionViewViewItemlist = [TTSClassList subclassesOfClass:[ASBBCollectionViewItem class]];
    for (Class itemClass in asCollectionViewViewItemlist) {
        NSString *itemName = NSStringFromClass(itemClass);
        
        self.asManager[itemName]   = [itemName stringByAppendingString:@"Cell"];
        
    }
    
    NSArray *collectionViewSumpplementaryItemlist = [TTSClassList subclassesOfClass:[TTSCollectionReusableViewItem class]];
    for (Class itemClass in collectionViewSumpplementaryItemlist) {
        NSString *itemName = NSStringFromClass(itemClass);
        
        self.manager[itemName]   = [itemName stringByAppendingString:@"View"];
        
    }
    
    NSArray *asCollectionViewSumpplementaryItemlist = [TTSClassList subclassesOfClass:[ASBBCollectionReusableViewItem class]];
    for (Class itemClass in asCollectionViewSumpplementaryItemlist) {
        NSString *itemName = NSStringFromClass(itemClass);
        
        self.asManager[itemName]   = [itemName stringByAppendingString:@"View"];
        
    }
}

- (void)reloadCollectionViewData:(BOOL)pullToRefresh {
    if (pullToRefresh) {
        pullToRefresh = [self.delegate showPullRefresh];
	_itemCount = 0;
    }
    if (pullToRefresh) {
        [self startPullRefresh];
    }
    else {
        [self load:TTSDataLoadPolicyReload params:_params];
    }
}

- (void)startLoading:(BOOL)pullToRefresh params:(NSDictionary *)params {
    if (pullToRefresh) {
        pullToRefresh = [self.delegate showPullRefresh];
        _itemCount = 0;
    }
    if (pullToRefresh) {
        _params = [NSMutableDictionary dictionaryWithDictionary:params];
        [self startPullRefresh];
    }
    else {
        //        //第一次从缓存中加载
        //        [self load:DataLoadPolicyCache params:params];
        
        //第一次从缓存中加载
        if (_useCacheData) {
            [self load:TTSDataLoadPolicyCache params:params];
            
        }//不缓存
        else{
            [self load:TTSDataLoadPolicyNone params:params];
            
        }
    }
}

- (void)load:(TTSDataLoadPolicy)loadPolicy params:(NSDictionary *)params {
    if (_loading) {
        return;
    }
    if (loadPolicy == TTSDataLoadPolicyMore) {
        if (_currentPage == _totalPage) {
            _finished = YES;
            return;
        }
        _currentPage++;
    }
    else {
        _currentPage = 1;
        _totalPage = 1;
        _finished = NO;
//        [self setLastedId:@""];
    }
    //处理网络数据
    if (!_params) {
        _params = [NSMutableDictionary dictionaryWithCapacity:1];
    }
    [_params setValue:[NSNumber numberWithInteger:_currentPage] forKey:@"pageNum"];
    if (self.pageSize > 0) {
        [_params setObject:@(self.pageSize) forKey:@"pageSize"];
    }
    else {
        [_params setObject:@([TTSCollectionConfig pageSize])
                    forKey:@"pageSize"];
        
    }
    
    if (params) {
        [_params addEntriesFromDictionary:params];
    }
    
    // 请求成功后的操作
//    __weak __typeof(self) weakSelf = self;
    void (^successCompletionBlock)(BBBaseRequest *request) = ^(__kindof BBBaseRequest *request){
        TTSCollectionViewLogDebug(@"get data from server %@ page:%@",request.requestUrl,@(self.currentPage));
        _loading = NO;
        [self handleCollectionViewData:request.responseObject dataLoadPolicy:loadPolicy error:nil];
        if (loadPolicy == TTSDataLoadPolicyMore) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self stopLoadMore];
            });
        }
    };
    // 请求失败后的操作
    void (^failureCompletionBlock)(BBBaseRequest *request) = ^(__kindof BBBaseRequest *request){
        TTSCollectionViewLogDebug(@"get data from %@ error :%@ userinfo:%@",request.requestUrl,request.error,request.userInfo);
        _loading = NO;
        if ([request cacheResponseObject]) {
            [self handleCollectionViewData:[request cacheResponseObject]
                    dataLoadPolicy:loadPolicy
                             error:nil];
        }
        else {
            [self handleCollectionViewData:nil
                    dataLoadPolicy:loadPolicy
                             error:request.error];
        }
    };
    
    NSString *url = [[TTSCollectionConfig sharedInstance] urlByListType:_listType];
    _collectionViewRequest.requestURL = url;
    _collectionViewRequest.requestArgument = _params;
    
    //加载第一页时候使用缓存数据
    if ([_collectionViewRequest cacheResponseObject] && _useCacheData) {
        //使用缓存数据绘制UI
        TTSCollectionViewLogDebug(@"use cache data for %@",_collectionViewRequest.requestURL);
        [self handleCollectionViewData:[_collectionViewRequest cacheResponseObject]
                dataLoadPolicy:TTSDataLoadPolicyCache
                         error:nil];
        _loading = NO;
    }
    else if (loadPolicy == TTSDataLoadPolicyMore) {
        [_collectionViewRequest startWithOutCacheSuccess:successCompletionBlock
                                       failure:failureCompletionBlock];
        _loading = YES;
    }
    else {
        [_collectionViewRequest startWithCompletionBlockWithSuccess:successCompletionBlock
                                                  failure:failureCompletionBlock];
        _loading = YES;
    }
    
    
    
    
    
}

- (void)handleCollectionViewData:(id) result dataLoadPolicy:(TTSDataLoadPolicy) dataLoadPolicy error:(NSError *)hanldeError {
    
    TTSCollectionViewLogDebug(@"%s",__func__);
    self.buildingView = YES;
    if (dataLoadPolicy == TTSDataLoadPolicyReload ||
        dataLoadPolicy == TTSDataLoadPolicyNone) {
        //重新加载
        
        if (!self.collectionViewDataManager.section) {
            [self.manager removeAllSections];
            [self.asManager removeAllSections];
        }else {
            [self.collectionViewDataManager.section removeAllItems];
        }
        
        
    }
    
    if (!result && dataLoadPolicy == TTSDataLoadPolicyCache) {
        //缓存数据为空，触发下拉刷新操作
        [self startPullRefresh];
        return;
    }
    
    id listDic = [result objectForKey:@"result"] ;
    if ([listDic isKindOfClass:[NSDictionary class]]) {
        id sizeDic = [listDic objectForKey:@"size"];
        if (sizeDic) {
            [self setTotalPage:[sizeDic integerValue]];
        }
    }
    
    if (_totalPage == 0) {
        _totalPage = 1;
        _currentPage = 1;
    }
    if (dataLoadPolicy == TTSDataLoadPolicyMore) {
        //来自加载下一页,移除loading item
//        NSInteger lastSectionIndex = 0;
//        lastSectionIndex = [[self.manager sections] count] - 1;
//        [self.manager removeLastSection];
//        
//        
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [self.collectionView deleteSections:[NSIndexSet indexSetWithIndex:lastSectionIndex]];
//        });
    }
    [self.collectionViewDataManager reloadView:result block:^(BOOL finished, id object, NSError *error, NSInteger currentItemCount) {
        if (finished) {
            //加载列
            self.buildingView = NO;
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self setFooterViewState];
                
                //数据加载完成
                if (self.delegate && [self.delegate respondsToSelector:@selector(didFinishLoad:error:)]) {
                    [self.delegate didFinishLoad:dataLoadPolicy error:error?error:hanldeError];
                    [self stopPullRefresh];
                }
                if (self.delegate && [self.delegate respondsToSelector:@selector(didFinishLoad:object:error:)]) {
                    [self.delegate didFinishLoad:dataLoadPolicy object:object error:error?error:hanldeError];
                    [self stopPullRefresh];
                }
                switch (dataLoadPolicy) {
                    case TTSDataLoadPolicyNone:
                        break;
                    case TTSDataLoadPolicyCache:
                        //开始下拉刷新
                        [self startPullRefresh];
                        break;
                    case TTSDataLoadPolicyMore:{
                        
                    }
                        break;
                    case TTSDataLoadPolicyReload:
                        //结束下拉刷新动画
                        //                             if(self.delegate && [self.delegate respondsToSelector:@selector(stopPullRefresh)]){
                        //                                 [self.delegate stopPullRefresh];
                        //                             }
                        //                             [self stopPullRefresh];
                        break;
                    default:
                        break;
                }
            });
        }
    }];
}

- (void)dealloc {
    _manager.delegate = nil;
    _collectionView = nil;
//    _asCollectionView = nil;
    _manager = nil;
    
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)refreshCell:(NSInteger)actionType dataId:(NSString *)dataId {
    if (_collectionViewDataManager) {
        [_collectionViewDataManager refreshCell:actionType dataId:dataId];
    }
}

- (id)collectionViewItemByIndexPath:(NSIndexPath *)indexPath {
    
    if (self.manager) {
        TTSCollectionViewSection * section = [[self.manager sections] objectAtIndex:indexPath.section];
        if (section && [[section items] count] > 0) {
            TTSCollectionViewItem *item = (TTSCollectionViewItem *)[[section items] objectAtIndex:indexPath.row];
            if (item) {
                return item;
            }
        }
    }
    if (self.asManager) {
        ASBBCollectionViewSection * section = [[self.asManager sections] objectAtIndex:indexPath.section];
        if (section && [[section items] count] > 0) {
            ASBBCollectionViewItem *item = (ASBBCollectionViewItem *)[[section items] objectAtIndex:indexPath.row];
            if (item) {
                return item;
            }
        }
    }
    
    return nil;
}
#pragma mark - Private



/**
 *  滚动方向判断
 *
 *  @param currentOffsetY 当前偏移量
 *  @param previousOffsetY 累加偏移量
 *
 *  @return ScrollDirection
 */
- (NSInteger)detectScrollDirection:(CGFloat)currentOffsetY previousOffsetY:(CGFloat)previousOffsetY {
    return currentOffsetY > previousOffsetY ? TTSCollectionViewScrollDirectionUp   :
    currentOffsetY < previousOffsetY ? TTSCollectionViewScrollDirectionDown :
    TTSCollectionViewScrollDirectionNone;
}





- (void)loadMore {
    if (_currentPage < _totalPage) {
        [self load:TTSDataLoadPolicyMore params:_params];
    }else {
        [self stopLoadMore];
    }
}

#pragma mark - Delegate

#pragma mark - CollectionViewManagerDelegate

- (BOOL)shouldBatchFetchForCollectionNode:(ASCollectionNode *)collectionNode {
     return _currentPage < _totalPage;;
}

- (void)collectionNode:(ASCollectionNode *)collectionNode willBeginBatchFetchWithContext:(ASBatchContext *)context {
    
    if (!_asBtchCompletionBlock) {
        _asBtchCompletionBlock = ^(BOOL finished) {
            [context completeBatchFetching:YES];
        };
    }
    
    [self loadMore];
    
    
}

#pragma mark - UIScrollViewDelegate

- (void)stopLoading {
    if (_listType || [self.delegate showPullRefresh]) {
        [self stopPullRefresh];
    }
}


#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (_delegate && [_delegate respondsToSelector:@selector(scrollViewDidScroll:)]) {
        if (_collectionView) {
            [_delegate scrollViewDidScroll:_collectionView];
        }
        if (_asCollectionView) {
            [_delegate scrollViewDidScroll:_asCollectionView.view];
        }
        
    }
    
    
    CGFloat currentOffsetY = scrollView.contentOffset.y;
    NSInteger currentScrollDirection = [self detectScrollDirection:currentOffsetY previousOffsetY:_previousOffsetY];
    CGFloat topBoundary = -scrollView.contentInset.top;
    CGFloat bottomBoundary = scrollView.contentSize.height + scrollView.contentInset.bottom;
    
    BOOL isOverTopBoundary = currentOffsetY <= topBoundary;
    BOOL isOverBottomBoundary = currentOffsetY >= bottomBoundary;
    
    BOOL isBouncing = (isOverTopBoundary && currentScrollDirection != TTSCollectionViewScrollDirectionDown) || (isOverBottomBoundary && currentScrollDirection != TTSCollectionViewScrollDirectionUp);
    if (isBouncing || !scrollView.isDragging) {
        return;
    }
    
    CGFloat deltaY = _previousOffsetY - currentOffsetY;
    _accumulatedY += deltaY;
    
    if (currentScrollDirection == TTSCollectionViewScrollDirectionUp) {
        BOOL isOverThreshold = _accumulatedY < -_upThresholdY;
        
        if (isOverThreshold || isOverBottomBoundary)  {
            if (_delegate && [_delegate respondsToSelector:@selector(scrollViewDidScrollUp:)]) {
                [_delegate scrollViewDidScrollUp:deltaY];
            }
        }
    }
    else if (currentScrollDirection == TTSCollectionViewScrollDirectionDown) {
        BOOL isOverThreshold = _accumulatedY > _downThresholdY;
        
        if (isOverThreshold || isOverTopBoundary) {
            if (_delegate && [_delegate respondsToSelector:@selector(scrollViewDidScrollDown:)]) {
                [_delegate scrollViewDidScrollDown:deltaY];
            }
        }
    }
    else {
        
    }
    
    
    // reset acuumulated y when move opposite direction
    if (!isOverTopBoundary && !isOverBottomBoundary && _previousScrollDirection != currentScrollDirection) {
        _accumulatedY = 0;
    }
    
    _previousScrollDirection = currentScrollDirection;
    _previousOffsetY = currentOffsetY;
    
    
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    
    CGFloat currentOffsetY = scrollView.contentOffset.y;
    
    CGFloat topBoundary = -scrollView.contentInset.top;
    CGFloat bottomBoundary = scrollView.contentSize.height + scrollView.contentInset.bottom;
    
    if (_previousScrollDirection == TTSCollectionViewScrollDirectionUp) {
        BOOL isOverThreshold = _accumulatedY < -_upThresholdY;
        BOOL isOverBottomBoundary = currentOffsetY >= bottomBoundary;
        
        if (isOverThreshold || isOverBottomBoundary) {
            if ([_delegate respondsToSelector:@selector(scrollFullScreenScrollViewDidEndDraggingScrollUp)]) {
                [_delegate scrollFullScreenScrollViewDidEndDraggingScrollUp];
            }
        }
    }
    else if (_previousScrollDirection == TTSCollectionViewScrollDirectionDown) {
        BOOL isOverThreshold = _accumulatedY > _downThresholdY;
        BOOL isOverTopBoundary = currentOffsetY <= topBoundary;
        
        if (isOverThreshold || isOverTopBoundary) {
            if ([_delegate respondsToSelector:@selector(scrollFullScreenScrollViewDidEndDraggingScrollDown)]) {
                [self setLastedId:@""];
                [_delegate scrollFullScreenScrollViewDidEndDraggingScrollDown];
            }
        }
        
    }
    else {
        
    }
}


- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView {
    BOOL ret = YES;
    if ([_delegate respondsToSelector:@selector(scrollFullScreenScrollViewDidEndDraggingScrollDown)]) {
        [_delegate scrollFullScreenScrollViewDidEndDraggingScrollDown];
    }
    return ret;
}



@end
