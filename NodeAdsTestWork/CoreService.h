//
//  CoreService.h
//  NodeAdsTestWork
//
//  Created by Oleh on 5/4/17.
//  Copyright © 2017 Oleh. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSUInteger const CoreServiceBatchSize;

@interface CoreService : NSObject

+ (CoreService *)sharedInstance;

- (void)userListForIdentifier:(NSString *)identifier withPageNumber:(NSUInteger)pageNumber completion:(void (^)(NSArray *userList, NSUInteger totalCount, NSError *error))completion;

@end
