//
//1. create bool is running so Start button can be touched once
//2. hide reset button so can only be pressed when stopped
//3. create bool for Lap button so cannot be pressed while paused
//
//GOStopwatchViewController.m
//  unit-1-final-project
//
//  Created by Jamaal Sedayao on 8/21/15.
//  Copyright © 2015 apps. All rights reserved.
//

#import "GOStopwatchViewController.h"
#import "LapTimerTableViewCell.h"
#import "BackgroundGradient.h"

@interface GOStopwatchViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic) NSMutableArray *laps;
@property (nonatomic) NSMutableArray *numberOfLaps;
@property (nonatomic) NSInteger lapNumber;
@property (nonatomic, retain) NSDate* start;
@property (nonatomic) NSDate *mainDate;
@property (nonatomic) NSTimer *stopwatch;
@property (nonatomic) BOOL isRunning;
@property (nonatomic) BOOL isPause;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *stopwatchTimerLabel;
@property (nonatomic) NSTimer *mainStopwatch;
@property (weak, nonatomic) IBOutlet UILabel *mainStopwatchLabel;
@property (nonatomic, assign) NSTimeInterval pauseTime;

@property (weak, nonatomic) IBOutlet UIButton *startButton;
@property (weak, nonatomic) IBOutlet UIButton *stopButton;
@property (weak, nonatomic) IBOutlet UIButton *lapButton;
@property (weak, nonatomic) IBOutlet UIButton *resetButton;


@property (nonatomic) float mainTotalTime;
@property (nonatomic) float lapTotalTime;
@property (nonatomic) NSDate *mainPreviousTime;
@property (nonatomic,retain) NSDate *lapPreviousTime;



@end

@implementation GOStopwatchViewController

- (void)viewDidLoad {
    
    self.title = @"Go Stopwatch";
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor clearColor];
    
    [super viewDidLoad];
    
    self.laps = [[NSMutableArray alloc]init];
    
    self.start = [[NSDate alloc]init];
    
    self.numberOfLaps = [[NSMutableArray alloc]init];
    
    self.resetButton.hidden = YES;
    self.stopButton.hidden = YES;
    
    self.lapButton.userInteractionEnabled = NO;
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    CAGradientLayer *bgLayer = [BackgroundGradient greenGradient];
    bgLayer.frame = self.view.bounds;
    [self.view.layer insertSublayer:bgLayer atIndex:0];
}

- (IBAction)startStopwatchButton:(UIButton *)sender {
    
    self.startButton.hidden = YES;
    self.stopButton.hidden = NO;
    self.resetButton.hidden = YES;
    self.lapButton.hidden = NO;
    
    self.stopwatch = [NSTimer scheduledTimerWithTimeInterval:1.0/100.0
                                                      target:self
                                                    selector:@selector(updateStopwatchTimer)
                                                    userInfo:nil repeats:YES];
    
    self.mainStopwatch = [NSTimer scheduledTimerWithTimeInterval:1.0/100.0
                                                          target:self
                                                        selector:@selector(updateMainStopwatchTimer)
                                                        userInfo:nil repeats:YES];
    
    self.mainPreviousTime = [[NSDate alloc] init];
    self.lapPreviousTime = [[NSDate alloc] init];
    
    self.lapButton.userInteractionEnabled = YES;
    
}

-(void) updateMainStopwatchTimer {
    
    NSDate *currentTime = [[NSDate alloc] init];
    
    NSTimeInterval elapsedTime = [currentTime timeIntervalSinceDate: self.mainPreviousTime];
    self.mainPreviousTime = currentTime;

    self.mainTotalTime += elapsedTime;
    
    NSDate *timeDate = [NSDate dateWithTimeIntervalSince1970:self.mainTotalTime];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"mm : ss : SS"];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0.0]];
    NSString *timeString = [dateFormatter stringFromDate:timeDate];
    self.mainStopwatchLabel.text = timeString;
    
    
    NSLog(@"%f", self.mainTotalTime);
}

- (void) updateStopwatchTimer {
    NSDate *currentTime = [NSDate date];
    NSTimeInterval elapsedTime = [currentTime timeIntervalSinceDate:self.lapPreviousTime];
    self.lapPreviousTime = currentTime;
    
    self.lapTotalTime += elapsedTime;
    
    NSDate *timeDate = [NSDate dateWithTimeIntervalSince1970:self.lapTotalTime];
   
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"mm : ss : SS"];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0.0]];
    NSString *timeString = [dateFormatter stringFromDate:timeDate];
    self.stopwatchTimerLabel.text = timeString;
}


- (IBAction)stopStopwatchButton:(UIButton *)sender {
    
    self.stopButton.hidden = YES;
    self.lapButton.hidden = YES;
    self.startButton.hidden = NO;
    self.resetButton.hidden = NO;
    
    [self.mainStopwatch invalidate];
    [self.stopwatch invalidate];
}

- (IBAction)lapStopwatchButton:(UIButton *)sender {
    self.lapTotalTime = 0.0;
    
    [self.laps addObject:self.stopwatchTimerLabel.text];
    
    [self.tableView reloadData];
    
    
    NSIndexPath* ipath = [NSIndexPath indexPathForRow:[self.laps count]-1 inSection:0];
    [self.tableView scrollToRowAtIndexPath:ipath atScrollPosition: UITableViewScrollPositionTop animated: YES];
    
    self.lapNumber = ipath.row + 1;
    
    [self.numberOfLaps addObject: [NSNumber numberWithInteger:self.lapNumber]];
}
- (IBAction)resetStopwatchButton:(UIButton *)sender {
    
    self.resetButton.hidden = YES;
    self.lapButton.hidden = NO;
    self.startButton.hidden = NO;
    self.stopButton.hidden = YES;
    
    self.lapButton.userInteractionEnabled = NO;
   
    [self.mainStopwatch invalidate];
    [self.stopwatch invalidate];
    
    self.lapTotalTime = 0;
    self.mainTotalTime = 0;
    
    self.mainStopwatchLabel.text = @"00 : 00 : 00";
    self.stopwatchTimerLabel.text = @"00 : 00 : 00";
    
    [self.laps removeAllObjects];
    [self.numberOfLaps removeAllObjects];
    
    [self.tableView reloadData];

    //[self stopStopwatchButton:sender];
}


// UI TABLE VIEW

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.laps.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TimeLap" forIndexPath:indexPath];
    
   if (!cell) {
   cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TimeLap"];
    }
   
    NSString *key = [self.laps objectAtIndex:indexPath.row];
    NSString *lap = [self.numberOfLaps objectAtIndex:indexPath.row];

    cell.detailTextLabel.text = key;
    cell.textLabel.text = [NSString stringWithFormat:@"Lap %@",lap];
    cell.backgroundColor = [UIColor clearColor];
    
    return cell;
}




@end
