//
//  MainTableViewCell.h
//  NodeAdsTestWork
//
//  Created by Oleh on 5/4/17.
//  Copyright © 2017 Oleh. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, MainTableViewCellType) {
    MainTableViewCellTypeSelected = 0,
    MainTableViewCellTypeAll
};

@class MainTableViewCell;

@protocol MainTableViewCellDelegate <NSObject>

@optional
- (void)editCommentButtonPressed:(MainTableViewCell *)cell;
- (void)declarationButtonPressed:(MainTableViewCell *)cell;
- (void)selectedButtonPressed:(MainTableViewCell *)cell;

@end

@interface MainTableViewCell : UITableViewCell

@property (nonatomic, weak) id<MainTableViewCellDelegate> delegate;
@property (assign, nonatomic) MainTableViewCellType cellType;
@property (assign, nonatomic) BOOL selectedCell;
@property (weak, nonatomic) IBOutlet UILabel *mainLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel1;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel2;
@property (weak, nonatomic) IBOutlet UIButton *declarationButton;


@end

