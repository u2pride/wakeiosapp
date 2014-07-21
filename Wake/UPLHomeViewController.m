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
#import "UPLExercisesViewController.h"
#import <CoreLocation/CoreLocation.h>
#import <AddressBookUI/AddressBookUI.h>


@interface UPLHomeViewController ()

@property (nonatomic, strong) UIImageView *blurredImageView;
@property (nonatomic, strong) id<UIViewControllerTransitioningDelegate> transitioningDelegate;
@property (nonatomic, strong) UILabel *weatherTemperatureLabel;
@property (nonatomic, strong) UILabel *weatherHiTemperatureLabel;
@property (nonatomic, strong) UILabel *weatherHiTemperatureNumber;
@property (nonatomic, strong) UILabel *weatherLoTemperatureLabel;
@property (nonatomic, strong) UILabel *weatherLoTemperatureNumber;
@property (nonatomic, strong) UILabel *numCalendarEventsLabel;
@property (nonatomic, strong) UILabel *locationCity;

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

@synthesize calendarEvents, weatherTemperatureLabel, weatherHiTemperatureLabel, weatherLoTemperatureLabel, numCalendarEventsLabel, stockNum1Label, stockNum2Label, stockNum3Label, stockNum4Label, weatherHiTemperatureNumber, weatherLoTemperatureNumber, locationCity, locationManager;

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
    
    UIButton *calendarEventsButton= [[UIButton alloc] initWithFrame:CGRectMake(0, 310, self.view.frame.size.width, 50)];
    calendarEventsButton.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0];
    [calendarEventsButton setTitle:@"I meet people." forState:UIControlStateNormal];
    calendarEventsButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:32];
    calendarEventsButton.titleLabel.textColor = [UIColor whiteColor];
    calendarEventsButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    calendarEventsButton.layer.cornerRadius = 2;
    [self.view addSubview:calendarEventsButton];
    
    [calendarEventsButton addTarget:self action:@selector(showTodaysCalendarEvents) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *exercisesButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 180, self.view.frame.size.width, 50)];
    exercisesButton.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0];
    [exercisesButton setTitle:@"I work out." forState:UIControlStateNormal];
    exercisesButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:32];
    exercisesButton.titleLabel.textColor = [UIColor whiteColor];
    exercisesButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    exercisesButton.layer.cornerRadius = 2;
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
    
    weatherTemperatureLabel = [[UILabel alloc] initWithFrame:CGRectMake(35, 45, 80, 50)];
    weatherTemperatureLabel.text = @"72";
    weatherTemperatureLabel.textColor = [UIColor blueColor];
    weatherTemperatureLabel.textAlignment = NSTextAlignmentCenter;
    weatherTemperatureLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:50];
    [self.view addSubview:weatherTemperatureLabel];
    
    weatherHiTemperatureLabel = [[UILabel alloc] initWithFrame:CGRectMake(150, 35, 30, 40)];
    weatherHiTemperatureLabel.text = @"Hi";
    weatherHiTemperatureLabel.textColor = [UIColor whiteColor];
    weatherHiTemperatureLabel.textAlignment = NSTextAlignmentCenter;
    weatherHiTemperatureLabel.font = [UIFont fontWithName:@"HelveticaNeue-Regular" size:35];
    [self.view addSubview:weatherHiTemperatureLabel];
    
    weatherLoTemperatureLabel = [[UILabel alloc] initWithFrame:CGRectMake(225, 35, 30, 40)];
    weatherLoTemperatureLabel.text = @"Lo";
    weatherLoTemperatureLabel.textColor = [UIColor whiteColor];
    weatherLoTemperatureLabel.textAlignment = NSTextAlignmentCenter;
    weatherLoTemperatureLabel.font = [UIFont fontWithName:@"HelveticaNeue-Regular" size:35];
    [self.view addSubview:weatherLoTemperatureLabel];
    
    weatherHiTemperatureNumber = [[UILabel alloc] initWithFrame:CGRectMake(180, 35, 30, 40)];
    weatherHiTemperatureNumber.text = @"73";
    weatherHiTemperatureNumber.textColor = [UIColor whiteColor];
    weatherHiTemperatureNumber.textAlignment = NSTextAlignmentCenter;
    weatherHiTemperatureNumber.font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:20];
    [self.view addSubview:weatherHiTemperatureNumber];
    
    weatherLoTemperatureNumber = [[UILabel alloc] initWithFrame:CGRectMake(260, 35, 30, 40)];
    weatherLoTemperatureNumber.text = @"69";
    weatherLoTemperatureNumber.textColor = [UIColor whiteColor];
    weatherLoTemperatureNumber.textAlignment = NSTextAlignmentCenter;
    weatherLoTemperatureNumber.font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:20];
    [self.view addSubview:weatherLoTemperatureNumber];
    
    
    
    //Calendar
    numCalendarEventsLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 280, 100, 50)];
    numCalendarEventsLabel.text = @"1";
    numCalendarEventsLabel.textColor = [UIColor whiteColor];
    numCalendarEventsLabel.textAlignment = NSTextAlignmentCenter;
    numCalendarEventsLabel.font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:30];
    [self.view addSubview:numCalendarEventsLabel];
    
    //Location
    locationCity = [[UILabel alloc] initWithFrame:CGRectMake(180, 70, 120, 50)];
    locationCity.text = @"San Fran";
    locationCity.textColor = [UIColor whiteColor];
    locationCity.textAlignment = NSTextAlignmentCenter;
    locationCity.font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:15];
    [self.view addSubview:locationCity];
    
    
    //Stocks
