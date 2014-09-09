//
//  UPLExercisesViewController.m
//  Wake
//
//  Created by Alex Ryan on 7/13/14.
//  Copyright (c) 2014 U2PrideLabs. All rights reserved.
//

#import "UPLExercisesViewController.h"
#import "UPLExerciseCell.h"
#import "Exercise.h"
#import "ExerciseStore.h"
#import "UPLExerciseSummary.h"

const CGFloat kPaddingAmount = 22.0f;

@interface UPLExercisesViewController ()

@property (nonatomic, strong) UITableView *exerciseTableView;
@property (nonatomic, strong) UIToolbar *exerciseToolbar;

@property (nonatomic, strong) NSMutableArray *exercisesList;
@property (nonatomic, strong) UPLExerciseSummary *exerciseSummaryView;
@property (nonatomic, strong) ExerciseStore *exerciseStore;


@end

@implementation UPLExercisesViewController

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
    // Do any additional setup after loading the view.
    self.exerciseTableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    self.exerciseTableView.delegate = self;
    self.exerciseTableView.dataSource = self;
    self.exerciseTableView.rowHeight = 60;
    self.exerciseTableView.backgroundColor = [UIColor clearColor];
    self.exerciseTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.exerciseTableView.pagingEnabled = YES;
    //self.exerciseTableView.backgroundView.alpha = 0;
    [self.view addSubview:self.exerciseTableView];
    
    self.exercisesList = [[NSMutableArray alloc] init];
    self.exerciseStore = [[ExerciseStore alloc] init];
    
    Exercise *abs = [[Exercise alloc] initWithExerciseName:@"Abs" withNumReps:15 withNumSets:3];
    Exercise *back = [[Exercise alloc] initWithExerciseName:@"Back" withNumReps:10 withNumSets:3];
    Exercise *legs = [[Exercise alloc] initWithExerciseName:@"Legs" withNumReps:15 withNumSets:3];
    
    Exercise *abs2 = [[Exercise alloc] initWithExerciseName:@"Abs" withNumReps:15 withNumSets:3];
    Exercise *back2 = [[Exercise alloc] initWithExerciseName:@"Back" withNumReps:10 withNumSets:3];
    Exercise *legs2 = [[Exercise alloc] initWithExerciseName:@"Legs" withNumReps:15 withNumSets:3];
    
    Exercise *abs3 = [[Exercise alloc] initWithExerciseName:@"Abs" withNumReps:15 withNumSets:3];
    Exercise *back3 = [[Exercise alloc] initWithExerciseName:@"Back" withNumReps:10 withNumSets:3];
    Exercise *legs3 = [[Exercise alloc] initWithExerciseName:@"Legs" withNumReps:15 withNumSets:3];
    
    [self.exerciseStore addExercise:abs];
    [self.exerciseStore addExercise:back];
    [self.exerciseStore addExercise:legs];
    [self.exerciseStore addExercise:abs2];
    [self.exerciseStore addExercise:back2];
    [self.exerciseStore addExercise:legs2];
    [self.exerciseStore addExercise:abs3];
    [self.exerciseStore addExercise:back3];
    [self.exerciseStore addExercise:legs3];

    
    [self.exercisesList addObject:abs];
    [self.exercisesList addObject:back];
    [self.exercisesList addObject:legs];
    
    [self.exercisesList addObject:abs2];
    [self.exercisesList addObject:back2];
    [self.exercisesList addObject:legs2];
    
    [self.exercisesList addObject:abs3];
    [self.exercisesList addObject:back3];
    [self.exercisesList addObject:legs3];
    
    
    //Frames
    CGRect headerFrame = [UIScreen mainScreen].bounds;
    CGRect lineFrame = CGRectMake(kPaddingAmount, 70, self.view.frame.size.width - 40, 2);
    CGRect line2Frame = CGRectMake(0, 230, self.view.frame.size.width, 2);
    CGRect quoteFrame = CGRectMake(kPaddingAmount + 10, 115, self.view.frame.size.width - 60, 120);
    CGRect craigAlexanderPictureFrame = CGRectMake(200, 100, 100, 100);
    
    
    UIView *header = [[UIView alloc] initWithFrame:headerFrame];
    header.backgroundColor = [UIColor clearColor];
    self.exerciseTableView.tableHeaderView = header;
    
    UILabel *lineOne = [[UILabel alloc] initWithFrame:lineFrame];
    lineOne.backgroundColor = [UIColor whiteColor];
    [header addSubview:lineOne];
    
    UILabel *lineTwo = [[UILabel alloc] initWithFrame:line2Frame];
    lineTwo.backgroundColor = [UIColor whiteColor];
    [header addSubview:lineTwo];
    
    UIImageView *craigAlexanderPicture = [[UIImageView alloc] initWithFrame:craigAlexanderPictureFrame];
    craigAlexanderPicture.image = [UIImage imageNamed:@"CraigAlexander"];
    craigAlexanderPicture.center = CGPointMake(220, 70);
    [header addSubview:craigAlexanderPicture];
    
    
    //Frames
    CGRect firstNameFrame = CGRectMake(kPaddingAmount, 30, craigAlexanderPicture.frame.origin.x - kPaddingAmount, 50);
    CGRect lastNameFrame = CGRectMake(kPaddingAmount, 80, craigAlexanderPicture.frame.origin.x - kPaddingAmount, 30);
    
    
    UILabel *firstName = [[UILabel alloc] initWithFrame:firstNameFrame];
    firstName.text = @"Craig";
    firstName.textColor = [UIColor whiteColor];
    firstName.textAlignment = NSTextAlignmentCenter;
    firstName.font = [UIFont fontWithName:@"Zapfino" size:24];
    [header addSubview:firstName];
    
    UILabel *lastName = [[UILabel alloc] initWithFrame:lastNameFrame];
    lastName.text = @"Alexander";
    lastName.textColor = [UIColor whiteColor];
    lastName.textAlignment = NSTextAlignmentCenter;
    lastName.font = [UIFont fontWithName:@"Zapfino" size:18];
    [header addSubview:lastName];
    
    
    UILabel *quote = [[UILabel alloc] initWithFrame:quoteFrame];
    quote.textAlignment = NSTextAlignmentCenter;
    quote.textColor = [UIColor whiteColor];
    quote.text = @"\"At the end of the day, what gets my juices flowing is racing the best people when it's all on the line.\"";
    quote.numberOfLines = 0;
    quote.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:15];
    [header addSubview:quote];
    
    //TODO:  Height of the frame programmatically
    self.exerciseSummaryView = [[UPLExerciseSummary alloc] initWithFrame:CGRectMake(0, 230, self.view.frame.size.width, 340)];
    [header addSubview:self.exerciseSummaryView];
    
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addNewExercise)];
    [self.exerciseSummaryView addGestureRecognizer:tapGesture];
    
}


