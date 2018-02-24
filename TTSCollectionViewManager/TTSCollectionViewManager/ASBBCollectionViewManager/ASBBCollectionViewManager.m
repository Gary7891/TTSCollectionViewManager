//
//  ASBBCollectionViewManager.m
//  ASBBCollectionViewManager
//
//  Created by Gary on 01/06/2017.
//  Copyright © 2017 czy. All rights reserved.
//

#import "ASBBCollectionViewManager.h"

@interface ASBBCollectionViewManager ()

@property (strong, readwrite, nonatomic) NSMutableDictionary *registeredXIBs;
@property (nonatomic, strong) NSMutableArray *mutableSections;
@property (nonatomic, assign) CGFloat defaultCollectionViewSectionHeight;
@property (atomic, assign) BOOL dataSourceLocked;

@end

@implementation ASBBCollectionViewManager


- (instancetype)initWithCollectionView:(ASCollectionNode *)collectionView delegate:(id<ASBBCollectionViewManagerDelegate>)delegate {
    self = [self initWithCollectionView:collectionView];
    if (!self)
        return nil;
    
    self.delegate = delegate;
    
    return self;
}

- (instancetype)initWithCollectionView:(ASCollectionNode *)collectionView {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    collectionView.delegate = self;
    collectionView.dataSource = self;
    _collectionView = collectionView;
    _mutableSections = [[NSMutableArray alloc] init];
    _registeredClasses = [[NSMutableDictionary alloc] init];
    _registeredXIBs = [[NSMutableDictionary alloc]init];
    
    [self registerDefaultClasses];
    
    return self;
}

- (void)registerDefaultClasses
{
    self[@"__NSCFConstantString"] = @"ASBBCollectionViewItemCell";
    self[@"__NSCFString"] = @"ASBBCollectionViewItemCell";
    self[@"NSString"] = @"ASBBCollectionViewItemCell";
    self[@"ASBBCollectionViewItem"] = @"ASBBCollectionViewItemCell";
    
    //    self[@"__NSCFConstantString"] = @"ASBBCollectionReusableViewItemView";
    //    self[@"__NSCFString"] = @"ASBBCollectionReusableViewItemView";
    //    self[@"NSString"] = @"ASBBCollectionReusableViewItemView";
    self[@"ASBBCollectionReusableViewItem"] = @"ASBBCollectionReusableViewItemView";
}


- (void)registerClass:(NSString *)objectClass forCellWithReuseIdentifier:(NSString *)identifier {
    [self registerClass:objectClass forCellWithReuseIdentifier:identifier bundle:nil];
}

////- (void)registerClass:(NSString*)objectClass for
//
- (void)registerClass:(NSString *)objectClass forCellWithReuseIdentifier:(NSString *)identifier bundle:(NSBundle *)bundle
{
    NSAssert(NSClassFromString(objectClass), ([NSString stringWithFormat:@"Item class '%@' does not exist.", objectClass]));
    NSAssert(NSClassFromString(identifier), ([NSString stringWithFormat:@"Cell class '%@' does not exist.", identifier]));
    self.registeredClasses[(id <NSCopying>)NSClassFromString(objectClass)] = NSClassFromString(identifier);
    
    // Perform check if a XIB exists with the same name as the cell class
    //
//    if (!bundle)
//        bundle = [NSBundle mainBundle];
//    
//    if ([bundle pathForResource:identifier ofType:@"nib"]) {
//        self.registeredXIBs[identifier] = objectClass;
//        [self.collectionView registerNib:[UINib nibWithNibName:identifier bundle:bundle]  forCellWithReuseIdentifier:objectClass];
//    }
}

- (id)objectAtKeyedSubscript:(id <NSCopying>)key
{
    return [self.registeredClasses objectForKey:key];
}

- (void)setObject:(id)obj forKeyedSubscript:(id <NSCopying>)key
{
    [self registerClass:(NSString *)key forCellWithReuseIdentifier:obj];
}

