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
#import "KWUIComponent.h"

static NSString *cellIdentifier = @"cellIdentifier";

@interface KWAttendanceDataViewController ()

@property (strong,nonatomic) RLMResults *dataArray;
@property (nonatomic) KWAttendenceRecordSorting sortingMethod;
@property (nonatomic) KWAttendenceRecordFilter filterMethod;

@end

@implementation KWAttendanceDataViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.tableView registerNib:[UINib nibWithNibName:@"KWAttendanceTableViewCell" bundle:nil] forCellReuseIdentifier:cellIdentifier];

    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.allowsSelection = NO;
    [self setupNavigationBar];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self refreshContent];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupNavigationBar {
    
    self.navigationItem.rightBarButtonItems = @[[KWUIComponent navigationSortBtn:self withSelector:@selector(sortBtnPressed:)],[KWUIComponent navigationFilterBtn:self withSelector:@selector(filterBtnPressed:)]];
    
}

- (void)setNavigationTitle {
    
    NSString *title;
    
    switch (self.filterMethod) {
        case KWAttendenceRecordFilterNone:
            title = [NSString stringWithFormat:@"All Records (%lu)",(unsigned long)[self.dataArray count]];
            break;
        case KWAttendenceRecordFilterPTOOnly:
            title = [NSString stringWithFormat:@"PTO Records (%lu)",(unsigned long)[self.dataArray count]];
            break;
        case KWAttendenceRecordFilterWorkDayOnly:
            title = [NSString stringWithFormat:@"Work Records (%lu)",(unsigned long)[self.dataArray count]];
            break;
        default:
            break;
    }
    self.navigationItem.title = title;
}

- (void)refreshContent {
    
    self.dataArray = [self fetchRecord];
    [self setNavigationTitle];
    [self.tableView reloadData];
}

- (RLMResults *)fetchRecord {
    
    RLMResults *allRecords = [KWAttendanceRecord getAttendanceRecord:[KWWorker worker].userID];
    NSPredicate *filterPredicate;
    
    if (self.filterMethod != KWAttendenceRecordFilterNone) {
        switch (self.filterMethod) {
            case KWAttendenceRecordFilterPTOOnly:
                filterPredicate = [NSPredicate predicateWithFormat:@"isPTO == YES"];
                break;
            case KWAttendenceRecordFilterWorkDayOnly:
                filterPredicate = [NSPredicate predicateWithFormat:@"isPTO == NO"];
                break;
            default:
                break;
        }
        allRecords = [allRecords objectsWithPredicate:filterPredicate];
    }
    
    allRecords = [allRecords sortedResultsUsingKeyPath:@"workDate" ascending:self.sortingMethod];
    return allRecords;
    
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
        
        if (record.isWorkOutside == YES) {
            displayCell.backgroundColor = [UIColor colorWithRed:246/255.0 green:243/255.0 blue:237/255.0 alpha:1.0];
        }
        else {
            displayCell.backgroundColor = [UIColor clearColor];
        }
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateStyle:NSDateFormatterNoStyle];
        [formatter setTimeStyle:NSDateFormatterMediumStyle];
        
        NSString *startTime = [formatter stringFromDate:record.startTime];
        NSString *leaveTime = [formatter stringFromDate:record.leaveTime];
        
        displayCell.workDayLabel.text = [NSString stringWithFormat:@"%@ work at %@", record.workDate,record.workLocation];
        displayCell.enterTimeLabel.text = [NSString stringWithFormat:@"Start time:%@",startTime];
        displayCell.leaveTimeLabel.text = [NSString stringWithFormat:@"Leave time:%@",leaveTime];
    }
}

#pragma mark - navigation bar button handle function

- (void)sortBtnPressed:(id)sendder{
    
    NSString *alertTitle = @"顯示方式";
    
    NSString *cancelTitle = @"取消";
    NSString *sortByTimeAsendingTitle = @"時間較遠在前";
    NSString *sortByTimeDescendingTitle = @"時間較近在前";
    
    UIAlertControllerStyle style = UIAlertControllerStyleActionSheet;
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:alertTitle message:nil preferredStyle:style];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelTitle style:UIAlertActionStyleCancel handler:nil];
    
    
    UIAlertAction *byTimeAsendingAction = [UIAlertAction actionWithTitle:sortByTimeAsendingTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        self.sortingMethod = KWAttendenceRecordSortingAscending;
        [self refreshContent];
        
    }];
    
    UIAlertAction *byTimeDescendingAction = [UIAlertAction actionWithTitle:sortByTimeDescendingTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        self.sortingMethod = KWAttendenceRecordSortingDescending;
        [self refreshContent];
        
    }];
    
    [alertController addAction:cancelAction];
    [alertController addAction:byTimeAsendingAction];
    [alertController addAction:byTimeDescendingAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)filterBtnPressed:(id)sendder{
    
    NSString *alertTitle = @"顯示內容";
    
    NSString *allTitle = @"所有";
    NSString *showWorkDayTitle = @"只顯示上班紀錄";
    NSString *showPTOTitle = @"只顯示請假紀錄";
    
    UIAlertControllerStyle style = UIAlertControllerStyleActionSheet;
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:alertTitle message:nil preferredStyle:style];
    
    UIAlertAction *showAllAction = [UIAlertAction actionWithTitle:allTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        self.filterMethod = KWAttendenceRecordFilterNone;
        [self refreshContent];
        
    }];
    
    UIAlertAction *showWorkDayAction = [UIAlertAction actionWithTitle:showWorkDayTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        self.filterMethod = KWAttendenceRecordFilterWorkDayOnly;
        [self refreshContent];
        
    }];
    
    UIAlertAction *showPTOAction = [UIAlertAction actionWithTitle:showPTOTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.filterMethod = KWAttendenceRecordFilterPTOOnly;
        [self refreshContent];
    }];
    
    [alertController addAction:showAllAction];
    [alertController addAction:showWorkDayAction];
    [alertController addAction:showPTOAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

@end
