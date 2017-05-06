//
//  RemoteManager.m
//  NodeAdsTestWork
//
//  Created by Oleh on 5/4/17.
//  Copyright © 2017 Oleh. All rights reserved.
//

#import "RemoteManager.h"

static NSString *const RemoteManagerServerURL = @"https://public-api.nazk.gov.ua/v1/declaration?q=";

@interface RemoteManager ()

@property (nonatomic, strong) NSURLSession *session;

@end

@implementation RemoteManager

- (instancetype)init
{
    self = [super init];
    if (self) {
        NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
        [sessionConfiguration setTimeoutIntervalForRequest:5];
        
        _session = [NSURLSession sessionWithConfiguration:sessionConfiguration];
    }
    return self;
}

- (void)dealloc {
    _session = nil;
}

- (void)userListForIdentifier:(NSString *)identifier withPageNumber:(NSUInteger)pageNumber batchSize:(NSUInteger)batchSize completion:(void (^)(NSArray *, NSUInteger, NSError *))completion {
    [self sendRequestWithIdentifier:identifier pageNumber:pageNumber batchSize:batchSize completion:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (completion) {
            if (error) {
                completion(nil, 0, error);
            } else {
                NSError *error;
                NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
                if (!error) {
                    id message = result[@"message"];
                    if ([message isKindOfClass:[NSString class]]) {
                        NSError *error = [NSError errorWithDomain:@"Помилка" code:0 userInfo:@{NSLocalizedDescriptionKey : message}];
                        completion(nil, 0, error);
                    } else {
                        id items = result[@"items"];
                        if ([items isKindOfClass:[NSArray class]]) {
                            NSUInteger totalCount = [result[@"page"][@"totalItems"] integerValue];
                            completion((NSArray *)items, totalCount, nil);
                        }
                    }
                } else {
                    completion(nil, 0, error);
                }
            }
        }
    }];
}

#pragma mark - Private

- (void)sendRequestWithIdentifier:(NSString *)identifier pageNumber:(NSUInteger)pageNumber batchSize:(NSUInteger)batchSize completion:(void (^)(NSData *data, NSURLResponse *response, NSError *error)) completion {
    
    NSURLRequest *request = [self requestWithIdentifier:identifier pageNumber:pageNumber batchSize:batchSize];
    
    NSURLSessionDataTask *dataTask = [self.session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (completion) {
            completion(data, response, error);
        }
    }];
    
    [dataTask resume];
}

- (NSURLRequest *)requestWithIdentifier:(NSString *)identifier pageNumber:(NSUInteger)pageNumber batchSize:(NSUInteger)batchSize {
    NSString *urlString = [NSString stringWithFormat:@"%@%@&page=%li&batchSize=%li", RemoteManagerServerURL, [identifier stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet symbolCharacterSet]], pageNumber, batchSize];
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    request.HTTPMethod = @"GET";
    return request;
}

@end