//- (void)drawRect: (CGRect)drawingRect
//{
//    /*
//    CGContextRef ctx = UIGraphicsGetCurrentContext();
//    
//    CGContextBeginPath(ctx);
//    CGContextMoveToPoint(ctx, 20.0f, 30.0f);
//    CGContextAddLineToPoint(ctx, 120.0f, 280.0f);
//    CGContextSetLineWidth(ctx, 5.0);
//    CGContextSetRGBStrokeColor(ctx, 0, 120, 0, 1.0);
//    CGContextClosePath(ctx);
//    
//    CGContextStrokePath(ctx);
//    */
//    
//    CGPoint center = CGPointMake(self.view.frame.size.width / 2.0, self.view.frame.size.height / 2.0);
//    float rectangleWidth = 100.0;
//    float rectangleHeight = 100.0;
//    
//    CGContextRef ctx = UIGraphicsGetCurrentContext();
//    
//    //4
//    CGContextAddRect(ctx, CGRectMake(center.x - (0.5 * rectangleWidth), center.y - (0.5 * rectangleHeight), rectangleWidth, rectangleHeight));
//    CGContextSetLineWidth(ctx, 10);
//    CGContextSetStrokeColorWithColor(ctx, [[UIColor grayColor] CGColor]);
//    CGContextStrokePath(ctx);
//    
//    //5
//    CGContextSetFillColorWithColor(ctx, [[UIColor greenColor] CGColor]);
//    CGContextAddRect(ctx, CGRectMake(center.x - (0.5 * rectangleWidth), center.y - (0.5 * rectangleHeight), rectangleWidth, rectangleHeight));
//    CGContextFillPath(ctx);
//    
//    
//}




