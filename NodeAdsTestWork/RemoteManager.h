//
//  RemoteManager.h
//  NodeAdsTestWork
//
//  Created by Oleh on 5/4/17.
//  Copyright © 2017 Oleh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RemoteManager : NSObject

- (void)userListForIdentifier:(NSString *)identifier withPageNumber:(NSUInteger)pageNumber batchSize:(NSUInteger)batchSize completion:(void (^)(NSArray *userList, NSUInteger totalCount, NSError *error))completion;

@end
