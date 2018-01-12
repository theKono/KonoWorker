//
//  KWWorker.m
//  KonoWorker
//
//  Created by kuokuo on 2017/11/28.
//  Copyright © 2017年 Kono. All rights reserved.
//

#import "KWWorker.h"
#import "KWUtil.h"
#import "KWNetworkManager.h"

@interface KWWorker ()

@property (nonatomic, strong) AFHTTPSessionManager *manager;

@end


@implementation KWWorker

@synthesize userDefault = _userDefault;
@synthesize manager = _manager;

+ (KWWorker *)worker{
    static dispatch_once_t pred;
    static KWWorker *obj = nil;
    
    dispatch_once(&pred, ^{
        obj = [[KWWorker alloc]init];
    });
    
    return obj;
}

- (void)setUserDefault:(NSUserDefaults *)userDefault{
    _userDefault = userDefault;
}


- (NSUserDefaults *)userDefault{
    
    if( !_userDefault ){
        _userDefault = [NSUserDefaults standardUserDefaults];
    }
    return _userDefault;
}

- (void)setManager:(AFHTTPSessionManager *)manager{
    
    _manager = manager;
    
}


- (AFHTTPSessionManager *)manager{
    
    if( !_manager ){
        _manager = [KWNetworkManager sharedManager].httpSessionManager;
    }
    return _manager;
}


- (void)setUserID:(NSString *)userID {
    
    [self.userDefault setObject:userID forKey:@"KWUserID"];
    [self.userDefault synchronize];
    
}

- (NSString *)userID{
    
    NSString *defaultUserID = [self.userDefault objectForKey:@"KWUserID"];
    return defaultUserID;
    
}

- (void)setUserName:(NSString *)userName {
    
    [self.userDefault setObject:userName forKey:@"KWUserName"];
    [self.userDefault synchronize];
    
}

- (NSString *)userName{
    
    NSString *defaultUserName = [self.userDefault objectForKey:@"KWUserName"];
    return defaultUserName;
    
}

- (void)setUserEmail:(NSString *)userEmail {
    
    [self.userDefault setObject:userEmail forKey:@"KWUserEmail"];
    [self.userDefault synchronize];
    
}

- (NSString *)userEmail{
    
    NSString *defaultUserEmail = [self.userDefault objectForKey:@"KWUserEmail"];
    return defaultUserEmail;
    
}

- (void)setUserImageURLString:(NSString *)userImageURLString {
    
    [self.userDefault setObject:userImageURLString forKey:@"KWUserImageURLString"];
    [self.userDefault synchronize];
    
}

- (NSString *)userImageURLString{
    
    NSString *defaultUserImageString = [self.userDefault objectForKey:@"KWUserImageURLString"];
    return defaultUserImageString;
    
}

- (void)postLeaveNotificationWithStatus:(KELeaveRecordStatus)status {
    
    if (status == KELeaveRecordStatusInvalid ||
        status == KELeaveRecordStatusIntermediate) {
        return;
    }
    
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    notification.soundName = UILocalNotificationDefaultSoundName;
    
    switch (status) {
        case KELeaveRecordStatus7HR:
            notification.alertBody = @"Time to leave? Have a nice day~ Bye!";
            break;
        case KELeaveRecordStatus9HRAbove:
            notification.alertBody = @"You work so hard today!!! Tomorrow will be better~";
            break;
        default:
            break;
    }
    [[UIApplication sharedApplication] presentLocalNotificationNow:notification];
}


- (void)postDayOffMessageToSlack:(KWDayOffInfo *)dayoffInfo {

    NSString *urlPath = @"https://hooks.slack.com/services/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";
    
    //NSString *testurlPath = @"https://hooks.slack.com/services/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";
    
    NSMutableDictionary *paraDic = [[NSMutableDictionary alloc] init];
    
    NSString *postMessage;
    
    if (dayoffInfo.dayoffComment) {
        postMessage = [NSString stringWithFormat:@"%@ [%@]  %@ day  %@",dayoffInfo.dayoffType,dayoffInfo.dayoffDate,dayoffInfo.dayoffLength,dayoffInfo.dayoffComment];
    }
    else {
        postMessage = [NSString stringWithFormat:@"%@ [%@]  %@ day  ",dayoffInfo.dayoffType,dayoffInfo.dayoffDate,dayoffInfo.dayoffLength];
    }
    
    
    [paraDic setObject:postMessage forKey:@"text"];
    [paraDic setObject:self.userName forKey:@"username"];
    
    [self.manager POST:urlPath parameters:paraDic progress:nil success:^(NSURLSessionTask *task, id responseDic) {
        
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        
    }];
    
}

- (void)postWorkOutsideMessageToSlack:(NSString *)location withStartTime:(NSString *)startTime withEndTime:(NSString *)endTime {
    
    NSString *urlPath = @"https://hooks.slack.com/services/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";
    
    NSMutableDictionary *paraDic = [[NSMutableDictionary alloc] init];
    [paraDic setObject:[NSString stringWithFormat:@"Work %@ from %@ to %@",location,startTime,endTime] forKey:@"text"];
    [paraDic setObject:self.userName forKey:@"username"];
    
    [self.manager POST:urlPath parameters:paraDic progress:nil success:^(NSURLSessionTask *task, id responseDic) {
        
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        
    }];
    
}

- (void)postPTORecord:(KWDayOffInfo *)dayOffInfo withComplete:(void (^)(void))completeBlock fail:(void (^)(NSError *))failBlock {
    
    NSString *urlPath = @"https://hooks.zapier.com/hooks/catch/2823169/86hpnp/";
    
    NSMutableDictionary *paraDic = [[NSMutableDictionary alloc] init];
    
    [paraDic setObject:dayOffInfo.userName forKey:@"name"];
    [paraDic setObject:dayOffInfo.dayoffLength forKey:@"length"];
    [paraDic setObject:dayOffInfo.dayoffDate forKey:@"date"];
    [paraDic setObject:dayOffInfo.dayoffStartTime forKey:@"startTime"];
    [paraDic setObject:dayOffInfo.dayoffEndTime forKey:@"endTime"];
    [paraDic setObject:dayOffInfo.dayoffAgent forKey:@"agent"];
    [paraDic setObject:dayOffInfo.dayoffComment forKey:@"comment"];
    [paraDic setObject:dayOffInfo.dayoffType forKey:@"type"];
    
    __weak typeof (self) weakSelf = self;
    
    [self.manager POST:urlPath parameters:paraDic progress:nil success:^(NSURLSessionTask *task, id responseDic) {
        
        [weakSelf postDayOffMessageToSlack:dayOffInfo];
        completeBlock();
        
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        
        failBlock(error);
        
    }];
    
}


@end
