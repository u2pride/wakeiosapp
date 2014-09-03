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

//Calendar Events
@property (nonatomic, strong) UILabel *calenderEvent1;
@property (nonatomic, strong) UILabel *calenderEvent2;
@property (nonatomic, strong) UILabel *calenderEvent3;
@property (nonatomic, strong) UILabel *calenderEvent4;


@end

@implementation UPLHomeViewController
{
    Weather *theWeather;
}

@synthesize calendarEventsToday, calendarEventsTomorrow, weatherTemperatureLabel, weatherHiTemperatureLabel, weatherLoTemperatureLabel, numCalendarEventsLabel, stockNum1Label, stockNum2Label, stockNum3Label, stockNum4Label, weatherHiTemperatureNumber, weatherLoTemperatureNumber, locationCity, locationManager, calenderEvent1, calenderEvent2, calenderEvent3, calenderEvent4;

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
        
        calendarEventsToday = [[NSArray alloc] init];
        calendarEventsTomorrow = [[NSArray alloc] init];
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
    
    

    // Calendar - Num of Events and Transparent Event Title Labels
    // ----------------------------------------------
    
    //Calendar - number of events
    //numCalendarEventsLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 280, 100, 50)];
    //numCalendarEventsLabel.text = @"1";
    //numCalendarEventsLabel.textColor = [UIColor whiteColor];
    //numCalendarEventsLabel.textAlignment = NSTextAlignmentCenter;
    //numCalendarEventsLabel.font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:30];
    //[self.view addSubview:numCalendarEventsLabel];
    
    calenderEvent1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 255, self.view.frame.size.width, 50)];
    calenderEvent1.text = @"Wake & Gym @ 7am";
    calenderEvent1.font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:32];
    calenderEvent1.textAlignment = NSTextAlignmentCenter;
    calenderEvent1.textColor = [UIColor blueColor];
    calenderEvent1.alpha = 0.4;
    [self.view addSubview:calenderEvent1];
    
    calenderEvent2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 290, self.view.frame.size.width, 50)];
    calenderEvent2.text = @"Coffee with Lisa @ 10am";
    calenderEvent2.font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:32];
    calenderEvent2.textAlignment = NSTextAlignmentCenter;
    calenderEvent2.textColor = [UIColor blueColor];
    calenderEvent2.alpha = 0.4;
    [self.view addSubview:calenderEvent2];

    calenderEvent3 = [[UILabel alloc] initWithFrame:CGRectMake(0, 325, self.view.frame.size.width, 50)];
    calenderEvent3.text = @"Meeting with Bobby @ 1pm";
    calenderEvent3.font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:32];
    calenderEvent3.textAlignment = NSTextAlignmentCenter;
    calenderEvent3.textColor = [UIColor blueColor];
    calenderEvent3.alpha = 0.4;
    [self.view addSubview:calenderEvent3];
    
    calenderEvent4 = [[UILabel alloc] initWithFrame:CGRectMake(0, 360, self.view.frame.size.width, 50)];
    calenderEvent4.text = @"Friend Dinner @ 5pm";
    calenderEvent4.font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:32];
    calenderEvent4.textAlignment = NSTextAlignmentCenter;
    calenderEvent4.textColor = [UIColor blueColor];
    calenderEvent4.alpha = 0.4;
    [self.view addSubview:calenderEvent4];
    
    
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
    
    
    //Location Label
    locationCity = [[UILabel alloc] initWithFrame:CGRectMake(200, 70, 100, 50)];
    locationCity.text = @"San Fran";
    locationCity.textColor = [UIColor whiteColor];
    locationCity.textAlignment = NSTextAlignmentLeft;
    locationCity.font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:18];
    [self.view addSubview:locationCity];
    
    
    
    
    
    // Three Main Buttons.  I work out.  I meet people. I dream... - Added last.
    // ----------------------------------------------
    
    [self createButton:@"I work out." withRect:CGRectMake(0, 180, self.view.frame.size.width, 50)];
    [self createButton:@"I meet people." withRect:CGRectMake(0, 310, self.view.frame.size.width, 50)];
    [self createButton:@"I dream big." withRect:CGRectMake(0, 450, self.view.frame.size.width, 50)];
    
    
    
    
    
    /*
     {
     CALayer *layer in implementaion
    
    UIImageView *imageView;
    
    UIView *blueView = [[UIView alloc] initWithFrame:self.view.frame];
    blueView.backgroundColor = [UIColor blueColor];
    imageView = [[UIImageView alloc] initWithFrame:self.view.frame];
    imageView.image = [UIImage imageNamed:@"twitterscreen"];
    //[self.view addSubview:blueView];
    
    mask = [[CALayer alloc] init];
    mask.contents = (__bridge id)([UIImage imageNamed:@"slice"].CGImage);
    mask.bounds = CGRectMake(0, 0, 400, 50);
    mask.anchorPoint = CGPointMake(0.5, 0.5);
    mask.position = CGPointMake(blueView.frame.size.width/2, blueView.frame.size.height/2);
    self.view.layer.mask = mask;
    
    CAKeyframeAnimation *keyFrameAnimation = [[CAKeyframeAnimation alloc] init];
    keyFrameAnimation.keyPath = @"bounds";
    keyFrameAnimation.delegate = self;
    keyFrameAnimation.duration = 3;
    keyFrameAnimation.beginTime = CACurrentMediaTime() + 1;
    NSValue *initialBounds = [NSValue valueWithCGRect:mask.bounds];
    NSValue *secondBounds = [NSValue valueWithCGRect:CGRectMake(0, 0, 400, 20)];
    NSValue *finalBounds = [NSValue valueWithCGRect:CGRectMake(0, 0, 1600, 1600)];
    keyFrameAnimation.values = @[initialBounds, secondBounds, finalBounds];
    keyFrameAnimation.keyTimes = @[@0.0, @0.3, @1.0];
    keyFrameAnimation.timingFunctions = [NSArray arrayWithObjects:
                                        [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                        [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut], nil];
    
    [mask addAnimation:keyFrameAnimation forKey:@"bounds"];
    
    [NSTimer scheduledTimerWithTimeInterval:2.9 target:self selector:@selector(finishIntroAnimation) userInfo:nil repeats:NO];
    
    */
    /*  Sample CA Frame Animation Code
     
     
     CALayer* theLayer = myView.layer;
     CAKeyframeAnimation* animation;
     animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation.z"];
     
     animation.duration = 1.6;
     //animation.cumulative = YES;
     animation.repeatCount = 1;
     animation.removedOnCompletion = NO;
     animation.fillMode = kCAFillModeForwards;
     
     animation.values = [NSArray arrayWithObjects:
     [NSNumber numberWithFloat:0.0 * M_PI],
     [NSNumber numberWithFloat:(15.0/180.0) * M_PI],
     [NSNumber numberWithFloat:(30.0/180.0) * M_PI], // animation stops here...
     [NSNumber numberWithFloat:(45.0/180.0) * M_PI], // ignored!
     [NSNumber numberWithFloat:(190.0/180.0) * M_PI], nil]; // ignored!
     
     animation.keyTimes = [NSArray arrayWithObjects:
     [NSNumber numberWithFloat:0.0],
     [NSNumber numberWithFloat:0.2],
     [NSNumber numberWithFloat:0.4], // ignored!
     [NSNumber numberWithFloat:0.8], // ignored!
     [NSNumber numberWithFloat:1.6], nil]; // ignored!
     
     animation.timingFunctions = [NSArray arrayWithObjects:
     [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear],
     [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear],
     [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear],
     [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear],
     [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear], nil];
     
     [theLayer addAnimation:animation forKey:@"transform.rotation.z"];
     
     
     - (void) finishIntroAnimation
     {
     NSLog(@"Remove from superlayer");
     [mask removeFromSuperlayer];
     self.view.layer.mask = nil;
     
     }
     */
    
    
    
    
    
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
    
    NSDate *todaysDate = [NSDate date];
    NSUInteger preservedComponents = (NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit);
    //NSDateComponents *simulator = [[NSDateComponents alloc] init];
    //[simulator setHour:-5]; for simulator
    
    todaysDate = [calendar dateFromComponents:[calendar components:preservedComponents fromDate:todaysDate]];
    
    NSDateComponents *endOfTodayComp = [[NSDateComponents alloc] init];
    endOfTodayComp.day = 1;
    NSDate *endOfToday = [calendar dateByAddingComponents:endOfTodayComp toDate:todaysDate options:0];
    
    NSDateComponents *endOfTomorrowComp = [[NSDateComponents alloc] init];
    endOfTomorrowComp.day = 2;
    NSDate *endOfTomorrow = [calendar dateByAddingComponents:endOfTomorrowComp toDate:todaysDate options:0];
    
    
    NSLog(@"LOOOK HERE %@, %@, %@", todaysDate, endOfToday, endOfTomorrow);

    
    NSPredicate *calendarPredicateToday = [eventStore predicateForEventsWithStartDate:todaysDate endDate:endOfToday calendars:nil];
    NSPredicate *calendarPredicateTomorrow = [eventStore predicateForEventsWithStartDate:endOfToday endDate:endOfTomorrow calendars:nil];
    
    //add a try - catch block because of the sigkill.  Maybe there is a better way to do calendar.
    //dies when there are no events.

    calendarEventsToday = [eventStore eventsMatchingPredicate:calendarPredicateToday];
    calendarEventsTomorrow = [eventStore eventsMatchingPredicate:calendarPredicateTomorrow];
    
    NSLog(@"%@, TOMRROW %@", calendarEventsToday, calendarEventsTomorrow);
    
    numCalendarEventsLabel.text = [NSString stringWithFormat:@"%d", [self.calendarEventsToday count]];
    
    if ([self.calendarEventsToday count] >= 4) {
        calenderEvent1.text = [[calendarEventsToday objectAtIndex:0] title];
        calenderEvent2.text = [[calendarEventsToday objectAtIndex:1] title];
        calenderEvent3.text = [[calendarEventsToday objectAtIndex:2] title];
        calenderEvent4.text = [[calendarEventsToday objectAtIndex:3] title];
    }


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

