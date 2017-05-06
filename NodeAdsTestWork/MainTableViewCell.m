//
//  MainTableViewCell.m
//  NodeAdsTestWork
//
//  Created by Oleh on 5/4/17.
//  Copyright © 2017 Oleh. All rights reserved.
//

#import "MainTableViewCell.h"

static CGFloat const EditViewNormalWidth = 40.0;

@interface MainTableViewCell ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *editViewWidth;
@property (weak, nonatomic) IBOutlet UIButton *selectedButton;
@property (weak, nonatomic) IBOutlet UIButton *editButton;

- (IBAction)editCommentButtonAction:(id)sender;
- (IBAction)declarationButtonAction:(id)sender;
- (IBAction)selectedButtonAction:(id)sender;

@end

@implementation MainTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - setters

- (void)setCellType:(MainTableViewCellType)cellType {
    _cellType = cellType;
    if (cellType == MainTableViewCellTypeSelected) {
        self.editViewWidth.constant = EditViewNormalWidth;
        [self.editButton setImage:[UIImage imageNamed:@"edit_icon"] forState:UIControlStateNormal];
    } else if (cellType == MainTableViewCellTypeAll) {
        self.editViewWidth.constant = 0;
        [self.editButton setImage:nil forState:UIControlStateNormal];
    }
}

- (void)setSelectedCell:(BOOL)selectedCell {
    _selectedCell = selectedCell;
    if (selectedCell) {
        [self.selectedButton setImage:[UIImage imageNamed:@"star_on"] forState:UIControlStateNormal];
    } else {
        [self.selectedButton setImage:[UIImage imageNamed:@"star_off"] forState:UIControlStateNormal];
    }
}

#pragma mark - button actions

- (IBAction)editCommentButtonAction:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(editCommentButtonPressed:)]) {
        [self.delegate editCommentButtonPressed:self];
    }
}

- (IBAction)declarationButtonAction:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(declarationButtonPressed:)]) {
        [self.delegate declarationButtonPressed:self];
    }
}

- (IBAction)selectedButtonAction:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(selectedButtonPressed:)]) {
        [self.delegate selectedButtonPressed:self];
    }
}

@end
