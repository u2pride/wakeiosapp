//
//  Exercise.m
//  Wake
//
//  Created by Alex Ryan on 7/16/14.
//  Copyright (c) 2014 U2PrideLabs. All rights reserved.
//


//ADD: ID to each exercise to be able to distinguish. Before adding core data.

#import "Exercise.h"

@implementation Exercise

- (instancetype)init
{
    return [self initWithExerciseName:@"NewExercise" withNumReps:0 withNumSets:0];
}


- (instancetype)initWithExerciseName:(NSString *)name withNumReps:(int)reps withNumSets:(int)sets
{
    self = [super init];
    if (self) {
        _exerciseName = name;
        _numOfReps = reps;
        _numOfSets = sets;
        _type = @"default";
    }
    
    return self;
}

@end
