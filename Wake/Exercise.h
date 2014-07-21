//
//  Exercise.h
//  Wake
//
//  Created by Alex Ryan on 7/16/14.
//  Copyright (c) 2014 U2PrideLabs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Exercise : NSObject

- (instancetype)initWithExerciseName:(NSString *)name withNumReps:(int)reps withNumSets:(int)sets;

@property (nonatomic, strong) NSString *exerciseName;
@property (nonatomic) int numOfSets;
@property (nonatomic) int numOfReps;

@end
