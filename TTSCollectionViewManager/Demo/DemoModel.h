//
//  DemoModel.h
//  TTSCollectionViewManager
//
//  Created by Gary on 10/04/2017.
//  Copyright © 2017 czy. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface DemoModel : JSONModel

@property (nonatomic, copy) NSString *path;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *price;

@property (nonatomic, copy) NSString *priceType;

@property (nonatomic, copy) NSString *id;

@end
