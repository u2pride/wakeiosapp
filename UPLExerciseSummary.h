//
//  UPLExerciseSummary.h
//  Wake
//
//  Created by Alex Ryan on 8/28/14.
//  Copyright (c) 2014 U2PrideLabs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UPLExerciseSummary : UIView

@property (nonatomic, strong) NSMutableArray *headerTitles;
@property (nonatomic, assign) CGFloat barOneValue;
@property (nonatomic, assign) CGFloat barTwoValue;
@property (nonatomic, assign) CGFloat barThreeValue;
@property (nonatomic, strong) UIColor *textHeaderColor;
@property (nonatomic, strong) UIColor *percentageColor;
@property (nonatomic, strong) UIColor *barColor;

- (void)setBarOneValue:(CGFloat)value animated:(BOOL)animated;
- (void)setBarTwoValue:(CGFloat)value animated:(BOOL)animated;
- (void)setBarThreeValue:(CGFloat)value animated:(BOOL)animated;




@end
