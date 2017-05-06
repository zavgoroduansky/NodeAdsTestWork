//
//  CoreService.m
//  NodeAdsTestWork
//
//  Created by Oleh on 5/4/17.
//  Copyright © 2017 Oleh. All rights reserved.
//

#import "CoreService.h"
#import "RemoteManager.h"
#import "Person.h"

NSUInteger const CoreServiceBatchSize = 20;

@interface CoreService ()

@property (nonatomic, strong) RemoteManager *remoteManager;

@end

@implementation CoreService

+ (CoreService *)sharedInstance {
    static dispatch_once_t onceToken;
    static CoreService *sharedInstance = nil;
    
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
        sharedInstance.remoteManager = [[RemoteManager alloc] init];
    });
    return sharedInstance;
}

#pragma mark - public methods

- (void)userListForIdentifier:(NSString *)identifier withPageNumber:(NSUInteger)pageNumber completion:(void (^)(NSArray *, NSUInteger, NSError *))completion {
    [self.remoteManager userListForIdentifier:identifier withPageNumber:pageNumber batchSize:CoreServiceBatchSize completion:^(NSArray *userList, NSUInteger totalCount, NSError *error) {
        if (completion) {
            NSMutableArray *tempArray = [NSMutableArray new];
            for (NSDictionary *element in userList) {
                Person *person = [[Person alloc] init];
                person.id = element[@"id"];
                person.firstName = element[@"firstname"];
                person.lastName = element[@"lastname"];
                person.placeOfWork = element[@"placeOfWork"];
                person.position = element[@"position"];
                person.linkPDF = element[@"linkPDF"];
                person.comment = @"";
                person.selected = NO;
                
                [tempArray addObject:person];
            }
            completion(tempArray, totalCount, error);
        }
    }];
}

@end