- (Class)classForCellAtIndexPath:(NSIndexPath *)indexPath {
    ASBBCollectionViewSection *section = [self.mutableSections objectAtIndex:indexPath.section];
    NSObject *item = [section.items objectAtIndex:indexPath.row];
    return [self.registeredClasses objectForKey:item.class];
}

- (Class)classForSupplementaryHeaderAtSection:(NSInteger)section {
    if (section < 0) {
        return nil;
    }
    ASBBCollectionViewSection *viewSection = [self.mutableSections objectAtIndex:section];
    NSObject *item = viewSection.headerItem;
    return [self.registeredClasses objectForKey:item.class];
}

- (Class)classForSupplementaryFooterAtSection:(NSInteger)section {
    if (section < 0) {
        return nil;
    }
    ASBBCollectionViewSection *viewSection = [self.mutableSections objectAtIndex:section];
    NSObject *item = viewSection.footerItem;
    return [self.registeredClasses objectForKey:item.class];
}

- (NSArray *)sections
{
    return self.mutableSections;
}

- (CGFloat)defaultCollectionViewSectionHeight
{
    return 10;
}

#pragma mark - UICollectionDataSource

- (NSInteger)numberOfSectionsInCollectionNode:(ASCollectionNode *)collectionNode {
    return self.mutableSections.count;
}


- (NSInteger)collectionNode:(ASCollectionNode *)collectionNode numberOfItemsInSection:(NSInteger)section {
    if (self.mutableSections.count <= section) {
        return 0;
    }
    ASBBCollectionViewSection *asbb_section = [self.mutableSections objectAtIndex:section];
    return asbb_section.items.count;
}

- (ASCellNodeBlock)collectionNode:(ASCollectionNode *)collectionNode nodeBlockForItemAtIndexPath:(NSIndexPath *)indexPath {
    ASBBCollectionViewSection *section = [self.mutableSections objectAtIndex:indexPath.section];
    ASBBCollectionViewItem *item = [section.items objectAtIndex:indexPath.row];
    
    Class cellClass = [self classForCellAtIndexPath:indexPath];
    ASBBCollectionViewItemCell* (^cellblock)() = ^ASBBCollectionViewItemCell*(){
        ASBBCollectionViewItemCell *cell = [[cellClass alloc]initWithCollectionViewItem:item];
        
        cell.rowIndex = indexPath.row;
        cell.sectionIndex = indexPath.section;
        
        return cell;
    };
    return cellblock;

}

//- (ASCellNode*)collectionView:(ASCollectionView *)collectionView nodeForItemAtIndexPath:(NSIndexPath *)indexPath {
//    
//    ASBBCollectionViewSection *section = [self.mutableSections objectAtIndex:indexPath.section];
//    ASBBCollectionViewItem *item = [section.items objectAtIndex:indexPath.row];
//    
//    Class cellClass = [self classForCellAtIndexPath:indexPath];
//    ASBBCollectionViewItemCell* (^cellblock)() = ^ASBBCollectionViewItemCell*(){
//        
//    };
//    ASBBCollectionViewItemCell *cell = [[cellClass alloc]initWithCollectionViewItem:item];
//    
//    cell.rowIndex = indexPath.row;
//    cell.sectionIndex = indexPath.section;
//    
//    return cell;
//    
//}


- (ASCellNode*)collectionNode:(ASCollectionNode *)collectionNode nodeForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    ASBBCollectionViewSection *section = [self.mutableSections objectAtIndex:indexPath.section];
    ASBBCollectionReusableViewItem *item = nil;
    
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        item = section.headerItem;
    }else {
        item = section.footerItem;
    }
    if (!item) {
        return nil;
    }
    Class viewClass = nil;
    if([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        viewClass =  [self classForSupplementaryHeaderAtSection:indexPath.section];
    }else {
        viewClass = [self classForSupplementaryFooterAtSection:indexPath.section];
    }
    
    ASBBCollectionReusableViewItemView *view = [[viewClass alloc] initWithCollectionViewItem:item];
    
    view.sectionIndex = indexPath.section;
    view.item = item;
    
    
    return view;
}