#pragma mark - Functions to help initialize all the view objects
- (void)createButton:(NSString *)name withRect:(CGRect)rect
{
    UIButton *newButton= [[UIButton alloc] initWithFrame:rect];
    newButton.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0];
    [newButton setTitle:name forState:UIControlStateNormal];
    newButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:32];
    newButton.titleLabel.textColor = [UIColor whiteColor];
    newButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    newButton.layer.cornerRadius = 2;
    [self.view addSubview:newButton];
    
    if([name isEqualToString:@"I work out."]) {
        [newButton addTarget:self action:@selector(showExercises) forControlEvents:UIControlEventTouchUpInside];
    } else if ([name isEqualToString:@"I meet people."]) {
        [newButton addTarget:self action:@selector(showTodaysCalendarEvents) forControlEvents:UIControlEventTouchUpInside];
    } else if ([name isEqualToString:@"I dream big."]) {
        [newButton addTarget:self action:@selector(showGoals) forControlEvents:UIControlEventTouchUpInside];
    } else {
        NSLog(@"Wrong button name");
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

# pragma mark - Button Methods

- (void)showGoals
{
    NSLog(@"Show goals");
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
    popupCalendarViewController.calendarEventsToday = self.calendarEventsToday;
    popupCalendarViewController.calendarEventsTomorrow = self.calendarEventsTomorrow;
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
        
        //Stop Updating Location
        [locationManager stopUpdatingLocation];
        [locationManager stopUpdatingHeading];

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
