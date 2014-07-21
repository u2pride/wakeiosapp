//
//  UPLExerciseCell.h
//  Wake
//
//  Created by Alex Ryan on 7/14/14.
//  Copyright (c) 2014 U2PrideLabs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UPLExerciseCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UIView *priorityColor;
@property (nonatomic, strong) IBOutlet UILabel *exerciseTitle;
@property (nonatomic, strong) IBOutlet UILabel *numSets;
@property (nonatomic, strong) IBOutlet UILabel *numReps;

@end