//- (ASBBCollectionReusableViewItemView *)collectionView:(ASCollectionNode *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
//    
//    
//    ASBBCollectionViewSection *section = [self.mutableSections objectAtIndex:indexPath.section];
//    ASBBCollectionReusableViewItem *item = nil;
//    
//    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
//        item = section.headerItem;
//    }else {
//        item = section.footerItem;
//    }
//    if (!item) {
//        return nil;
//    }
//    Class viewClass = item.class;
//    ASBBCollectionReusableViewItemView *view = [[viewClass alloc] initWithCollectionViewItem:item];
//    
//    view.sectionIndex = indexPath.section;
//    view.item = item;
//    
//    
//    return view;
//}

/**
 * Indicator to lock the data source for data fetching in async mode.
 * We should not update the data source until the data source has been unlocked. Otherwise, it will incur data inconsistency or exception
 * due to the data access in async mode.
 *
 * @param collectionView The sender.
 */
- (void)collectionViewLockDataSource:(ASCollectionView *)collectionView {
    self.dataSourceLocked = YES;
}

/**
 * Indicator to unlock the data source for data fetching in async mode.
 * We should not update the data source until the data source has been unlocked. Otherwise, it will incur data inconsistency or exception
 * due to the data access in async mode.
 *
 * @param collectionView The sender.
 */
- (void)collectionViewUnlockDataSource:(ASCollectionView *)collectionView {
    self.dataSourceLocked = NO;
}

- (ASSizeRange)collectionNode:(ASCollectionNode *)collectionNode constrainedSizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section >= self.mutableSections.count) {
        return ASSizeRangeMake(CGSizeZero) ;
    }
    
    if ([self.delegate conformsToProtocol:@protocol(ASCollectionDelegate)] && [self.delegate respondsToSelector:@selector(collectionNode:constrainedSizeForItemAtIndexPath:)]) {
        return [self.delegate collectionNode:collectionNode constrainedSizeForItemAtIndexPath:indexPath];
    }
    ASBBCollectionViewSection *section = [self.mutableSections objectAtIndex:indexPath.section];
    ASBBCollectionViewItem *item = [section.items objectAtIndex:indexPath.row];
    CGSize size = item.preferredSize;
    if (!CGSizeEqualToSize(size, CGSizeZero)) {
        return ASSizeRangeMake(size);
    }
    
//    Class class = [self classForCellAtIndexPath:indexPath];
//    if ([class respondsToSelector:@selector(sizeWithItem:collectionManager:)]) {
//        return ASSizeRangeMake([[self classForCellAtIndexPath:indexPath] sizeWithItem:item collectionManager:self]);
//    }
    
    return ASSizeRangeUnconstrained;
}

#pragma mark - 
#pragma mark ASCollectionViewDelegate


- (BOOL)shouldBatchFetchForCollectionNode:(ASCollectionNode *)collectionNode {
    if ([self.delegate respondsToSelector:@selector(shouldBatchFetchForCollectionNode:)]) {
        return [self.delegate shouldBatchFetchForCollectionNode:collectionNode];
    }
    return NO;
}

- (void)collectionNode:(ASCollectionNode *)collectionNode willBeginBatchFetchWithContext:(ASBatchContext *)context {
    if ([self.delegate respondsToSelector:@selector(collectionNode:willBeginBatchFetchWithContext:)]) {
        [self.delegate collectionNode:collectionNode willBeginBatchFetchWithContext:context];
    }
}

- (BOOL)collectionNode:(ASCollectionNode *)collectionNode shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section >= self.mutableSections.count) {
        return NO;
    }
    if ([self.delegate conformsToProtocol:@protocol(UICollectionViewDelegate)] && [self.delegate respondsToSelector:@selector(collectionNode:shouldHighlightItemAtIndexPath:)]) {
        return [self.delegate collectionNode:collectionNode shouldHighlightItemAtIndexPath:indexPath];
    }
    return YES;
}

