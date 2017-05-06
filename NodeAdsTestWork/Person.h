//
//  Person.h
//  NodeAdsTestWork
//
//  Created by Oleh on 5/4/17.
//  Copyright © 2017 Oleh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Person : NSObject

@property (nonatomic, strong) NSString *id;
@property (nonatomic, strong) NSString *firstName;
@property (nonatomic, strong) NSString *lastName;
@property (nonatomic, strong) NSString *placeOfWork;
@property (nonatomic, strong) NSString *position;
@property (nonatomic, strong) NSString *linkPDF;
@property (nonatomic, strong) NSString *comment;
@property (nonatomic, assign) BOOL selected;

@end
