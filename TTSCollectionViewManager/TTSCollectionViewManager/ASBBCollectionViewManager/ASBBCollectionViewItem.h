//
//  ASBBCollectionViewItem.h
//  ASBBCollectionViewManager
//
//  Created by Gary on 01/06/2017.
//  Copyright © 2017 czy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class ASBBCollectionViewSection;

@interface ASBBCollectionViewItem : NSObject



@property (nonatomic, weak) ASBBCollectionViewSection                *section;

@property (nonatomic, strong) UIColor *dividerColor;

@property (nonatomic, copy) void (^selectionHandler)(id item);

@property (nonatomic, copy) void (^insertionHandler)(id item);
@property (nonatomic, copy) void (^deletionHandler)(id item);
@property (nonatomic, copy) void (^deletionHandlerWithCompletion)(id item, void (^)(void));
@property (nonatomic, copy) BOOL (^moveHandler)(id item, NSIndexPath *sourceIndexPath, NSIndexPath *destinationIndexPath);
@property (nonatomic, copy) void (^moveCompletionHandler)(id item, NSIndexPath *sourceIndexPath, NSIndexPath *destinationIndexPath);
@property (nonatomic, copy) void (^cutHandler)(id item);
@property (nonatomic, copy) void (^copyHandler)(id item);
@property (nonatomic, copy) void (^pasteHandler)(id item);

/**
 cell的尺寸，在尺寸固定的时候可以在这指定
 */
@property (nonatomic,assign) CGSize          preferredSize;

+ (instancetype)item;

- (NSIndexPath *)indexPath;





///-----------------------------
/// @name Manipulating table view row
///-----------------------------

- (void)selectRowAnimated:(BOOL)animated;
- (void)selectRowAnimated:(BOOL)animated scrollPosition:(UICollectionViewScrollPosition)scrollPosition;
- (void)deselectRowAnimated:(BOOL)animated;
- (void)reloadRowWithAnimation;
- (void)deleteRowWithAnimation;


@end