- (void)collectionNode:(ASCollectionNode *)collectionNode didHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section >= self.mutableSections.count) {
        return ;
    }
    if ([self.delegate conformsToProtocol:@protocol(UICollectionViewDelegate)] && [self.delegate respondsToSelector:@selector(collectionNode:didHighlightItemAtIndexPath:)]) {
        [self.delegate collectionNode:collectionNode didHighlightItemAtIndexPath:indexPath];
    }
}

- (void)collectionNode:(ASCollectionNode *)collectionNode didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section >= self.mutableSections.count) {
        return ;
    }
    if ([self.delegate conformsToProtocol:@protocol(UICollectionViewDelegate)] && [self.delegate respondsToSelector:@selector(collectionNode:didUnhighlightItemAtIndexPath:)]) {
        [self.delegate collectionNode:collectionNode didUnhighlightItemAtIndexPath:indexPath];
    }
}

- (BOOL)collectionNode:(ASCollectionNode *)collectionNode shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section >= self.mutableSections.count) {
        return NO;
    }
    if ([self.delegate conformsToProtocol:@protocol(UICollectionViewDelegate)] && [self.delegate respondsToSelector:@selector(collectionNode:shouldSelectItemAtIndexPath:)]) {
        return [self.delegate collectionNode:collectionNode shouldSelectItemAtIndexPath:indexPath];
    }
    
    return YES;
}


- (BOOL)collectionNode:(ASCollectionNode *)collectionNode shouldDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section >= self.mutableSections.count) {
        return NO;
    }
    if ([self.delegate conformsToProtocol:@protocol(UICollectionViewDelegate)] && [self.delegate respondsToSelector:@selector(collectionNode:shouldDeselectItemAtIndexPath:)]) {
        return [self.delegate collectionNode:collectionNode shouldDeselectItemAtIndexPath:indexPath];
    }
    return YES;
}

- (void)collectionNode:(ASCollectionNode *)collectionNode didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section >= self.mutableSections.count) {
        return;
    }
    ASBBCollectionViewSection *section = [self.mutableSections objectAtIndex:indexPath.section];
    if (indexPath.row >= section.items.count) {
        return;
    }
    id item = [section.items objectAtIndex:indexPath.row];
    if ([item respondsToSelector:@selector(setSelectionHandler:)]) {
        ASBBCollectionViewItem *actionItem = (ASBBCollectionViewItem*)item;
        if (actionItem.selectionHandler) {
            actionItem.selectionHandler(item);
        }
    }
    
    if ([self.delegate conformsToProtocol:@protocol(UICollectionViewDelegate)] && [self.delegate respondsToSelector:@selector(collectionNode:didSelectItemAtIndexPath:)]) {
        [self.delegate collectionNode:collectionNode didSelectItemAtIndexPath:indexPath];
    }
}

- (void)collectionNode:(ASCollectionNode *)collectionNode didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate conformsToProtocol:@protocol(UICollectionViewDelegate)] && [self.delegate respondsToSelector:@selector(collectionNode:didDeselectItemAtIndexPath:)]) {
        [self.delegate collectionNode:collectionNode didDeselectItemAtIndexPath:indexPath];
    }
}

- (void)collectionNode:(ASCollectionNode *)collectionNode willDisplayItemWithNode:(ASCellNode *)node {
    if ([self.delegate respondsToSelector:@selector(collectionNode:willDisplayItemWithNode:)]) {
        [self.delegate collectionNode:collectionNode willDisplayItemWithNode:node];
    }
}


- (void)collectionNode:(ASCollectionNode *)collectionNode didEndDisplayingItemWithNode:(ASCellNode *)node {
    if ([self.delegate respondsToSelector:@selector(collectionNode:didEndDisplayingItemWithNode:)]) {
        [self.delegate collectionNode:collectionNode didEndDisplayingItemWithNode:node];
    }
}




