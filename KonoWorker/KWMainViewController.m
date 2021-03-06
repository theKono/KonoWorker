//
//  KWMainViewController.m
//  KonoWorker
//
//  Created by kuokuo on 2017/11/28.
//  Copyright © 2017年 Kono. All rights reserved.
//

#import "KWMainViewController.h"
#import "KWAttendanceDataViewController.h"
#import "KWWorker.h"
#import "KWLocalDatabase.h"
#import "KWUtil.h"
#import <PINImageView+PINRemoteImage.h>

@interface KWMainViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UILabel *welcomeMsgLabel;
@property (weak, nonatomic) IBOutlet UIButton *attendanceRecordBtn;
@property (weak, nonatomic) IBOutlet UIButton *ptoBtn;

@property (weak, nonatomic) IBOutlet UIButton *workOutsideBtn;
@property (weak, nonatomic) IBOutlet UILabel *versionLabel;
@end

@implementation KWMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [KWUtil checkEnvironmentSetting:self];
    [self initLayout];
    
}

- (void)initLayout {
    
    KWWorker *currentWorker = [KWWorker worker];
    NSString *versionString = [[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString*)kCFBundleVersionKey];
    
    [self.profileImage pin_setImageFromURL:[NSURL URLWithString:currentWorker.userImageURLString]];
    self.welcomeMsgLabel.text = [NSString stringWithFormat:@"Hi! %@",currentWorker.userName];
    self.versionLabel.text = [NSString stringWithFormat:@"Current version: %@",versionString];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)attendanceRecordBtnPressed:(id)sender {
    
    UIStoryboard *storyboard;
    storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    
    KWAttendanceDataViewController *targetVC = [storyboard instantiateViewControllerWithIdentifier:@"KWAttendanceDataViewController"];
    
    [self.navigationController pushViewController:targetVC animated:YES];
    
}

- (IBAction)ptoBtnPressed:(id)sender {
    
    __weak typeof (self) weadSelf = self;
    
    KWWorker *currentWorker = [KWWorker worker];
    SCLAlertView *alert = [[SCLAlertView alloc] init];
    SCLTextView *startDate = [alert addTextField:@"YYYY/M/D"];
    startDate.text = [KWUtil getTodayDateString];
    startDate.keyboardType = UIKeyboardTypeDefault;
    
    SCLTextView *duration = [alert addTextField:@"0.5/1 Day?"];
    duration.keyboardType = UIKeyboardTypeDecimalPad;
    
    [alert addButton:@"Submit" validationBlock:^BOOL{
        if (startDate.text.length == 0) {
            [KWUtil showErrorAlert:weadSelf withErrorStr:@"Please enter the starting date~"];
            [startDate becomeFirstResponder];
            return NO;
        }
        
        if (duration.text.length == 0) {
            [KWUtil showErrorAlert:weadSelf withErrorStr:@"Please enter the duration of PTO time~"];
            [duration becomeFirstResponder];
            return NO;
        }
        if ( [KWUtil checkDateStringFormat:startDate.text] == NO ) {
            [KWUtil showErrorAlert:weadSelf withErrorStr:@"Please enter correct PTO starting time(YYYY/M/D)~"];
            [startDate becomeFirstResponder];
            return NO;
        }
        if ( [KWUtil checkDurationFormat:duration.text] == NO ) {
            [KWUtil showErrorAlert:weadSelf withErrorStr:@"Please enter correct duration of PTO time(0.5 day as an unit)~"];
            [duration becomeFirstResponder];
            return NO;
        }
        return YES;
    } actionBlock:^{
        NSInteger totalPTODurationInSec = [duration.text floatValue] * 86400;
        
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"yyyy/LL/dd"];
        [dateFormat setLocale:[[NSLocale alloc] initWithLocaleIdentifier: @"zh_TW"]];
        NSDate *PTOStartDate = [dateFormat dateFromString:startDate.text];
        
        while (totalPTODurationInSec >0) {
            NSInteger PTODurationInSec = (totalPTODurationInSec > 86400) ? 86400 : totalPTODurationInSec;
            
            [KWAttendanceRecord updateAttendanceRecordPTO:currentWorker.userID withDay:[KWUtil getDateStringWithDate:PTOStartDate] withDuration:PTODurationInSec];
            [currentWorker postPTORecord:[KWUtil getDateStringWithDate:PTOStartDate] withDuration:PTODurationInSec withComplete:^{
                [KWUtil showSuccessAlert:weadSelf withString:@"請假紀錄已送出，安心放假囉~"];
            } fail:^(NSError *error){
                [KWUtil showErrorAlert:weadSelf withErrorStr:@"請假紀錄未送至遠端，請聯絡工程師check!"];
            }];
            PTOStartDate = [PTOStartDate dateByAddingTimeInterval:86400];
            totalPTODurationInSec -= 86400;
        }
    }];
    [alert showInfo:self title:@"PTO" subTitle:@"Enter the date you want to PTO!" closeButtonTitle:@"Cancel" duration:0];
    
}

