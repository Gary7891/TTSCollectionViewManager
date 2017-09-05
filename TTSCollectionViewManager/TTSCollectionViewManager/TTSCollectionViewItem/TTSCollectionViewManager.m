//
//  TTSCollectionViewManager.m
//  TTSCollectionViewManager
//
//  Created by Gary on 05/04/2017.
//  Copyright © 2017 czy. All rights reserved.
//

#import "TTSCollectionViewManager.h"


@interface TTSCollectionViewManager ()

@property (strong, readwrite, nonatomic) NSMutableDictionary *registeredXIBs;
@property (nonatomic, strong) NSMutableArray *mutableSections;
@property (nonatomic, assign) CGFloat defaultCollectionViewSectionHeight;
@property (atomic, assign) BOOL dataSourceLocked;

@end

@implementation TTSCollectionViewManager

-(instancetype)initWithCollectionView:(UICollectionView *)collectionView delegate:(id<TTSCollectionViewManagerDelegate>)delegate {
    self = [self initWithCollectionView:collectionView];
    if (!self)
        return nil;
    
    self.delegate = delegate;
    
    return self;
}

- (instancetype)initWithCollectionView:(UICollectionView *)collectionView {
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
    self[@"__NSCFConstantString"] = @"TTSCollectionViewItemCell";
    self[@"__NSCFString"] = @"TTSCollectionViewItemCell";
    self[@"NSString"] = @"TTSCollectionViewItemCell";
    self[@"TTSCollectionViewItem"] = @"TTSCollectionViewItemCell";
    
//    self[@"__NSCFConstantString"] = @"TTSCollectionReusableViewItemView";
//    self[@"__NSCFString"] = @"TTSCollectionReusableViewItemView";
//    self[@"NSString"] = @"TTSCollectionReusableViewItemView";
    self[@"TTSCollectionReusableViewItem"] = @"TTSCollectionReusableViewItemView";
}


- (void)registerClass:(NSString *)objectClass forCellWithReuseIdentifier:(NSString *)identifier {
    [self registerClass:objectClass forCellWithReuseIdentifier:identifier bundle:nil];
}

//- (void)registerClass:(NSString*)objectClass for

- (void)registerClass:(NSString *)objectClass forCellWithReuseIdentifier:(NSString *)identifier bundle:(NSBundle *)bundle
{
    NSAssert(NSClassFromString(objectClass), ([NSString stringWithFormat:@"Item class '%@' does not exist.", objectClass]));
    NSAssert(NSClassFromString(identifier), ([NSString stringWithFormat:@"Cell class '%@' does not exist.", identifier]));
    self.registeredClasses[(id <NSCopying>)NSClassFromString(objectClass)] = NSClassFromString(identifier);
    
    // Perform check if a XIB exists with the same name as the cell class
    //
    if (!bundle)
        bundle = [NSBundle mainBundle];
    
    if ([bundle pathForResource:identifier ofType:@"nib"]) {
        self.registeredXIBs[identifier] = objectClass;
        [self.collectionView registerNib:[UINib nibWithNibName:identifier bundle:bundle]  forCellWithReuseIdentifier:objectClass];
    }
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
    TTSCollectionViewSection *section = [self.mutableSections objectAtIndex:indexPath.section];
    NSObject *item = [section.items objectAtIndex:indexPath.row];
    return [self.registeredClasses objectForKey:item.class];
}

- (Class)classForSupplementaryHeaderAtSection:(NSInteger)section {
    TTSCollectionViewSection *viewSection = [self.mutableSections objectAtIndex:section];
    NSObject *item = viewSection.headerItem;
    return [self.registeredClasses objectForKey:item.class];
}

