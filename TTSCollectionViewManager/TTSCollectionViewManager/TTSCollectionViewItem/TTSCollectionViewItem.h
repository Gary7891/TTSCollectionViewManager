//
//  TTSCollectionViewItem.h
//  TTSCollectionViewManager
//
//  Created by Gary on 05/04/2017.
//  Copyright © 2017 czy. All rights reserved.
//

#import <Foundation/Foundation.h>


@class TTSCollectionViewSection;

@interface TTSCollectionViewItem : NSObject


@property (nonatomic, weak) TTSCollectionViewSection                *section;

@property (nonatomic, copy) void (^selectionHandler)(id item);

@property (nonatomic, copy) void (^insertionHandler)(id item);
@property (nonatomic, copy) void (^deletionHandler)(id item);
@property (nonatomic, copy) void (^deletionHandlerWithCompletion)(id item, void (^)(void));
@property (nonatomic, copy) BOOL (^moveHandler)(id item, NSIndexPath *sourceIndexPath, NSIndexPath *destinationIndexPath);
@property (nonatomic, copy) void (^moveCompletionHandler)(id item, NSIndexPath *sourceIndexPath, NSIndexPath *destinationIndexPath);
@property (nonatomic, copy) void (^cutHandler)(id item);
@property (nonatomic, copy) void (^copyHandler)(id item);
@property (nonatomic, copy) void (^pasteHandler)(id item);

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
