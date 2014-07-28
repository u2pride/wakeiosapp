//
//  ExerciseStore.h
//  Wake
//
//  Created by Alex Ryan on 7/22/14.
//  Copyright (c) 2014 U2PrideLabs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Exercise.h"

@interface ExerciseStore : NSObject
{
    NSMutableArray *allExercises;
}

+ (ExerciseStore *)sharedStore;

//- (NSArray *)priorityOneExercises; //filter with predicate.
- (NSArray *)allExercises;

- (void)addExercise:(Exercise *)exerciseToAdd;
- (void)removeExercise:(Exercise *)exerciseToRemove;

@end