- (Class)classForSupplementaryFooterAtSection:(NSInteger)section {
    TTSCollectionViewSection *viewSection = [self.mutableSections objectAtIndex:section];
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
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (self.mutableSections.count <= section) {
        return 0;
    }
    TTSCollectionViewSection *tts_section = [self.mutableSections objectAtIndex:section];
    return tts_section.items.count;
}
//
// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TTSCollectionViewSection *section = [self.mutableSections objectAtIndex:indexPath.section];
    TTSCollectionViewItem *item = [section.items objectAtIndex:indexPath.row];
    NSString *cellIdentifier = [NSString stringWithFormat:@"TTSCollectionViewManager_%@iCell", [item class]];
    
    // NSLog(@"cellForItemAtIndexPath");
    
    Class cellClass = [self classForCellAtIndexPath:indexPath];
    // 注册xib，待实现
    if (self.registeredXIBs[NSStringFromClass(cellClass)]) {
        cellIdentifier = self.registeredXIBs[NSStringFromClass(cellClass)];
    }
    
    
    TTSCollectionViewItemCell *cell = (TTSCollectionViewItemCell*)[collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    
    void (^loadCell)(TTSCollectionViewItemCell *itemcell) = ^(TTSCollectionViewItemCell *itemcell) {
        itemcell.collectionViewManager = self;
        [itemcell cellDidLoad];
    };
    if (!cell) {
        cell = [[cellClass alloc]init];
        loadCell(cell);
    }
    if ([cell isKindOfClass:[TTSCollectionViewItemCell class]] && [cell respondsToSelector:@selector(loaded)] && !cell.loaded) {
        loadCell(cell);
    }
    
    cell.rowIndex = indexPath.row;
    cell.sectionIndex = indexPath.section;
    cell.item = item;
    
    
//    [cell cellWillAppear];
    
    return cell;
}




- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.mutableSections.count;
}

//// The view that is returned must be retrieved from a call to -dequeueReusableSupplementaryViewOfKind:withReuseIdentifier:forIndexPath:
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    

    TTSCollectionViewSection *section = [self.mutableSections objectAtIndex:indexPath.section];
    TTSCollectionReusableViewItem *item = nil;
    
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        item = section.headerItem;
    }else {
        item = section.footerItem;
    }
    if (!item) {
        return nil;
    }
    Class viewClass = item.class;
    NSString *viewIdentifier = [NSString stringWithFormat:@"TTSCollectionViewManager_%@iView", [item class]];
    
    
    TTSCollectionReusableViewItemView *view = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:viewIdentifier forIndexPath:indexPath];
    
    void (^loadView)(TTSCollectionReusableViewItemView *itemView) = ^(TTSCollectionReusableViewItemView *itemView) {
        itemView.collectionViewManager = self;
        [itemView viewDidLoad];
    };
    if (!view) {
        view = [[viewClass alloc]init];
        loadView(view);
    }
    if ([view isKindOfClass:[TTSCollectionReusableViewItemView class]] && [view respondsToSelector:@selector(loaded)] && !view.loaded) {
        loadView(view);
    }
    
    view.sectionIndex = indexPath.section;
    view.item = item;
    
    
//    [view viewWillAppear];
    
    
    return view;
}

#pragma mark - UICollectionViewDelegate
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section >= self.mutableSections.count) {
        return NO;
    }
    if ([self.delegate conformsToProtocol:@protocol(UICollectionViewDelegate)] && [self.delegate respondsToSelector:@selector(collectionView:shouldHighlightItemAtIndexPath:)]) {
        return [self.delegate collectionView:collectionView shouldHighlightItemAtIndexPath:indexPath];
    }
    return YES;
    
}
- (void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section >= self.mutableSections.count) {
        return ;
    }
    if ([self.delegate conformsToProtocol:@protocol(UICollectionViewDelegate)] && [self.delegate respondsToSelector:@selector(collectionView:didHighlightItemAtIndexPath:)]) {
        [self.delegate collectionView:collectionView didHighlightItemAtIndexPath:indexPath];
    }
}
- (void)collectionView:(UICollectionView *)collectionView didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section >= self.mutableSections.count) {
        return ;
    }
    if ([self.delegate conformsToProtocol:@protocol(UICollectionViewDelegate)] && [self.delegate respondsToSelector:@selector(collectionView:didUnhighlightItemAtIndexPath:)]) {
        [self.delegate collectionView:collectionView didUnhighlightItemAtIndexPath:indexPath];
    }
}
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section >= self.mutableSections.count) {
        return NO;
    }
    if ([self.delegate conformsToProtocol:@protocol(UICollectionViewDelegate)] && [self.delegate respondsToSelector:@selector(collectionView:shouldSelectItemAtIndexPath:)]) {
        return [self.delegate collectionView:collectionView shouldSelectItemAtIndexPath:indexPath];
    }
    
    return YES;
}
- (BOOL)collectionView:(UICollectionView *)collectionView shouldDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section >= self.mutableSections.count) {
        return NO;
    }
    if ([self.delegate conformsToProtocol:@protocol(UICollectionViewDelegate)] && [self.delegate respondsToSelector:@selector(collectionView:shouldDeselectItemAtIndexPath:)]) {
        return [self.delegate collectionView:collectionView shouldDeselectItemAtIndexPath:indexPath];
    }
    return YES;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    TTSCollectionViewSection *section = [self.mutableSections objectAtIndex:indexPath.section];
    id item = [section.items objectAtIndex:indexPath.row];
    if ([item respondsToSelector:@selector(setSelectionHandler:)]) {
        TTSCollectionViewItem *actionItem = (TTSCollectionViewItem*)item;
        if (actionItem.selectionHandler) {
            actionItem.selectionHandler(item);
        }
    }
    
    if ([self.delegate conformsToProtocol:@protocol(UICollectionViewDelegate)] && [self.delegate respondsToSelector:@selector(collectionView:didSelectItemAtIndexPath:)]) {
        [self.delegate collectionView:collectionView didSelectItemAtIndexPath:indexPath];
    }
    
    
}
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate conformsToProtocol:@protocol(UICollectionViewDelegate)] && [self.delegate respondsToSelector:@selector(collectionView:didDeselectItemAtIndexPath:)]) {
        [self.delegate collectionView:collectionView didDeselectItemAtIndexPath:indexPath];
    }
}
- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([cell isKindOfClass:[TTSCollectionViewItemCell class]]) {
        [(TTSCollectionViewItemCell*)cell cellDidDisappear];
    }
    
    if ([self.delegate conformsToProtocol:@protocol(UICollectionViewDelegate)] && [self.delegate respondsToSelector:@selector(collectionView:didEndDisplayingCell:forItemAtIndexPath:)]) {
        [self.delegate collectionView:collectionView didEndDisplayingCell:cell forItemAtIndexPath:indexPath];
    }
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([cell isKindOfClass:[TTSCollectionViewItemCell class]]) {
        [(TTSCollectionViewItemCell*)cell cellWillAppear];
    }
}


- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingSupplementaryView:(UICollectionReusableView *)view forElementOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath {
    
    if ([view isKindOfClass:[TTSCollectionReusableViewItemView class]]) {
        [(TTSCollectionReusableViewItemView*)view  viewDidDisappear];
    }
    
    if ([self.delegate conformsToProtocol:@protocol(UICollectionViewDelegate)] && [self.delegate respondsToSelector:@selector(collectionView:didEndDisplayingSupplementaryView:forElementOfKind:atIndexPath:)]) {
        [self.delegate collectionView:collectionView didEndDisplayingSupplementaryView:view forElementOfKind:elementKind atIndexPath:indexPath];
    }
}

- (void)collectionView:(UICollectionView *)collectionView willDisplaySupplementaryView:(UICollectionReusableView *)view forElementKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath {
    if ([view isKindOfClass:[TTSCollectionReusableViewItemView class]]) {
        [(TTSCollectionReusableViewItemView*)view  viewWillAppear];
    }
}

// These methods provide support for copy/paste actions on cells.
// All three should be implemented if any are.
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate conformsToProtocol:@protocol(UICollectionViewDelegate)] && [self.delegate respondsToSelector:@selector(collectionView:shouldShowMenuForItemAtIndexPath:)]) {
        return [self.delegate collectionView:collectionView shouldShowMenuForItemAtIndexPath:indexPath];
    }
    return NO;
}
- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(nullable id)sender {
    if ([self.delegate conformsToProtocol:@protocol(UICollectionViewDelegate)] && [self.delegate respondsToSelector:@selector(collectionView:canPerformAction:forItemAtIndexPath:withSender:)]) {
        return [self.delegate collectionView:collectionView canPerformAction:action forItemAtIndexPath:indexPath withSender:sender];
    }
    return NO;
}
- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(nullable id)sender {
    if ([self.delegate conformsToProtocol:@protocol(UICollectionViewDelegate)] && [self.delegate respondsToSelector:@selector(collectionView:canPerformAction:forItemAtIndexPath:withSender:)]) {
        [self.delegate collectionView:collectionView performAction:action forItemAtIndexPath:indexPath withSender:sender];
    }
}

