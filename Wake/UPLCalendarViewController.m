//
//  UPLCalendarViewController.m
//  Wake
//
//  Created by Alex Ryan on 6/22/14.
//  Copyright (c) 2014 U2PrideLabs. All rights reserved.
//

#import "UPLCalendarViewController.h"
#import "UPLHomeViewController.h"
#import <EventKit/EventKit.h>
#import <POP/POP.h>


@interface UPLCalendarViewController ()
{
    BOOL showTodaysEvents; // somehow prevent the animation from running again on the table cells?
}

@property (nonatomic, strong) UILabel *calendarHeader;

@end

@implementation UPLCalendarViewController

@synthesize calendarEventsToday, calendarEventsTomorrow, calendarTableView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    showTodaysEvents = TRUE;
    
    self.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    
    self.calendarTableView = [[UITableView alloc] initWithFrame:CGRectMake(20, 80, screenWidth - 40, screenHeight - 100) style:UITableViewStylePlain];
    self.calendarTableView.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0];
    self.calendarTableView.dataSource = self;
    self.calendarTableView.delegate = self;
    self.calendarTableView.layer.cornerRadius = 5;
    [self.calendarTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:self.calendarTableView];
    
    _calendarHeader = [[UILabel alloc] initWithFrame:CGRectMake(15, 18, screenWidth - 40, 60)];
    _calendarHeader.textColor = [UIColor whiteColor];
    _calendarHeader.text = @"Today";
    _calendarHeader.font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:50];
    _calendarHeader.userInteractionEnabled = TRUE;
    [self.view addSubview:_calendarHeader];
    
    
    UIButton *closeButton = [[UIButton alloc] initWithFrame:CGRectMake(screenWidth - 100, 40, 100, 30)];
    [closeButton setTitle:@"X" forState:UIControlStateNormal];
    [closeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    closeButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:40];
    [self.view addSubview:closeButton];
    
    [closeButton addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
    
    [_calendarHeader addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(switchDays)]];

    
    //[self showAnimate];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)switchDays
{
    if (showTodaysEvents){
        _calendarHeader.text = @"Tomorrow";
        showTodaysEvents = FALSE;
    } else {
        _calendarHeader.text = @"Today";
        showTodaysEvents = TRUE;
    }
    
    [self.calendarTableView reloadData];
    
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (showTodaysEvents) {
        return self.calendarEventsToday.count;
    } else {
        return self.calendarEventsTomorrow.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Inside Tableivew: %d", indexPath.row);
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    
    EKEvent *event;
    if (showTodaysEvents) {
        event = [calendarEventsToday objectAtIndex:indexPath.row];
    } else {
        event = [calendarEventsTomorrow objectAtIndex:indexPath.row];
    }
    
    cell.textLabel.text = [event valueForKeyPath:@"title"];
    cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:18];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0];
    

    NSDate *dateTime = [event valueForKeyPath:@"startDate"];
    NSLog(@"Date: %@", dateTime);
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    
    
    cell.detailTextLabel.textColor = [UIColor whiteColor];
    cell.detailTextLabel.text = [dateFormatter stringFromDate:dateTime];
    cell.detailTextLabel.font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:12];

    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGRect initialBounds = cell.layer.bounds;
    CGRect finalBounds = CGRectMake(cell.layer.bounds.origin.x - 100, cell.layer.bounds.origin.y, cell.layer.bounds.size.width + 1000, cell.layer.bounds.size.height);
    float offset = (indexPath.row) / 2.9f;
    cell.layer.opacity = 0;
    
    POPSpringAnimation *cellPop = [POPSpringAnimation animation];
    cellPop.property = [POPAnimatableProperty propertyWithName:kPOPLayerBounds];
    cellPop.fromValue = [NSValue valueWithCGRect:finalBounds];
    cellPop.toValue = [NSValue valueWithCGRect:initialBounds];
    cellPop.springBounciness = 10.0;
    cellPop.springSpeed = 0.6;
    cellPop.beginTime = CACurrentMediaTime() + offset;

    [cell.layer pop_addAnimation:cellPop forKey:@"cellPop"];