- (ASSizeRange)collectionNode:(ASCollectionNode *)collectionNode sizeRangeForHeaderInSection:(NSInteger)section
{
    if (section >= self.mutableSections.count) {
        return ASSizeRangeMake(CGSizeZero);
    }
    
    ASBBCollectionViewSection *ASBBSection = [self.mutableSections objectAtIndex:section];
    
    if ([self.delegate conformsToProtocol:@protocol(UICollectionViewDelegateFlowLayout)] && [self.delegate respondsToSelector:@selector(collectionNode:sizeRangeForHeaderInSection:)]) {
        return [self.delegate collectionNode:collectionNode sizeRangeForHeaderInSection:section];
    }
    
    id item = ASBBSection.headerItem;
    if (!item) {
        return ASSizeRangeMake(CGSizeZero);
    }
    
//    return ASSizeRangeMake([[self classForSupplementaryHeaderAtSection:section] sizeWithItem:item collectionManager:self]);
    return ASSizeRangeUnconstrained;
}

- (ASSizeRange)collectionNode:(ASCollectionNode *)collectionNode sizeRangeForFooterInSection:(NSInteger)section
{
    
    if (section >= self.mutableSections.count) {
        return ASSizeRangeMake(CGSizeZero);
    }
    
    ASBBCollectionViewSection *ASBBSection = [self.mutableSections objectAtIndex:section];
    
    if ([self.delegate conformsToProtocol:@protocol(UICollectionViewDelegateFlowLayout)] && [self.delegate respondsToSelector:@selector(collectionNode:sizeRangeForFooterInSection:)]) {
        return [self.delegate collectionNode:collectionNode sizeRangeForFooterInSection:section];
    }
    
    id item = ASBBSection.footerItem;
    if (!item) {
        return ASSizeRangeMake(CGSizeZero);
    }
    
//    return ASSizeRangeMake([[self classForSupplementaryFooterAtSection:section] sizeWithItem:item collectionManager:self]);
    return ASSizeRangeUnconstrained;
    
}

/**
 * @discussion This method is deprecated and does nothing from 1.9.7 and up
 * Previously it applies the section inset to every cells within the corresponding section.
 * The expected behavior is to apply the section inset to the whole section rather than
 * shrinking each cell individually.
 * If you want this behavior, you can integrate your insets calculation into
 * `constrainedSizeForNodeAtIndexPath`
 * please file a github issue if you would like this to be restored.
 */
- (UIEdgeInsets)collectionView:(ASCollectionNode *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    if (section >= self.mutableSections.count) {
        return UIEdgeInsetsZero;
    }
    ASBBCollectionViewSection *asbb_section = [self.mutableSections objectAtIndex:section];
    return asbb_section.sectionEdgeInsets;
}

/**
 * Asks the delegate for the size of the header in the specified section.
 */
//- (CGSize)collectionView:(ASCollectionNode *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
//    if (section >= self.mutableSections.count) {
//        return CGSizeZero;
//    }
//    
//    ASBBCollectionViewSection *ASBBSection = [self.mutableSections objectAtIndex:section];
//    
//    if ([self.delegate conformsToProtocol:@protocol(UICollectionViewDelegateFlowLayout)] && [self.delegate respondsToSelector:@selector(collectionView:layout:referenceSizeForHeaderInSection:)]) {
//        return [self.delegate collectionView:collectionView layout:collectionViewLayout referenceSizeForHeaderInSection:section];
//    }
//    
//    id item = ASBBSection.headerItem;
//    if (!item) {
//        return CGSizeZero;
//    }
//    
//    return [[self classForSupplementaryHeaderAtSection:section] sizeWithItem:item collectionManager:self];
//}



/**
 * Asks the delegate for the size of the footer in the specified section.
 */
//- (CGSize)collectionView:(ASCollectionNode *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
//    if (section >= self.mutableSections.count) {
//        return CGSizeZero;
//    }
//    
//    ASBBCollectionViewSection *ASBBSection = [self.mutableSections objectAtIndex:section];
//    
//    if ([self.delegate conformsToProtocol:@protocol(UICollectionViewDelegateFlowLayout)] && [self.delegate respondsToSelector:@selector(collectionView:layout:referenceSizeForFooterInSection:)]) {
//        return [self.delegate collectionView:collectionView layout:collectionViewLayout referenceSizeForFooterInSection:section];
//    }
//    
//    id item = ASBBSection.footerItem;
//    if (!item) {
//        return CGSizeZero;
//    }
//    
//    return [[self classForSupplementaryFooterAtSection:section] sizeWithItem:item collectionManager:self];
//
//}

//- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
//    if ([self.delegate conformsToProtocol:@protocol(UICollectionViewDelegate)] && [self.delegate respondsToSelector:@selector(collectionView:shouldShowMenuForItemAtIndexPath:)]) {
//        return [self.delegate collectionView:collectionView shouldShowMenuForItemAtIndexPath:indexPath];
//    }
//    return NO;
//}

- (BOOL)collectionNode:(ASCollectionNode *)collectionNode shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate conformsToProtocol:@protocol(UICollectionViewDelegate)] && [self.delegate respondsToSelector:@selector(collectionNode:shouldShowMenuForItemAtIndexPath:)]) {
        return [self.delegate collectionNode:collectionNode shouldShowMenuForItemAtIndexPath:indexPath];
    }
    return NO;
}
//- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(nullable id)sender {
//    if ([self.delegate conformsToProtocol:@protocol(UICollectionViewDelegate)] && [self.delegate respondsToSelector:@selector(collectionView:canPerformAction:forItemAtIndexPath:withSender:)]) {
//        return [self.delegate collectionView:collectionView canPerformAction:action forItemAtIndexPath:indexPath withSender:sender];
//    }
//    return NO;
//}

- (BOOL)collectionNode:(ASCollectionNode *)collectionNode canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath sender:(id)sender {
    if ([self.delegate conformsToProtocol:@protocol(UICollectionViewDelegate)] && [self.delegate respondsToSelector:@selector(collectionNode:canPerformAction:forItemAtIndexPath:sender:)]) {
        return [self.delegate collectionNode:collectionNode canPerformAction:action forItemAtIndexPath:indexPath sender:sender];
    }
    return NO;
}
//- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(nullable id)sender {
//    if ([self.delegate conformsToProtocol:@protocol(UICollectionViewDelegate)] && [self.delegate respondsToSelector:@selector(collectionView:canPerformAction:forItemAtIndexPath:withSender:)]) {
//        [self.delegate collectionView:collectionView performAction:action forItemAtIndexPath:indexPath withSender:sender];
//    }
//}

- (void)collectionNode:(ASCollectionNode *)collectionNode performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath sender:(id)sender {
    if ([self.delegate conformsToProtocol:@protocol(UICollectionViewDelegate)] && [self.delegate respondsToSelector:@selector(collectionNode:performAction:forItemAtIndexPath:sender:)]) {
        [self.delegate collectionNode:collectionNode performAction:action forItemAtIndexPath:indexPath sender:sender];
    }
}

// support for custom transition layout
- (UICollectionViewTransitionLayout *)collectionView:(UICollectionView *)collectionView transitionLayoutForOldLayout:(UICollectionViewLayout *)fromLayout newLayout:(UICollectionViewLayout *)toLayout {
    if ([self.delegate conformsToProtocol:@protocol(UICollectionViewDelegate)] && [self.delegate respondsToSelector:@selector(collectionView:transitionLayoutForOldLayout:newLayout:)]) {
        return [self.delegate collectionView:collectionView transitionLayoutForOldLayout:fromLayout newLayout:toLayout];
    }
    return nil;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    if (section >= self.mutableSections.count) {
        return 0.0f;
    }
    ASBBCollectionViewSection *asbb_section = [self.mutableSections objectAtIndex:section];
    return asbb_section.minimumLineSpace;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    if (section >= self.mutableSections.count) {
        return 0.0f;
    }
    ASBBCollectionViewSection *asbb_section = [self.mutableSections objectAtIndex:section];
    return asbb_section.minimumInteritemSpacing;
}

