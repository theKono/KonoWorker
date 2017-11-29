//
//  KWAttendanceTableViewCell.h
//  KonoWorker
//
//  Created by kuokuo on 2017/11/27.
//  Copyright © 2017年 Kono. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KWAttendanceTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *workDayLabel;
@property (weak, nonatomic) IBOutlet UILabel *enterTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *leaveTimeLabel;
@end