//    
//    POPSpringAnimation *cellPopOpacity = [POPSpringAnimation animation];
//    cellPopOpacity.property = [POPAnimatableProperty propertyWithName:kPOPViewAlpha];
//    cellPopOpacity.fromValue = @(0.0);
//    cellPopOpacity.toValue = @(1.0);
//    cellPopOpacity.springBounciness = 10.0;
//    cellPopOpacity.springSpeed = 0.2;
//    cellPopOpacity.velocity = @(1.0);
//    
//    [cell pop_addAnimation:cellPopOpacity forKey:@"popOpacity"];
    

    
    POPBasicAnimation *opacityAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerOpacity];
    opacityAnimation.fromValue = @(0);
    opacityAnimation.toValue = @(1);
    opacityAnimation.duration = 2.0f;
    opacityAnimation.beginTime = CACurrentMediaTime() + offset;
    [cell.layer pop_addAnimation:opacityAnimation forKey:@"opacityAnimation"];
    
    
    
    /* Scaling and Position Animation with Pop
    POPSpringAnimation *scaleAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    scaleAnimation.fromValue  = [NSValue valueWithCGSize:CGSizeMake(0.1f, 0.1f)];
    scaleAnimation.toValue  = [NSValue valueWithCGSize:CGSizeMake(1.0f, 1.0f)];//@(0.0f);
    scaleAnimation.springBounciness = 20.0f;
    scaleAnimation.springSpeed = 5.0f;
    scaleAnimation.beginTime = CACurrentMediaTime() + 1.0;
    [cell.layer pop_addAnimation:scaleAnimation forKey:@"scaleAnimation"];
    */
     
    /*  Sweet Z Axis Animation
    //1. Setup the CATransform3D structure
    CATransform3D rotation;
    rotation = CATransform3DMakeRotation( (90.0*M_PI)/180, 0.0, 0.7, 0.4);
    rotation.m34 = 1.0/ -600;
    
    
    //2. Define the initial state (Before the animation)
    cell.layer.shadowColor = [[UIColor blackColor]CGColor];
    cell.layer.shadowOffset = CGSizeMake(10, 10);
    cell.alpha = 0;
    
    cell.layer.transform = rotation;
    cell.layer.anchorPoint = CGPointMake(0, 0.5);
    
    
    //3. Define the final state (After the animation) and commit the animation
    [UIView beginAnimations:@"rotation" context:NULL];
    [UIView setAnimationDuration:0.8];
    cell.layer.transform = CATransform3DIdentity;
    cell.alpha = 1;
    cell.layer.shadowOffset = CGSizeMake(0, 0);
    [UIView commitAnimations];
     */
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Selected: %d", indexPath.row);
}

//Spring Animation
//- (void)showAnimate
//{
//    self.view.transform = CGAffineTransformMakeScale(1.3, 1.3);
//    self.view.alpha = 0;
//    
//    [UIView animateWithDuration:0.75 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:10 options:UIViewAnimationOptionTransitionNone animations:^{
//        self.view.alpha = 1;
//        self.view.transform = CGAffineTransformMakeScale(1, 1);
//    }completion:nil];
//    
//    //[UIView animateWithDuration:.75 animations:^{
//      //  self.view.alpha = 1;
//      //  self.view.transform = CGAffineTransformMakeScale(1, 1);
//    //}];
//}
//
//- (void)removeAnimate
//{
//    
//    [UIView animateWithDuration:0.25 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:10 options:UIViewAnimationOptionTransitionNone animations:^{
//        self.view.transform = CGAffineTransformMakeScale(1.3, 1.3);
//        self.view.alpha = 0.0;
//    }completion:^(BOOL finished) {
//        if (finished)
//            [self.view removeFromSuperview];
//    }];
//
//}

- (void)close
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    
    UPLHomeViewController *homeController = (UPLHomeViewController*) self.presentingViewController;
    homeController.isComingFromCalendarView = TRUE;
    [homeController viewWillAppear:YES];
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
