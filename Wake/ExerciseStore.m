//
//  ExerciseStore.m
//  Wake
//
//  Created by Alex Ryan on 7/22/14.
//  Copyright (c) 2014 U2PrideLabs. All rights reserved.
//

#import "ExerciseStore.h"

@implementation ExerciseStore


- (id)init
{
    self = [super init];
    if (self) {
        allExercises = [[NSMutableArray alloc] init];
    }
    
    return self;
}

+ (ExerciseStore *)sharedStore
{
    static dispatch_once_t once;
    static id sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}


- (NSArray *)allExercises
{
    return allExercises;
}


- (void)addExercise:(Exercise *)exerciseToAdd
{
    [allExercises addObject:exerciseToAdd];
}


- (void)removeExercise:(Exercise *)exerciseToRemove
{
    [allExercises removeObject:exerciseToRemove];
}

- (void)decrementNumRepsForExercise:(Exercise *)exercise
{
    if (exercise.currentNumOfReps == 0 && exercise.currentNumOfSets == 0) {
        return;
    } else if (exercise.currentNumOfReps == 1 && exercise.currentNumOfSets != 0) {
        exercise.currentNumOfReps = exercise.numOfReps;
        exercise.currentNumOfSets -= 1;
    } else if (exercise.currentNumOfReps == 1 && exercise.currentNumOfSets == 0) {
        exercise.currentNumOfReps = 0;
    } else {
        exercise.currentNumOfReps -= 1;
    }
}



@end
