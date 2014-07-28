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

@interface UPLExercisesViewController ()

@property (nonatomic, strong) UITableView *exerciseTableView;
@property (nonatomic, strong) UIToolbar *exerciseToolbar;

@property (nonatomic, strong) NSMutableArray *exercisesList;


@end

@implementation UPLExercisesViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.exerciseTableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
        self.exerciseTableView.delegate = self;
        self.exerciseTableView.dataSource = self;
        self.exerciseTableView.rowHeight = 60;
        self.exerciseTableView.backgroundColor = [UIColor clearColor];
        self.exerciseTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        //self.exerciseTableView.backgroundView.alpha = 0;
        [self.view addSubview:self.exerciseTableView];
        
        self.exercisesList = [[NSMutableArray alloc] init];
        
        Exercise *abs = [[Exercise alloc] initWithExerciseName:@"Abs" withNumReps:15 withNumSets:3];
        Exercise *back = [[Exercise alloc] initWithExerciseName:@"Back" withNumReps:10 withNumSets:3];
        Exercise *legs = [[Exercise alloc] initWithExerciseName:@"Legs" withNumReps:15 withNumSets:3];
        
        [self.exercisesList addObject:abs];
        [self.exercisesList addObject:back];
        [self.exercisesList addObject:legs];
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    


    
}

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

    self.exerciseToolbar = [[UIToolbar alloc] init];
    self.exerciseToolbar.frame = CGRectMake(0, self.view.frame.size.height - 44, self.view.frame.size.width, 44);
    self.exerciseToolbar.backgroundColor = [UIColor clearColor];
    //self.exerciseToolbar.barTintColor = [UIColor clearColor];
    //self.exerciseToolbar.barStyle = UIBarStyleBlack;
    //[self.exerciseToolbar setTranslucent:YES];
    
    [self.exerciseToolbar setBackgroundImage:[[UIImage alloc] init] forToolbarPosition:UIToolbarPositionAny barMetrics:UIBarMetricsDefault];

    UIBarButtonItem *addExerciseBarItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addNewExercise)];
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    self.exerciseToolbar.items = @[flexibleSpace, addExerciseBarItem, flexibleSpace];
    [self.view addSubview:self.exerciseToolbar];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"Number of Exercises: %i", self.exercisesList.count);
    return self.exercisesList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reuseID = @"ExerciseCell";
    UPLExerciseCell *newCell = (UPLExerciseCell *)[tableView dequeueReusableCellWithIdentifier:reuseID];
    
    if (newCell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ExerciseTableCell" owner:self options:nil];
        newCell = [nib objectAtIndex:0];
    }
    
    Exercise *currentExercise = [self.exercisesList objectAtIndex:indexPath.row];
    
    newCell.priorityColor.backgroundColor = [UIColor blueColor];
    newCell.exerciseTitle.text = currentExercise.exerciseName;
    newCell.numSets.text = [NSString stringWithFormat:@"%i", currentExercise.numOfSets];
    newCell.numReps.text = [NSString stringWithFormat:@"%i", currentExercise.numOfReps];
    newCell.backgroundColor = [UIColor clearColor];

    return newCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

- (void)addNewExercise {
    
}

#pragma mark - UITableViewDelegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"selected: %d", indexPath.row);
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
