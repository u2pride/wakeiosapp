//
//  UPLHomeViewController.m
//  Wake
//
//  Created by Alex Ryan on 6/22/14.
//  Copyright (c) 2014 U2PrideLabs. All rights reserved.
//

#import "UPLHomeViewController.h"
#import "UPLCalendarViewController.h"
#import "IDTransitioningDelegate.h"
#import <EventKit/EventKit.h>
#import "UIImageView+LBBlurredImage.h"
#import "UIImage+ImageEffects.h"
#import "Weather.h"


@interface UPLHomeViewController ()

@property (nonatomic, strong) UIImageView *blurredImageView;
@property (nonatomic, strong) id<UIViewControllerTransitioningDelegate> transitioningDelegate;
@property (nonatomic, strong) UILabel *weatherTemperatureLabel;
@property (nonatomic, strong) UILabel *weatherHiTemperatureLabel;
@property (nonatomic, strong) UILabel *weatherHiTemperatureNumber;
@property (nonatomic, strong) UILabel *weatherLoTemperatureLabel;
@property (nonatomic, strong) UILabel *weatherLoTemperatureNumber;
@property (nonatomic, strong) UILabel *numCalendarEventsLabel;

//Stocks
@property (nonatomic, strong) UILabel *stockNum1Label;
@property (nonatomic, strong) UILabel *stockNum2Label;
@property (nonatomic, strong) UILabel *stockNum3Label;
@property (nonatomic, strong) UILabel *stockNum4Label;

@end

@implementation UPLHomeViewController
{
    Weather *theWeather;
}

@synthesize calendarEvents, weatherTemperatureLabel, weatherHiTemperatureLabel, weatherLoTemperatureLabel, numCalendarEventsLabel, stockNum1Label, stockNum2Label, stockNum3Label, stockNum4Label, weatherHiTemperatureNumber, weatherLoTemperatureNumber;

