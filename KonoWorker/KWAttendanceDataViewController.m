//
//  KWAttendanceDataViewController.m
//  KonoWorker
//
//  Created by kuokuo on 2017/11/21.
//  Copyright © 2017年 Kono. All rights reserved.
//

#import "KWAttendanceDataViewController.h"
#import "KWAttendanceTableViewCell.h"
#import "KWLocalDatabase.h"
#import "KWWorker.h"

static NSString *cellIdentifier = @"cellIdentifier";

@interface KWAttendanceDataViewController ()

@property (strong,nonatomic) RLMResults *dataArray;


@end

@implementation KWAttendanceDataViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"Attendance Record";
    [self.tableView registerNib:[UINib nibWithNibName:@"KWAttendanceTableViewCell" bundle:nil] forCellReuseIdentifier:cellIdentifier];

    self.tableView.delegate = self;
    self.tableView.dataSource = self;

    
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    self.dataArray = [KWAttendanceRecord getAttendanceRecord:[KWWorker worker].userID];
    [self.tableView reloadData];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - table view delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSInteger recordCount = [self.dataArray count] ? [self.dataArray count] : 0;
    
    return recordCount;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    CGFloat cellHeight = 90;
    
    
    return cellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    KWAttendanceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    KWAttendanceRecord *record = [self.dataArray objectAtIndex:indexPath.row];
    KWAttendanceTableViewCell *displayCell = (KWAttendanceTableViewCell *)cell;
    
    if (record.isPTO == YES) {
        double PTODuration = record.duration / 86400.0;
        displayCell.backgroundColor = [UIColor colorWithRed:238/255.0 green:233/255.0 blue:224/255.0 alpha:1.0];
        
        displayCell.workDayLabel.text = [NSString stringWithFormat:@"%@  #PTO %.1lf day",record.workDate,PTODuration];
        displayCell.enterTimeLabel.text = @"Start time: N/A";
        displayCell.leaveTimeLabel.text = @"Leave time: N/A";
    }
    else {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateStyle:NSDateFormatterNoStyle];
        [formatter setTimeStyle:NSDateFormatterMediumStyle];
        
        NSString *startTime = [formatter stringFromDate:record.startTime];
        NSString *leaveTime = [formatter stringFromDate:record.leaveTime];
        
        displayCell.backgroundColor = [UIColor clearColor];
        
        displayCell.workDayLabel.text = record.workDate;
        displayCell.enterTimeLabel.text = [NSString stringWithFormat:@"Start time:%@",startTime];
        displayCell.leaveTimeLabel.text = [NSString stringWithFormat:@"Leave time:%@",leaveTime];
    }
}
@end
