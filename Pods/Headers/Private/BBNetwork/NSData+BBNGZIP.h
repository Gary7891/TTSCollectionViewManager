//
//  NSData+CPNGZIP.h
//  CPNetWork
//
//  Created by Gary on 4/25/16.
//  Copyright © 2016 Gary. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const BBNzippaZlibErrorDomain;


@interface NSData (BBNGZIP)

- (NSData *)dataByGZipCompressingWithError:(NSError * __autoreleasing *)error;
- (NSData *)dataByGZipCompressingAtLevel:(int)level
                              windowSize:(int)windowBits
                             memoryLevel:(int)memLevel
                                strategy:(int)strategy
                                   error:(NSError * __autoreleasing *)error;
- (NSData *)dataByGZipDecompressingDataWithError:(NSError * __autoreleasing *)error;
- (NSData *)dataByGZipDecompressingDataWithWindowSize:(int)windowBits
                                                error:(NSError * __autoreleasing *)error;
@end
