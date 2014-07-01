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


@end

@implementation UPLHomeViewController

@synthesize calendarEvents;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.transitioningDelegate = [[IDTransitioningDelegate alloc] init];
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
    
    UILabel *goodMorningLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 20, 400, 56)];
    goodMorningLabel.textColor = [UIColor whiteColor];
    goodMorningLabel.text = @"Good Morning";
    goodMorningLabel.font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:50];
    [self.view addSubview:goodMorningLabel];
    
    UIButton *calendarEventsButton= [[UIButton alloc] initWithFrame:CGRectMake(20, 100, 200, 50)];
    calendarEventsButton.center = CGPointMake(self.view.center.x, 150);
    calendarEventsButton.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.5];
    [calendarEventsButton setTitle:@"Today's Events" forState:UIControlStateNormal];
    calendarEventsButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:24];
    calendarEventsButton.titleLabel.textColor = [UIColor whiteColor];
    calendarEventsButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    calendarEventsButton.layer.cornerRadius = 10;
    [self.view addSubview:calendarEventsButton];
    
    [calendarEventsButton addTarget:self action:@selector(showTodaysCalendarEvents) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *exercisesButton = [[UIButton alloc] initWithFrame:CGRectMake(20, 200, 200, 50)];
    exercisesButton.center = CGPointMake(self.view.center.x, 250);
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
    CGRect pathFrame = CGRectMake(-CGRectGetMidX(exercisesButton.bounds), -CGRectGetMidY(exercisesButton.bounds), exercisesButton.bounds.size.width, exercisesButton.bounds.size.height);
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:pathFrame cornerRadius:exercisesButton.layer.cornerRadius];
    
    CAShapeLayer *circleShape = [CAShapeLayer layer];
    circleShape.path = path.CGPath;
    circleShape.position = exercisesButton.layer.position;
    circleShape.fillColor = [UIColor clearColor].CGColor;
    circleShape.opacity = 0;
    circleShape.strokeColor = [UIColor blackColor].CGColor;
    circleShape.lineWidth = 1.0f;
    
    [self.view.layer addSublayer:circleShape];
    
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimation.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
    scaleAnimation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(2.5, 2.5, 1)];
    
    CABasicAnimation *alphaAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    alphaAnimation.fromValue = @1;
    alphaAnimation.toValue = @0;
    
    CAAnimationGroup *animation = [CAAnimationGroup animation];
    animation.animations = @[scaleAnimation, alphaAnimation];
    animation.duration = 1.5f;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    [circleShape addAnimation:animation forKey:nil];
    
    
    
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
    
    for (int i=0; i < calendarEvents.count ; i++) {
        NSLog(@"%@", [calendarEvents objectAtIndex:i]);
    }
    
    
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSLog(@"Hellooooooooo");
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
    Weather *newWeatherData = [[Weather alloc] init];
    [newWeatherData getCurrent:@"Atlanta"];
    NSLog(@"ShowExercises");
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
