//
//  KWAttendanceDataViewController.h
//  KonoWorker
//
//  Created by kuokuo on 2017/11/21.
//  Copyright © 2017年 Kono. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum KWAttendenceRecordSorting : NSUInteger{
    
    KWAttendenceRecordSortingDescending = 0,
    KWAttendenceRecordSortingAscending = 1
    
}KWAttendenceRecordSorting;

typedef enum KWAttendenceRecordFilter : NSUInteger{
    
    KWAttendenceRecordFilterNone = 0,
    KWAttendenceRecordFilterWorkDayOnly = 1,
    KWAttendenceRecordFilterPTOOnly = 2
    
}KWAttendenceRecordFilter;


@interface KWAttendanceDataViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end
