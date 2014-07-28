//
//  UPLCalendarViewController.h
//  Wake
//
//  Created by Alex Ryan on 6/22/14.
//  Copyright (c) 2014 U2PrideLabs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface UPLCalendarViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSArray *calendarEventsToday;
@property (nonatomic, strong) NSArray *calendarEventsTomorrow;
@property (nonatomic, strong) UITableView *calendarTableView;

@end
