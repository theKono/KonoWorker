//
//  KWUtil.h
//  KonoWorker
//
//  Created by kuokuo on 2017/11/23.
//  Copyright © 2017年 Kono. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SCLAlertView.h"
#import <CoreLocation/CoreLocation.h>
#import <CoreBluetooth/CoreBluetooth.h>

typedef enum KWRequireSettingStatus : NSUInteger{
    KWRequireSettingStatusCorrect = 0,
    KWRequireSettingStatusErrorBackgroundDenied = 1,
    KWRequireSettingStatusErrorBackgroundRestricted = 2,
    KWRequireSettingStatusErrorLocationUnauthorized = 3
    
}KWRequireSettingStatus;


@interface KWUtil : NSObject

+ (void)showErrorAlert:(UIViewController *)presentViewController withErrorStr:(NSString *)errorDescription;

+ (void)showSuccessAlert:(UIViewController *)presentViewController withString:(NSString *)feedbackString;

+ (BOOL)checkDateStringFormat:(NSString *)dateString;

+ (BOOL)checkDurationFormat:(NSString *)durationString;

+ (void)checkEnvironmentSetting:(UIViewController *)presentViewController;

+ (NSString *)getTodayDateString;

+ (NSString *)getDateStringWithDate:(NSDate *)date;
@end
