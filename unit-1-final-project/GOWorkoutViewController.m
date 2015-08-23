//
//  GOWorkoutViewController.m
//  unit-1-final-project
//
//  Created by Fatima Zenine Villanueva on 8/22/15.
//  Copyright © 2015 apps. All rights reserved.
//

#import "GOWorkoutViewController.h"
#import "WorkoutManager.h"
#import "Workout.h"

@interface GOWorkoutViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) Workout *model;

@end

@implementation GOWorkoutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




// The TABLE

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [WorkoutManager sharedManager].workouts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"workoutIdentifier" forIndexPath:indexPath];
    
    NSMutableArray *workouts = [WorkoutManager sharedManager].workouts;
    Workout *workout = workouts[indexPath.row];
    //Exercises *exercise = [workout.exercises lastObject];
    cell.textLabel.text = workout.workoutName;
    return cell;
}



@end