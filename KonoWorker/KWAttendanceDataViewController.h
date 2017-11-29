//
//  KWAttendanceDataViewController.h
//  KonoWorker
//
//  Created by kuokuo on 2017/11/21.
//  Copyright © 2017年 Kono. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KWAttendanceDataViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end
