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

- (void)postPTOMessageToSlack:(NSString *)startDay withDuration:(NSInteger)duration {
    
    NSString *urlPath = @"https://hooks.slack.com/services/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";
    
    NSMutableDictionary *paraDic = [[NSMutableDictionary alloc] init];
    
    [paraDic setObject:[NSString stringWithFormat:@"#PTO %@ %.1lf day",startDay,duration/86400.0] forKey:@"text"];
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

@end