- (void)viewWillAppear:(BOOL)animated
{
//    [super viewWillAppear:animated];
//    UIToolbar *toolbar = [[UIToolbar alloc] init];
//    toolbar.frame = CGRectMake(0, 0, 300, 44);
//    UIBarButtonItem *button1 = [[UIBarButtonItem alloc] initWithTitle:@"Send" style:UIBarButtonItemStyleDone target:self action:@selector(sendAction)];
//    
//    UIBarButtonItem *button2=[[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStyleDone target:self action:@selector(cancelAction)];
//    
//    [toolbar setItems:[[NSArray alloc] initWithObjects:button1,button2, nil]];
//    [self.view addSubview:toolbar];

    //self.exerciseToolbar.barTintColor = [UIColor clearColor];
    //self.exerciseToolbar.barStyle = UIBarStyleBlack;
    //[self.exerciseToolbar setTranslucent:YES];
    
    
    // Code for botttom toolbar...
    
//    self.exerciseToolbar = [[UIToolbar alloc] init];
//    self.exerciseToolbar.frame = CGRectMake(0, self.view.frame.size.height - 44, self.view.frame.size.width, 44);
//    self.exerciseToolbar.backgroundColor = [UIColor clearColor];
//    
//    [self.exerciseToolbar setBackgroundImage:[[UIImage alloc] init] forToolbarPosition:UIToolbarPositionAny barMetrics:UIBarMetricsDefault];
//
//    UIBarButtonItem *addExerciseBarItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addNewExercise)];
//    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
//    
//    self.exerciseToolbar.items = @[flexibleSpace, addExerciseBarItem, flexibleSpace];
//    [self.view addSubview:self.exerciseToolbar];
    
}


- (void)addNewExercise
{
    int randomNum = arc4random() % 170;
    [self.exerciseSummaryView setBarOneValue:170 animated:YES];
    [self.exerciseSummaryView setBarTwoValue:160 animated:YES];
    [self.exerciseSummaryView setBarThreeValue:randomNum animated:YES];
}




#pragma mark - UITableViewDataSource Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //NSLog(@"Number of Exercises: %i", self.exercisesList.count);
    //return self.exercisesList.count;
    
    NSLog(@"Number of Exercises: %i", [self.exerciseStore allExercises].count);
    return [self.exerciseStore allExercises].count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reuseID = @"ExerciseCell";
    UPLExerciseCell *newCell = (UPLExerciseCell *)[tableView dequeueReusableCellWithIdentifier:reuseID];
    
    if (newCell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ExerciseTableCell" owner:self options:nil];
        newCell = [nib objectAtIndex:0];
    }
    
    //Exercise *currentExercise = [self.exercisesList objectAtIndex:indexPath.row];
    Exercise *currentExercise = [[self.exerciseStore allExercises] objectAtIndex:indexPath.row];
    
    newCell.priorityColor.backgroundColor = [UIColor blueColor];
    newCell.exerciseTitle.text = currentExercise.exerciseName;
    newCell.numSets.text = [NSString stringWithFormat:@"%i", currentExercise.numOfSets];
    newCell.numReps.text = [NSString stringWithFormat:@"%i", currentExercise.numOfReps];
    newCell.backgroundColor = [UIColor clearColor];
    
    //Removing Selected State Change
    UIView *cellSelectedBackgroundView = [[UIView alloc] initWithFrame:newCell.frame];
    cellSelectedBackgroundView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:256 alpha:0.05];
    newCell.selectedBackgroundView = cellSelectedBackgroundView;

    return newCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}



#pragma mark - UITableViewDelegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"selected: %d", indexPath.row);
    
    UPLExerciseCell *cell = (UPLExerciseCell *)[tableView cellForRowAtIndexPath:indexPath];
    
    //Exercise *currentExercise = [self.exercisesList objectAtIndex:indexPath.row];
    Exercise *currentExercise = [[self.exerciseStore allExercises] objectAtIndex:indexPath.row];
    
    //Write the logic for decrementing sets inside the Exercise Class.
    [self.exerciseStore decrementNumRepsForExercise:currentExercise];
    cell.numReps.text = [NSString stringWithFormat:@"%i", currentExercise.currentNumOfReps];
    cell.numSets.text = [NSString stringWithFormat:@"%i", currentExercise.currentNumOfSets];
}

#pragma mark - Common Methods

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
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
