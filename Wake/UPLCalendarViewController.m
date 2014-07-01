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


@interface UPLCalendarViewController ()

@end

@implementation UPLCalendarViewController

@synthesize calendarEvents, calendarTableView;

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
    
    UILabel *calendarHeader = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, screenWidth - 40, 60)];
    calendarHeader.textColor = [UIColor whiteColor];
    calendarHeader.text = @"Calendar";
    calendarHeader.font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:50];
    [self.view addSubview:calendarHeader];
    
    
    UIButton *closeButton = [[UIButton alloc] initWithFrame:CGRectMake(screenWidth - 100, 30, 100, 30)];
    [closeButton setTitle:@"X" forState:UIControlStateNormal];
    [closeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    closeButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:40];
    [self.view addSubview:closeButton];
    
    [closeButton addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
    
    
    //[self showAnimate];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"%d", calendarEvents.count);
    return self.calendarEvents.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Inside Tableivew: %d", indexPath.row);
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    
    EKEvent *event = [calendarEvents objectAtIndex:indexPath.row];
    
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Selected: %d", indexPath.row);
}

//Spring Animation
- (void)showAnimate
{
    self.view.transform = CGAffineTransformMakeScale(1.3, 1.3);
    self.view.alpha = 0;
    
    [UIView animateWithDuration:0.75 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:10 options:UIViewAnimationOptionTransitionNone animations:^{
        self.view.alpha = 1;
        self.view.transform = CGAffineTransformMakeScale(1, 1);
    }completion:nil];
    
    //[UIView animateWithDuration:.75 animations:^{
      //  self.view.alpha = 1;
      //  self.view.transform = CGAffineTransformMakeScale(1, 1);
    //}];
}

- (void)removeAnimate
{
    
    [UIView animateWithDuration:0.25 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:10 options:UIViewAnimationOptionTransitionNone animations:^{
        self.view.transform = CGAffineTransformMakeScale(1.3, 1.3);
        self.view.alpha = 0.0;
    }completion:^(BOOL finished) {
        if (finished)
            [self.view removeFromSuperview];
    }];

}

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