+ (instancetype)sharedInstance
{
    static dispatch_once_t once;
    static id sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.transitioningDelegate = [[IDTransitioningDelegate alloc] init];
        NSLog(@"Transitioning Delegate is Set");
        
        locationManager = [[CLLocationManager alloc] init];
        [locationManager setDelegate:self];
        [locationManager setDesiredAccuracy:kCLLocationAccuracyBestForNavigation];
        
        [locationManager startUpdatingLocation];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"BackgroundImage"]];
    
    self.blurredImageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    self.blurredImageView.image = [UIImage imageNamed:@"BackgroundImage"];
    
    UIButton *calendarEventsButton= [[UIButton alloc] initWithFrame:CGRectMake(35, 240, 100, 50)];
    calendarEventsButton.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.5];
    [calendarEventsButton setTitle:@"events" forState:UIControlStateNormal];
    calendarEventsButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:24];
    calendarEventsButton.titleLabel.textColor = [UIColor whiteColor];
    calendarEventsButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    calendarEventsButton.layer.cornerRadius = 10;
    [self.view addSubview:calendarEventsButton];
    
    [calendarEventsButton addTarget:self action:@selector(showTodaysCalendarEvents) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *exercisesButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 220, 200, 80)];
    exercisesButton.center = CGPointMake(self.view.center.x, 370);
    exercisesButton.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.5];
    [exercisesButton setTitle:@"Top Exercises" forState:UIControlStateNormal];
    exercisesButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:24];
    exercisesButton.titleLabel.textColor = [UIColor whiteColor];
    exercisesButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    exercisesButton.layer.cornerRadius = 10;
    exercisesButton.layer.borderWidth = 0;
    [self.view addSubview:exercisesButton];
    
    [exercisesButton addTarget:self action:@selector(showExercises) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    // Code for Animating a Cool Effect on the buttons
//    CGRect pathFrame = CGRectMake(-CGRectGetMidX(exercisesButton.bounds), -CGRectGetMidY(exercisesButton.bounds), exercisesButton.bounds.size.width, exercisesButton.bounds.size.height);
//    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:pathFrame cornerRadius:exercisesButton.layer.cornerRadius];
//    
//    CAShapeLayer *circleShape = [CAShapeLayer layer];
//    circleShape.path = path.CGPath;
//    circleShape.position = exercisesButton.layer.position;
//    circleShape.fillColor = [UIColor clearColor].CGColor;
//    circleShape.opacity = 0;
//    circleShape.strokeColor = [UIColor blackColor].CGColor;
//    circleShape.lineWidth = 1.0f;
//    
//    [self.view.layer addSublayer:circleShape];
//    
//    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
//    scaleAnimation.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
//    scaleAnimation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(2.5, 2.5, 1)];
//    
//    CABasicAnimation *alphaAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
//    alphaAnimation.fromValue = @1;
//    alphaAnimation.toValue = @0;
//    
//    CAAnimationGroup *animation = [CAAnimationGroup animation];
//    animation.animations = @[scaleAnimation, alphaAnimation];
//    animation.duration = 1.5f;
//    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
//    [circleShape addAnimation:animation forKey:nil];
    
    
    //Weather Information
    theWeather = [[Weather alloc] init];
    
    weatherTemperatureLabel = [[UILabel alloc] initWithFrame:CGRectMake(130, 40, 100, 40)];
    weatherTemperatureLabel.textColor = [UIColor blackColor];
    weatherTemperatureLabel.text = @"-";
    weatherTemperatureLabel.textAlignment = NSTextAlignmentCenter;
    weatherTemperatureLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:50];
    [self.view addSubview:weatherTemperatureLabel];
    
    weatherHiTemperatureLabel = [[UILabel alloc] initWithFrame:CGRectMake(230, 35, 30, 40)];
    weatherHiTemperatureLabel.textColor = [UIColor blueColor];
    weatherHiTemperatureLabel.text = @"Hi";
    weatherHiTemperatureLabel.textAlignment = NSTextAlignmentCenter;
    weatherHiTemperatureLabel.font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:30];
    [self.view addSubview:weatherHiTemperatureLabel];
    
    weatherLoTemperatureLabel = [[UILabel alloc] initWithFrame:CGRectMake(65, 35, 30, 40)];
    weatherLoTemperatureLabel.textColor = [UIColor blueColor];
    weatherLoTemperatureLabel.text = @"Lo";
    weatherLoTemperatureLabel.textAlignment = NSTextAlignmentCenter;
    weatherLoTemperatureLabel.font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:30];
    [self.view addSubview:weatherLoTemperatureLabel];
    
    weatherHiTemperatureNumber = [[UILabel alloc] initWithFrame:CGRectMake(270, 35, 30, 40)];
    weatherHiTemperatureNumber.textColor = [UIColor blueColor];
    weatherHiTemperatureNumber.text = @"73";
    weatherHiTemperatureNumber.textAlignment = NSTextAlignmentCenter;
    weatherHiTemperatureNumber.font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:20];
    [self.view addSubview:weatherHiTemperatureNumber];
    
    weatherLoTemperatureNumber = [[UILabel alloc] initWithFrame:CGRectMake(25, 35, 30, 40)];
    weatherLoTemperatureNumber.textColor = [UIColor blueColor];
    weatherLoTemperatureNumber.text = @"69";
    weatherLoTemperatureNumber.textAlignment = NSTextAlignmentCenter;
    weatherLoTemperatureNumber.font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:20];
    [self.view addSubview:weatherLoTemperatureNumber];
    
    
    
    //Calendar
    numCalendarEventsLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 200, 100, 50)];
    numCalendarEventsLabel.textColor = [UIColor whiteColor];
    numCalendarEventsLabel.text = @"1";
    numCalendarEventsLabel.textAlignment = NSTextAlignmentCenter;
    numCalendarEventsLabel.font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:30];
    [self.view addSubview:numCalendarEventsLabel];
    
    
    //Stocks
    stockNum1Label = [[UILabel alloc] initWithFrame:CGRectMake(85, 440, 50, 40)];
    stockNum1Label.textColor = [UIColor whiteColor];
    stockNum1Label.text = @"AAPL";
    stockNum1Label.textAlignment = NSTextAlignmentCenter;
    stockNum1Label.font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:20];
    [self.view addSubview:stockNum1Label];
    
    stockNum2Label = [[UILabel alloc] initWithFrame:CGRectMake(85, 470, 50, 40)];
    stockNum2Label.textColor = [UIColor whiteColor];
    stockNum2Label.text = @"CMG";
    stockNum2Label.textAlignment = NSTextAlignmentCenter;
    stockNum2Label.font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:20];
    [self.view addSubview:stockNum2Label];
    
    stockNum3Label = [[UILabel alloc] initWithFrame:CGRectMake(205, 440, 50, 40)];
    stockNum3Label.textColor = [UIColor whiteColor];
    stockNum3Label.text = @"TSLA";
    stockNum3Label.textAlignment = NSTextAlignmentCenter;
    stockNum3Label.font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:20];
    [self.view addSubview:stockNum3Label];
    
    stockNum4Label = [[UILabel alloc] initWithFrame:CGRectMake(205, 470, 50, 40)];
    stockNum4Label.textColor = [UIColor whiteColor];
    stockNum4Label.text = @"WFM";
    stockNum4Label.textAlignment = NSTextAlignmentCenter;
    stockNum4Label.font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:20];
    [self.view addSubview:stockNum4Label];
    
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    //Get access to the database of events
    EKEventStore *eventStore = [[EKEventStore alloc] init];
    //Request access from the user
    [eventStore requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
        NSLog(@"Calendar!");
    }];
    
    //Calendar
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDateComponents *oneDayAgoComponents = [[NSDateComponents alloc] init];
    oneDayAgoComponents.day = -1;
    NSDate *oneDayAgo = [calendar dateByAddingComponents:oneDayAgoComponents toDate:[NSDate date] options:0];
    
    NSDateComponents *oneDayForwardComponents = [[NSDateComponents alloc] init];
    oneDayForwardComponents.day = 1;
    NSDate *oneDayForward = [calendar dateByAddingComponents:oneDayForwardComponents toDate:[NSDate date] options:0];
    
    NSPredicate *calendarPredicate = [eventStore predicateForEventsWithStartDate:oneDayAgo endDate:oneDayForward calendars:nil];
    
    NSArray *myEvents = [[NSArray alloc] init];
    myEvents = [eventStore eventsMatchingPredicate:calendarPredicate];
    self.calendarEvents = myEvents;
    
    numCalendarEventsLabel.text = [NSString stringWithFormat:@"%d", [self.calendarEvents count]];
    
    
    //for (int i=0; i < calendarEvents.count ; i++) {
    //    NSLog(@"%@", [calendarEvents objectAtIndex:i]);
    //}

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (self.isComingFromCalendarView)
    {
        self.blurredImageView.alpha = 1.0;
        [UIView animateWithDuration:1 animations:^{
            self.blurredImageView.alpha = 0;
        }completion:^(BOOL finished)
         {
             if (finished)
                 [self.blurredImageView removeFromSuperview];
         }];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    NSLog(@"Locations: %@", locations);
    CLLocation *location = [locations lastObject];

    [theWeather getCurrentWithLat:location.coordinate.latitude withLong:location.coordinate.longitude];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"Could not find location: %@", error);
}