// support for custom transition layout
- (UICollectionViewTransitionLayout *)collectionView:(UICollectionView *)collectionView transitionLayoutForOldLayout:(UICollectionViewLayout *)fromLayout newLayout:(UICollectionViewLayout *)toLayout {
    if ([self.delegate conformsToProtocol:@protocol(UICollectionViewDelegate)] && [self.delegate respondsToSelector:@selector(collectionView:transitionLayoutForOldLayout:newLayout:)]) {
        return [self.delegate collectionView:collectionView transitionLayoutForOldLayout:fromLayout newLayout:toLayout];
    }
    return nil;
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section >= self.mutableSections.count) {
        return CGSizeZero;
    }
    
    if ([self.delegate conformsToProtocol:@protocol(UICollectionViewDelegateFlowLayout)] && [self.delegate respondsToSelector:@selector(collectionView:layout:sizeForItemAtIndexPath:)]) {
        return [self.delegate collectionView:collectionView layout:collectionViewLayout sizeForItemAtIndexPath:indexPath];
    }
    TTSCollectionViewSection *section = [self.mutableSections objectAtIndex:indexPath.section];
    id item = [section.items objectAtIndex:indexPath.row];
    
    return [[self classForCellAtIndexPath:indexPath] sizeWithItem:item collectionManager:self];
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    if (section >= self.mutableSections.count) {
        return UIEdgeInsetsZero;
    }
    TTSCollectionViewSection *tts_section = [self.mutableSections objectAtIndex:section];
    return tts_section.sectionEdgeInsets;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    if (section >= self.mutableSections.count) {
        return 0.0f;
    }
    TTSCollectionViewSection *tts_section = [self.mutableSections objectAtIndex:section];
    return tts_section.minimumLineSpace;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    if (section >= self.mutableSections.count) {
        return 0.0f;
    }
    TTSCollectionViewSection *tts_section = [self.mutableSections objectAtIndex:section];
    return tts_section.minimumInteritemSpacing;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    if (section >= self.mutableSections.count) {
        return CGSizeZero;
    }
    
    TTSCollectionViewSection *ttsSection = [self.mutableSections objectAtIndex:section];
    
    if ([self.delegate conformsToProtocol:@protocol(UICollectionViewDelegateFlowLayout)] && [self.delegate respondsToSelector:@selector(collectionView:layout:referenceSizeForHeaderInSection:)]) {
        return [self.delegate collectionView:collectionView layout:collectionViewLayout referenceSizeForHeaderInSection:section];
    }
    
    id item = ttsSection.headerItem;
    if (!item) {
        return CGSizeZero;
    }
    
    return [[self classForSupplementaryHeaderAtSection:section] sizeWithItem:item collectionManager:self];

    
    
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    if (section >= self.mutableSections.count) {
        return CGSizeZero;
    }
    
    TTSCollectionViewSection *ttsSection = [self.mutableSections objectAtIndex:section];
    
    if ([self.delegate conformsToProtocol:@protocol(UICollectionViewDelegateFlowLayout)] && [self.delegate respondsToSelector:@selector(collectionView:layout:referenceSizeForFooterInSection:)]) {
        return [self.delegate collectionView:collectionView layout:collectionViewLayout referenceSizeForFooterInSection:section];
    }
    
    id item = ttsSection.footerItem;
    if (!item) {
        return CGSizeZero;
    }
    
    return [[self classForSupplementaryFooterAtSection:section] sizeWithItem:item collectionManager:self];
}

#pragma mark -
#pragma mark UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // Forward to UIScrollView delegate
    //
    if ([self.delegate conformsToProtocol:@protocol(UIScrollViewDelegate)] && [self.delegate respondsToSelector:@selector(scrollViewDidScroll:)])
        [self.delegate scrollViewDidScroll:self.collectionView];
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    // Forward to UIScrollView delegate
    //
    if ([self.delegate conformsToProtocol:@protocol(UIScrollViewDelegate)] && [self.delegate respondsToSelector:@selector(scrollViewDidZoom:)])
        [self.delegate scrollViewDidZoom:self.collectionView];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    // Forward to UIScrollView delegate
    //
    if ([self.delegate conformsToProtocol:@protocol(UIScrollViewDelegate)] && [self.delegate respondsToSelector:@selector(scrollViewWillBeginDragging:)])
        [self.delegate scrollViewWillBeginDragging:self.collectionView];
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    // Forward to UIScrollView delegate
    //
    if ([self.delegate conformsToProtocol:@protocol(UIScrollViewDelegate)] && [self.delegate respondsToSelector:@selector(scrollViewWillEndDragging:withVelocity:targetContentOffset:)])
        [self.delegate scrollViewWillEndDragging:self.collectionView withVelocity:velocity targetContentOffset:targetContentOffset];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    // Forward to UIScrollView delegate
    //
    if ([self.delegate conformsToProtocol:@protocol(UIScrollViewDelegate)] && [self.delegate respondsToSelector:@selector(scrollViewDidEndDragging:willDecelerate:)])
        [self.delegate scrollViewDidEndDragging:self.collectionView willDecelerate:decelerate];
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    // Forward to UIScrollView delegate
    //
    if ([self.delegate conformsToProtocol:@protocol(UIScrollViewDelegate)] && [self.delegate respondsToSelector:@selector(scrollViewWillBeginDecelerating:)])
        [self.delegate scrollViewWillBeginDecelerating:self.collectionView];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    // Forward to UIScrollView delegate
    //
    if ([self.delegate conformsToProtocol:@protocol(UIScrollViewDelegate)] && [self.delegate respondsToSelector:@selector(scrollViewDidEndDecelerating:)])
        [self.delegate scrollViewDidEndDecelerating:self.collectionView];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    // Forward to UIScrollView delegate
    //
    if ([self.delegate conformsToProtocol:@protocol(UIScrollViewDelegate)] && [self.delegate respondsToSelector:@selector(scrollViewDidEndScrollingAnimation:)])
        [self.delegate scrollViewDidEndScrollingAnimation:self.collectionView];
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    // Forward to UIScrollView delegate
    //
    if ([self.delegate conformsToProtocol:@protocol(UIScrollViewDelegate)] && [self.delegate respondsToSelector:@selector(viewForZoomingInScrollView:)])
        return [self.delegate viewForZoomingInScrollView:self.collectionView];
    
    return nil;
}

- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)view
{
    // Forward to UIScrollView delegate
    //
    if ([self.delegate conformsToProtocol:@protocol(UIScrollViewDelegate)] && [self.delegate respondsToSelector:@selector(scrollViewWillBeginZooming:withView:)])
        [self.delegate scrollViewWillBeginZooming:self.collectionView withView:view];
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale
{
    // Forward to UIScrollView delegate
    //
    if ([self.delegate conformsToProtocol:@protocol(UIScrollViewDelegate)] && [self.delegate respondsToSelector:@selector(scrollViewDidEndZooming:withView:atScale:)])
        [self.delegate scrollViewDidEndZooming:self.collectionView withView:view atScale:scale];
}

- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView
{
    // Forward to UIScrollView delegate
    //
    if ([self.delegate conformsToProtocol:@protocol(UIScrollViewDelegate)] && [self.delegate respondsToSelector:@selector(scrollViewShouldScrollToTop:)])
        return [self.delegate scrollViewShouldScrollToTop:self.collectionView];
    return YES;
}

- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView
{
    // Forward to UIScrollView delegate
    //
    if ([self.delegate conformsToProtocol:@protocol(UIScrollViewDelegate)] && [self.delegate respondsToSelector:@selector(scrollViewDidScrollToTop:)])
        [self.delegate scrollViewDidScrollToTop:self.collectionView];
}


#pragma mark -
#pragma mark Managing sections

- (void)addSection:(TTSCollectionViewSection *)section
{
//    ASDisplayNodeAssert(!self.dataSourceLocked, @"Could not update data source when it is locked !");
    section.collectionManager = self;
    [self.mutableSections addObject:section];
}

- (void)addSectionsFromArray:(NSArray *)array
{
    for (TTSCollectionViewSection *section in array)
        section.collectionManager = self;
    [self.mutableSections addObjectsFromArray:array];
}

- (void)insertSection:(TTSCollectionViewSection *)section atIndex:(NSUInteger)index
{
    section.collectionManager = self;
    [self.mutableSections insertObject:section atIndex:index];
}

- (void)insertSections:(NSArray *)sections atIndexes:(NSIndexSet *)indexes
{
    for (TTSCollectionViewSection *section in sections)
        section.collectionManager = self;
    [self.mutableSections insertObjects:sections atIndexes:indexes];
}

- (void)removeSection:(TTSCollectionViewSection *)section
{
    [self.mutableSections removeObject:section];
}

- (void)removeAllSections
{
    [self.mutableSections removeAllObjects];
}

- (void)removeSectionIdenticalTo:(TTSCollectionViewSection *)section inRange:(NSRange)range
{
    [self.mutableSections removeObjectIdenticalTo:section inRange:range];
}

- (void)removeSectionIdenticalTo:(TTSCollectionViewSection *)section
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

- (void)removeSection:(TTSCollectionViewSection *)section inRange:(NSRange)range
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

- (void)replaceSectionAtIndex:(NSUInteger)index withSection:(TTSCollectionViewSection *)section
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
    for (TTSCollectionViewSection *section in sections)
        section.collectionManager = self;
    [self.mutableSections replaceObjectsAtIndexes:indexes withObjects:sections];
}

- (void)replaceSectionsInRange:(NSRange)range withSectionsFromArray:(NSArray *)otherArray range:(NSRange)otherRange
{
    for (TTSCollectionViewSection *section in otherArray)
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
