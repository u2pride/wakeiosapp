//
//  UPLHomeViewController.h
//  Wake
//
//  Created by Alex Ryan on 6/22/14.
//  Copyright (c) 2014 U2PrideLabs. All rights reserved.
//


//MAKE YOUR OWN REMOTE TO PUSH UP TO.

#import <UIKit/UIKit.h>
#import "Weather.h"
#import <CoreLocation/CoreLocation.h>

@interface UPLHomeViewController : UIViewController <CLLocationManagerDelegate>

@property (nonatomic, strong) NSArray *calendarEventsToday;
@property (nonatomic, strong) NSArray *calendarEventsTomorrow;

@property (nonatomic) BOOL isComingFromCalendarView;
@property (nonatomic) BOOL isComingFromExerciseView;
@property (nonatomic, strong) Weather *weatherData;

@property (nonatomic, strong) CLLocationManager *locationManager;

+ (id)sharedInstance;
- (void)updatedWeather:(NSArray *)temperatures;

//SIGKILL area on grabbing calendar events??

@end