#pragma mark -
#pragma mark UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // Forward to UIScrollView delegate
    //
    if ([self.delegate conformsToProtocol:@protocol(UIScrollViewDelegate)] && [self.delegate respondsToSelector:@selector(scrollViewDidScroll:)])
        [self.delegate scrollViewDidScroll:self.collectionView.view];
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    // Forward to UIScrollView delegate
    //
    if ([self.delegate conformsToProtocol:@protocol(UIScrollViewDelegate)] && [self.delegate respondsToSelector:@selector(scrollViewDidZoom:)])
        [self.delegate scrollViewDidZoom:self.collectionView.view];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    // Forward to UIScrollView delegate
    //
    if ([self.delegate conformsToProtocol:@protocol(UIScrollViewDelegate)] && [self.delegate respondsToSelector:@selector(scrollViewWillBeginDragging:)])
        [self.delegate scrollViewWillBeginDragging:self.collectionView.view];
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    // Forward to UIScrollView delegate
    //
    if ([self.delegate conformsToProtocol:@protocol(UIScrollViewDelegate)] && [self.delegate respondsToSelector:@selector(scrollViewWillEndDragging:withVelocity:targetContentOffset:)])
        [self.delegate scrollViewWillEndDragging:self.collectionView.view withVelocity:velocity targetContentOffset:targetContentOffset];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    // Forward to UIScrollView delegate
    //
    if ([self.delegate conformsToProtocol:@protocol(UIScrollViewDelegate)] && [self.delegate respondsToSelector:@selector(scrollViewDidEndDragging:willDecelerate:)])
        [self.delegate scrollViewDidEndDragging:self.collectionView.view willDecelerate:decelerate];
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    // Forward to UIScrollView delegate
    //
    if ([self.delegate conformsToProtocol:@protocol(UIScrollViewDelegate)] && [self.delegate respondsToSelector:@selector(scrollViewWillBeginDecelerating:)])
        [self.delegate scrollViewWillBeginDecelerating:self.collectionView.view];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    // Forward to UIScrollView delegate
    //
    if ([self.delegate conformsToProtocol:@protocol(UIScrollViewDelegate)] && [self.delegate respondsToSelector:@selector(scrollViewDidEndDecelerating:)])
        [self.delegate scrollViewDidEndDecelerating:self.collectionView.view];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    // Forward to UIScrollView delegate
    //
    if ([self.delegate conformsToProtocol:@protocol(UIScrollViewDelegate)] && [self.delegate respondsToSelector:@selector(scrollViewDidEndScrollingAnimation:)])
        [self.delegate scrollViewDidEndScrollingAnimation:self.collectionView.view];
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    // Forward to UIScrollView delegate
    //
    if ([self.delegate conformsToProtocol:@protocol(UIScrollViewDelegate)] && [self.delegate respondsToSelector:@selector(viewForZoomingInScrollView:)])
        return [self.delegate viewForZoomingInScrollView:self.collectionView.view];
    
    return nil;
}

- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)view
{
    // Forward to UIScrollView delegate
    //
    if ([self.delegate conformsToProtocol:@protocol(UIScrollViewDelegate)] && [self.delegate respondsToSelector:@selector(scrollViewWillBeginZooming:withView:)])
        [self.delegate scrollViewWillBeginZooming:self.collectionView.view withView:view];
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale
{
    // Forward to UIScrollView delegate
    //
    if ([self.delegate conformsToProtocol:@protocol(UIScrollViewDelegate)] && [self.delegate respondsToSelector:@selector(scrollViewDidEndZooming:withView:atScale:)])
        [self.delegate scrollViewDidEndZooming:self.collectionView.view withView:view atScale:scale];
}

- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView
{
    // Forward to UIScrollView delegate
    //
    if ([self.delegate conformsToProtocol:@protocol(UIScrollViewDelegate)] && [self.delegate respondsToSelector:@selector(scrollViewShouldScrollToTop:)])
        return [self.delegate scrollViewShouldScrollToTop:self.collectionView.view];
    return YES;
}

- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView
{
    // Forward to UIScrollView delegate
    //
    if ([self.delegate conformsToProtocol:@protocol(UIScrollViewDelegate)] && [self.delegate respondsToSelector:@selector(scrollViewDidScrollToTop:)])
        [self.delegate scrollViewDidScrollToTop:self.collectionView.view];
}

#pragma mark -
#pragma mark Managing sections

- (void)addSection:(ASBBCollectionViewSection *)section
{
    ASDisplayNodeAssert(!self.dataSourceLocked, @"Could not update data source when it is locked !");
    section.collectionManager = self;
    [self.mutableSections addObject:section];
}

- (void)addSectionsFromArray:(NSArray *)array
{
    for (ASBBCollectionViewSection *section in array)
        section.collectionManager = self;
    [self.mutableSections addObjectsFromArray:array];
}

- (void)insertSection:(ASBBCollectionViewSection *)section atIndex:(NSUInteger)index
{
    section.collectionManager = self;
    [self.mutableSections insertObject:section atIndex:index];
}

- (void)insertSections:(NSArray *)sections atIndexes:(NSIndexSet *)indexes
{
    for (ASBBCollectionViewSection *section in sections)
        section.collectionManager = self;
    [self.mutableSections insertObjects:sections atIndexes:indexes];
}

- (void)removeSection:(ASBBCollectionViewSection *)section
{
    [self.mutableSections removeObject:section];
}

- (void)removeAllSections
{
    [self.mutableSections removeAllObjects];
}

- (void)removeSectionIdenticalTo:(ASBBCollectionViewSection *)section inRange:(NSRange)range
{
    [self.mutableSections removeObjectIdenticalTo:section inRange:range];
}

- (void)removeSectionIdenticalTo:(ASBBCollectionViewSection *)section
{
    [self.mutableSections removeObjectIdenticalTo:section];
}

- (void)removeSectionsInArray:(NSArray *)otherArray
{
    [self.mutableSections removeObjectsInArray:otherArray];
}

- (void)removeSectionsInRange:(NSRange)range
{
    [self.mutableSections removeObjectsInRange:range];
}

- (void)removeSection:(ASBBCollectionViewSection *)section inRange:(NSRange)range
{
    [self.mutableSections removeObject:section inRange:range];
}

- (void)removeLastSection
{
    [self.mutableSections removeLastObject];
}

- (void)removeSectionAtIndex:(NSUInteger)index
{
    [self.mutableSections removeObjectAtIndex:index];
}

- (void)removeSectionsAtIndexes:(NSIndexSet *)indexes
{
    [self.mutableSections removeObjectsAtIndexes:indexes];
}

- (void)replaceSectionAtIndex:(NSUInteger)index withSection:(ASBBCollectionViewSection *)section
{
    section.collectionManager = self;
    [self.mutableSections replaceObjectAtIndex:index withObject:section];
}

- (void)replaceSectionsWithSectionsFromArray:(NSArray *)otherArray
{
    [self removeAllSections];
    [self addSectionsFromArray:otherArray];
}

- (void)replaceSectionsAtIndexes:(NSIndexSet *)indexes withSections:(NSArray *)sections
{
    for (ASBBCollectionViewSection *section in sections)
        section.collectionManager = self;
    [self.mutableSections replaceObjectsAtIndexes:indexes withObjects:sections];
}

- (void)replaceSectionsInRange:(NSRange)range withSectionsFromArray:(NSArray *)otherArray range:(NSRange)otherRange
{
    for (ASBBCollectionViewSection *section in otherArray)
        section.collectionManager = self;
    [self.mutableSections replaceObjectsInRange:range withObjectsFromArray:otherArray range:otherRange];
}

- (void)replaceSectionsInRange:(NSRange)range withSectionsFromArray:(NSArray *)otherArray
{
    [self.mutableSections replaceObjectsInRange:range withObjectsFromArray:otherArray];
}

- (void)exchangeSectionAtIndex:(NSUInteger)idx1 withSectionAtIndex:(NSUInteger)idx2
{
    [self.mutableSections exchangeObjectAtIndex:idx1 withObjectAtIndex:idx2];
}

- (void)sortSectionsUsingFunction:(NSInteger (*)(id, id, void *))compare context:(void *)context
{
    [self.mutableSections sortUsingFunction:compare context:context];
}

- (void)sortSectionsUsingSelector:(SEL)comparator
{
    [self.mutableSections sortUsingSelector:comparator];
}


@end
