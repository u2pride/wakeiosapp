//
//  UPLExerciseCell.m
//  Wake
//
//  Created by Alex Ryan on 7/14/14.
//  Copyright (c) 2014 U2PrideLabs. All rights reserved.
//

#import "UPLExerciseCell.h"

@implementation UPLExerciseCell

@synthesize priorityColor, exerciseTitle, numReps, numSets;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
