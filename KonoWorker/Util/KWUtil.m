//
//  KWUtil.m
//  KonoWorker
//
//  Created by kuokuo on 2017/11/23.
//  Copyright © 2017年 Kono. All rights reserved.
//

#import "KWUtil.h"

@implementation KWPickViewField

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    
    self = [super initWithCoder:aDecoder];
    if (self) {
        
        UIImageView *rightView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 22, 22)];
        [rightView setImage:[UIImage imageNamed:@"btn_dropdown"]];
        
        [self setRightView:rightView];
        
        [self setRightViewMode:UITextFieldViewModeAlways];
        
        UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 15, 22)];
        self.leftView = paddingView;
        self.leftViewMode = UITextFieldViewModeAlways;
        
        self.layer.cornerRadius = 5.0;
        
        self.layer.borderColor = [[UIColor colorWithRed:212/255.0 green:207/255.0 blue:193/255.0 alpha:1.0] CGColor];
        self.layer.borderWidth = 1.0;
        
        self.backgroundColor = [UIColor whiteColor];
        
    }
    
    return self;
}




- (CGRect) caretRectForPosition:(UITextPosition*) position{
    
    return CGRectZero;
}

- (NSArray *)selectionRectsForRange:(UITextRange *)range{
    
    return nil;
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender{
    
    if (action == @selector(copy:) || action == @selector(selectAll:) || action == @selector(paste:)){
        
        return NO;
    }
    
    return [super canPerformAction:action withSender:sender];
}


@end


@implementation KWUtil

+ (void)showErrorAlert:(UIViewController *)presentViewController withErrorStr:(NSString *)errorDescription {
    
    SCLAlertView *alert = [[SCLAlertView alloc] init];
    
    [alert showWarning:presentViewController title:@"Oops" subTitle:errorDescription closeButtonTitle:@"Done" duration:0.0f];
}

+ (void)showSuccessAlert:(UIViewController *)presentViewController withString:(NSString *)feedbackString {
    
    SCLAlertView *alert = [[SCLAlertView alloc] init];
    
    [alert showSuccess:presentViewController title:@"Congratulations" subTitle:feedbackString closeButtonTitle:@"Got it!" duration:0.0f];
}

+ (BOOL)checkDateStringFormat:(NSString *)dateString {
    
    BOOL isValid = NO;
    NSString *todayString = [self getTodayDateString];
    NSArray *timeInfo = [dateString componentsSeparatedByString:@"/"];
    NSArray *currentTimeInfo = [todayString componentsSeparatedByString:@"/"];
    
    if ( labs([timeInfo[0] integerValue] - [currentTimeInfo[0] integerValue]) <= 1 ) {
        
        if ( [timeInfo[1] integerValue] > 0 && [timeInfo[1] integerValue] < 13 ) {
            
            if ( [timeInfo[2] integerValue] > 0 && [timeInfo[2] integerValue] < 31) {
                if ( [timeInfo[0] characterAtIndex:0] != '0' &&
                     [timeInfo[1] characterAtIndex:0] != '0' &&
                     [timeInfo[2] characterAtIndex:0] != '0') {
                    isValid = YES;
                }
            }
        }
    }
    
    return isValid;
}

+ (BOOL)checkDurationFormat:(NSString *)durationString {
    
    BOOL isValid = NO;
    NSInteger duration = [durationString floatValue] * 10;
    
    if (duration > 0 && (duration % 5) == 0) {
        isValid = YES;
    }
    
    return isValid;
}

+ (void)checkEnvironmentSetting:(UIViewController *)presentViewController {
    
    SCLAlertView *alert = [[SCLAlertView alloc] init];
    
    KWRequireSettingStatus backgroundFetchSettingStatus = [KWUtil checkBackgroundFetch];
    KWRequireSettingStatus locationAuthorizedStatus = [KWUtil checkLocationAuthorized];
    
    if ( backgroundFetchSettingStatus == KWRequireSettingStatusCorrect &&
        locationAuthorizedStatus == KWRequireSettingStatusCorrect) {
        
        [alert showSuccess:presentViewController title:@"Great" subTitle:@"Your environment setting is correct." closeButtonTitle:@"Done" duration:0.0f];
    }
    else {
        NSMutableString *errorDescription = [NSMutableString new];

        if ( backgroundFetchSettingStatus != KWRequireSettingStatusCorrect ) {
            [errorDescription appendString:[KWUtil getErrorDescription:backgroundFetchSettingStatus]];
        }
        if ( locationAuthorizedStatus != KWRequireSettingStatusCorrect ) {
            [errorDescription appendString:[KWUtil getErrorDescription:locationAuthorizedStatus]];
        }
        
        [alert showWarning:presentViewController title:@"Oops" subTitle:errorDescription closeButtonTitle:@"Done" duration:0.0f];
    }
}

+ (KWRequireSettingStatus)checkBackgroundFetch {
    
    KWRequireSettingStatus backgroundFetchSettingStatus = NO;
    
    if ([[UIApplication sharedApplication] backgroundRefreshStatus] == UIBackgroundRefreshStatusAvailable) {
        backgroundFetchSettingStatus = KWRequireSettingStatusCorrect;
    }
    else if([[UIApplication sharedApplication] backgroundRefreshStatus] == UIBackgroundRefreshStatusDenied) {
        backgroundFetchSettingStatus = KWRequireSettingStatusErrorBackgroundDenied;
    }
    else if([[UIApplication sharedApplication] backgroundRefreshStatus] == UIBackgroundRefreshStatusRestricted) {
        backgroundFetchSettingStatus = KWRequireSettingStatusErrorBackgroundRestricted;
    }
    
    return backgroundFetchSettingStatus;
}


+ (KWRequireSettingStatus)checkLocationAuthorized {
    
    KWRequireSettingStatus locationAuthorizedStatus;
    
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedAlways) {
        locationAuthorizedStatus = KWRequireSettingStatusCorrect;
    }
    else {
        locationAuthorizedStatus = KWRequireSettingStatusErrorLocationUnauthorized;
    }
    
    return locationAuthorizedStatus;
    
}


+ (NSString *)getErrorDescription:(KWRequireSettingStatus)status{
    
    NSString *errorDescription;
    switch (status) {
        case KWRequireSettingStatusErrorBackgroundDenied:
            errorDescription = @"You deny our app to run in background.\n";
            break;
        case KWRequireSettingStatusErrorBackgroundRestricted:
            errorDescription = @"You device configuration deny our app to run in background.\n";
            break;
        case KWRequireSettingStatusErrorLocationUnauthorized:
            errorDescription = @"We need location authorization for sensing iBeacon.";
            break;
            
        default:
            break;
    }
    return errorDescription;
    
}

+ (NSString *)getTodayDateString {
    
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateFormat:@"YYYY/M/d"];
    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier: @"zh_TW"]];
    NSString *workDay = [dateFormatter stringFromDate:[NSDate date]];
    
    return workDay;
}

+ (NSString *)getDateStringWithDate:(NSDate *)date {
    
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateFormat:@"YYYY/M/d"];
    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier: @"zh_TW"]];
    NSString *workDay = [dateFormatter stringFromDate:date];
    
    return workDay;
}

@end