- (void)showTodaysCalendarEvents
{

    CGRect screenRect = [[UIScreen mainScreen] bounds];
    
    UIGraphicsBeginImageContext(screenRect.size);
    [self.view drawViewHierarchyInRect:screenRect afterScreenUpdates:YES];
    UIImage *snapshotImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    self.blurredImageView.image = [snapshotImage applyDarkEffect];
    //[self.blurredImageView setImageToBlur:snapshotImage blurRadius:5 completionBlock:nil];
    self.blurredImageView.alpha = 0;
    [UIView animateWithDuration:1 animations:^{
        self.blurredImageView.alpha = 1.0;
    }];
    
    [self.view addSubview:self.blurredImageView];
    
    self.isComingFromCalendarView = TRUE;
        
    UPLCalendarViewController *popupCalendarViewController = [[UPLCalendarViewController alloc] init];
    popupCalendarViewController.calendarEvents = self.calendarEvents;
    popupCalendarViewController.transitioningDelegate = self.transitioningDelegate;
    popupCalendarViewController.modalPresentationStyle = UIModalPresentationCustom;
    
    [self presentViewController:popupCalendarViewController animated:YES completion:nil];
}


- (void)showExercises
{
    
}

- (void)updatedWeather:(int)temperature
{
    NSLog(@"We have the temp: %i", temperature);
    weatherTemperatureLabel.text = [NSString stringWithFormat:@"%i", temperature];
    //[self.view setNeedsDisplay];
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}



- (void)dealloc
{
    [locationManager setDelegate:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
 
 [theWeather addObserver:self forKeyPath:@"tempCurrent" options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew context:NULL];
 
 theWeather.tempCurrent = [NSNumber numberWithInt:120];
 
 - (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
 {
 NSLog(@"I SEE A CHANGE IN THE WEATHER!");
 weatherTemperatureLabel.text = [NSString stringWithFormat:@"%@", theWeather.tempCurrent];
 }
 
 
 
*/

@end
