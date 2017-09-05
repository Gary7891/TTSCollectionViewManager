//
//  TTSCollectionViewDataSource.h
//  TTSCollectionViewManager
//
//  Created by Gary on 07/04/2017.
//  Copyright © 2017 czy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TTSCollectionViewManager.h"
#import "ASBBCollectionViewManager.h"


@class TTSCollectionViewDataManager;

typedef void (^btchCompletion) (BOOL finishded);

typedef NS_ENUM(NSInteger, TTSDataLoadPolicy) {
    /**
     *  第一次加载
     */
    TTSDataLoadPolicyFirstLoad = -1,
    /**
     *  正常加载
     */
    TTSDataLoadPolicyNone      = 0,
    /**
     *  加载下一页
     */
    TTSDataLoadPolicyMore      = 1,
    /**
     *  重新加载
     */
    TTSDataLoadPolicyReload    = 2,
    /**
     *  从缓存加载
     */
    TTSDataLoadPolicyCache     = 3,
};



typedef NS_ENUM(NSInteger, TTSCollectionViewScrollDirection) {
    TTSCollectionViewScrollDirectionNone  = 0,
    TTSCollectionViewScrollDirectionUp    = 1,
    TTSCollectionViewScrollDirectionDown  = 2,
    TTSCollectionViewScrollDirectionLeft  = 3,
    TTSCollectionViewScrollDirectionRight = 4,
};

@protocol TTSCollectionViewDataSourceDelegate <NSObject>

@required

- (void)actionOnView:(id)item actionType:(NSInteger)actionType;

- (void)actionItemClick:(id)item;

- (void)actionOnSupplementView:(id)item actionType:(NSInteger)actionType viewType:(SupplementaryViewType)viewType;

- (void)didStartLoad;

- (void)didFinishLoad:(TTSDataLoadPolicy)loadPolicy error:(NSError *)error;

- (void)didFinishLoad:(TTSDataLoadPolicy)loadPolicy object:(id)object error:(NSError *)error;

@optional
- (BOOL)showPullRefresh;

- (void)stopPullRefresh;

- (void)actionWithPullRefresh;

- (void)collectionViewExpandData:(id)expandData success:(BOOL)success;

- (void)scrollViewDidScroll:(UIScrollView *)scrollView;

- (void)scrollViewDidScrollUp:(CGFloat)deltaY;

- (void)scrollViewDidScrollDown:(CGFloat)deltaY;

- (void)scrollFullScreenScrollViewDidEndDraggingScrollUp;

- (void)scrollFullScreenScrollViewDidEndDraggingScrollDown;

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate;



@end

@interface TTSCollectionViewDataSource : NSObject

/**
 *  列表代理
 */
@property (nonatomic ,weak  ) id<TTSCollectionViewDataSourceDelegate> delegate;
/**
 *  collectionView
 */
@property (nonatomic ,weak  ) UICollectionView               *collectionView;

@property (nonatomic, weak  )ASCollectionNode                *asCollectionView;
/**
 *  collectionView 管理器
 */
@property (nonatomic ,strong) TTSCollectionViewManager            *manager;
@property (nonatomic, strong) ASBBCollectionViewManager           *asManager;

/**
 *  数据管理器
 */
@property (nonatomic ,strong) TTSCollectionViewDataManager      *collectionViewDataManager;

@property (nonatomic ,copy  ) NSString                      *lastedId;

/**
 *  参数字典
 */
@property (nonatomic ,strong) NSMutableDictionary           *params;
/**
 *  item的数量
 */
@property (nonatomic ,assign) NSInteger                     itemCount;
/**
 *  列表类型
 */
@property (nonatomic ,assign) NSInteger                     listType;
@property (nonatomic ,assign) BOOL                          useCacheData;
/**
 *  正在加载
 */
@property (nonatomic ,assign) BOOL                           loading;
/**
 *  网络数据加载完成
 */
@property (nonatomic ,assign) BOOL                           finished;
/**
 *  总页数
 */
@property (nonatomic ,assign) NSUInteger                     totalPage;
/**
 *  当前页码
 */
@property (nonatomic ,assign) NSUInteger                     currentPage;

/**
 *  @brief 当前pageSize
 */
@property (nonatomic, assign) NSInteger                      pageSize;

@property (nonatomic, strong) btchCompletion                 asBtchCompletionBlock;

- (id)initWithCollectionView:(UICollectionView *)collectionView
               listType:(NSInteger)listType
               delegate:(id /**<TTSCollectionViewDataSourceDelegate>*/)delegate;

- (id)initWithASCollectionView:(ASCollectionNode*)collectionView
                      listType:(NSInteger)listType
                      delegate:(id/**<TTSCollectionViewDataSourceDelegate>*/)delegate;
/**
 *  刷新列表数据
 *
 *  @param pullToRefresh 是否使用下拉刷新模式
 */
- (void)reloadCollectionViewData:(BOOL)pullToRefresh;
/**
 *  开始加载数据
 *
 *  @param pullToRefresh 是否下拉刷新
 *  @param params 请求参数
 */
- (void)startLoading:(BOOL)pullToRefresh params:(NSDictionary *)params;

/**
 *  停止加载
 */
- (void)stopLoading;

/**
 *  刷新指定Cell
 *
 *  @param actionType 事件类型
 *  @param dataId 数据Id
 */
- (void)refreshCell:(NSInteger)actionType dataId:(NSString *)dataId;


/**
 加载更多
 */
- (void)loadMore;

//返回item
- (id)collectionViewItemByIndexPath:(NSIndexPath *)indexPath;


/**
 *  添加下拉刷新组件，子类或者category可重写
 */
- (void)addPullRefresh;

/**
 开始下拉刷新
 */
- (void)startPullRefresh;
/**
 *  停止下拉刷新，子类或者category可重写
 */
- (void)stopPullRefresh;

/**
 添加上啦加载更多的View
 */
- (void)addLoadingMoreView;

/**
 停止上拉加载更多
 */
- (void)stopLoadMore;

- (void)setFooterViewState;

@end