//    stockNum1Label = [[UILabel alloc] initWithFrame:CGRectMake(85, 440, 50, 40)];
//    stockNum1Label.textColor = [UIColor whiteColor];
//    stockNum1Label.text = @"AAPL";
//    stockNum1Label.textAlignment = NSTextAlignmentCenter;
//    stockNum1Label.font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:20];
//    [self.view addSubview:stockNum1Label];
//    
//    stockNum2Label = [[UILabel alloc] initWithFrame:CGRectMake(85, 470, 50, 40)];
//    stockNum2Label.textColor = [UIColor whiteColor];
//    stockNum2Label.text = @"CMG";
//    stockNum2Label.textAlignment = NSTextAlignmentCenter;
//    stockNum2Label.font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:20];
//    [self.view addSubview:stockNum2Label];
//    
//    stockNum3Label = [[UILabel alloc] initWithFrame:CGRectMake(205, 440, 50, 40)];
//    stockNum3Label.textColor = [UIColor whiteColor];
//    stockNum3Label.text = @"TSLA";
//    stockNum3Label.textAlignment = NSTextAlignmentCenter;
//    stockNum3Label.font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:20];
//    [self.view addSubview:stockNum3Label];
//    
//    stockNum4Label = [[UILabel alloc] initWithFrame:CGRectMake(205, 470, 50, 40)];
//    stockNum4Label.textColor = [UIColor whiteColor];
//    stockNum4Label.text = @"WFM";
//    stockNum4Label.textAlignment = NSTextAlignmentCenter;
//    stockNum4Label.font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:20];
//    [self.view addSubview:stockNum4Label];
    
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
    
    if (self.isComingFromCalendarView || self.isComingFromExerciseView)
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
    [self reverseGeocode:location];
    
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
    [UIView animateWithDuration:0.5 animations:^{
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
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    
    UIGraphicsBeginImageContext(screenRect.size);
    [self.view drawViewHierarchyInRect:screenRect afterScreenUpdates:YES];
    UIImage *snapshotImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    self.blurredImageView.image = [snapshotImage applyDarkEffect];
    //[self.blurredImageView setImageToBlur:snapshotImage blurRadius:5 completionBlock:nil];
    self.blurredImageView.alpha = 0;
    [UIView animateWithDuration:0.5 animations:^{
        self.blurredImageView.alpha = 1.0;
    }];
    
    [self.view addSubview:self.blurredImageView];
    
    self.isComingFromExerciseView = TRUE;
    
    UPLExercisesViewController *exerciseVC = [[UPLExercisesViewController alloc] init];
    exerciseVC.transitioningDelegate = self.transitioningDelegate;
    exerciseVC.modalPresentationStyle = UIModalPresentationCustom;
    
    [self presentViewController:exerciseVC animated:YES completion:nil];

}

- (void)updatedWeather:(NSArray *)temperatures
{
    float tempCurrent = [[temperatures objectAtIndex:0] intValue];
    float tempMax = [[temperatures objectAtIndex:1] intValue];
    float tempMin = [[temperatures objectAtIndex:2] intValue];
    
    NSLog(@"We have the temps: %@", temperatures);
    
    weatherTemperatureLabel.text = [NSString stringWithFormat:@"%.0f", tempCurrent];
    weatherLoTemperatureNumber.text = [NSString stringWithFormat:@"%.0f", tempMin];
    weatherHiTemperatureNumber.text = [NSString stringWithFormat:@"%.0f", tempMax];
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


#pragma mark - Location to Address

- (void)reverseGeocode:(CLLocation *)location {
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        CLPlacemark *placemark = placemarks[0];
        NSLog(@"Found %@", placemark.name);
        self.locationCity.text = placemark.locality;
        //NSLog(@"Finding address");
        //if (error) {
        //    NSLog(@"Error %@", error.description);
        //} else {
        //    CLPlacemark *placemark = [placemarks lastObject];
        //    self.locationCity.text = [NSString stringWithFormat:@"%d", ABCreateStringWithAddressDictionary(placemark.addressDictionary, NO)];
        //}
    }];
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
