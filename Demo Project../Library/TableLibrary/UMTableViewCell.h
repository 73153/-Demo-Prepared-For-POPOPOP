//
//  UMTableViewCell.h
//  SWTableViewCell
//
//  Created by Matt Bowman on 12/2/13.
//  Copyright (c) 2013 Chris Wendel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWTableViewCell.h"

/*
 *  Example of a custom cell built in Storyboard
 */
@interface UMTableViewCell : SWTableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *checkBoxImage;
@property (strong, nonatomic) IBOutlet UIImageView *userImage;
@property (nonatomic) BOOL isCellSelected;
@property (weak, nonatomic) IBOutlet UILabel *lblCellDate;
@property (weak, nonatomic) IBOutlet UILabel *lblCellTime;
@property (weak, nonatomic) IBOutlet UILabel *lblClass;
@property (weak, nonatomic) IBOutlet UIImageView *repeatingImage;

@property (weak, nonatomic) IBOutlet UIButton *btnCancelRequest;

@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (strong, nonatomic) IBOutlet UIButton *checkBoxButton;
@property (weak, nonatomic) IBOutlet UIView *monthColoredEventView;


@end
