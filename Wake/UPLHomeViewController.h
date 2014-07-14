//
//  UPLHomeViewController.h
//  Wake
//
//  Created by Alex Ryan on 6/22/14.
//  Copyright (c) 2014 U2PrideLabs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Weather.h"
#import <CoreLocation/CoreLocation.h>

@interface UPLHomeViewController : UIViewController <CLLocationManagerDelegate>
{
    CLLocationManager *locationManager;
}

@property (nonatomic, strong) NSArray *calendarEvents;
@property (nonatomic) BOOL isComingFromCalendarView;
@property (nonatomic, strong) Weather *weatherData;

+ (id)sharedInstance;
- (void)updatedWeather:(int)temperature;

@end