- (IBAction)workOutsideBtnPressed:(id)sender {
    
    __weak typeof (self) weadSelf = self;
    
    KWWorker *currentWorker = [KWWorker worker];
    SCLAlertView *alert = [[SCLAlertView alloc] init];
    SCLTextView *workLocation = [alert addTextField:@"Ex: Home"];
    workLocation.keyboardType = UIKeyboardTypeDefault;
    
    SCLTextView *startTime = [alert addTextField:@"08:00"];
    startTime.keyboardType = UIKeyboardTypeDefault;
    
    SCLTextView *endTime = [alert addTextField:@"16:00"];
    endTime.keyboardType = UIKeyboardTypeDefault;
    __weak typeof (alert) weakAlert = alert;
    [alert addButton:@"Submit" validationBlock:^BOOL{
        if (workLocation.text.length == 0) {
            [KWUtil showErrorAlert:weadSelf withErrorStr:@"Please enter the location you work~"];
            [weakAlert hideView];
            return NO;
        }
        
        if (startTime.text.length == 0) {
            [KWUtil showErrorAlert:weadSelf withErrorStr:@"Please enter the start time you work outside~"];
            [weakAlert hideView];
            return NO;
        }
        
        if (endTime.text.length == 0) {
            [KWUtil showErrorAlert:weadSelf withErrorStr:@"Please enter the end time you work outside~"];
            [weakAlert hideView];
            return NO;
        }
        
        return YES;
    } actionBlock:^{
    
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"yyyy/LL/dd HH:mm"];
        [dateFormat setLocale:[[NSLocale alloc] initWithLocaleIdentifier: @"zh_TW"]];
        NSString *workStartTime = [NSString stringWithFormat:@"%@ %@",[KWUtil getTodayDateString],startTime.text];
        NSString *workEndTime = [NSString stringWithFormat:@"%@ %@",[KWUtil getTodayDateString],endTime.text];
        NSDate *workStartDate = [dateFormat dateFromString:workStartTime];
        NSDate *workEndDate = [dateFormat dateFromString:workEndTime];
        
        BOOL isValidRecord = [KWAttendanceRecord updateAttendanceRecordWorkOutside:currentWorker.userID withDay:[KWUtil getTodayDateString] withLocation:workLocation.text withStartTime:workStartDate withEndTime:workEndDate];
        if (isValidRecord) {
            [currentWorker postWorkOutsideMessageToSlack:workLocation.text withStartTime:startTime.text withEndTime:endTime.text];
        }
        
    }];
    [alert setShouldDismissOnTapOutside:YES];
    [alert showInfo:self title:@"Work" subTitle:@"Enter the time you want to work outside!" closeButtonTitle:@"Cancel" duration:0];
}

@end
