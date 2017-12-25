//
//  KWWorker.h
//  KonoWorker
//
//  Created by kuokuo on 2017/11/28.
//  Copyright © 2017年 Kono. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KWLocalDatabase.h"

@interface KWWorker : NSObject

@property (nonatomic, strong) NSUserDefaults *userDefault;
@property (nonatomic, strong) NSString *userID;
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *userEmail;
@property (nonatomic, strong) NSString *userImageURLString;

+ (KWWorker *)worker;

- (void)postLeaveNotificationWithStatus:(KELeaveRecordStatus)status;

- (void)postWorkOutsideMessageToSlack:(NSString *)location withStartTime:(NSString *)startTime withEndTime:(NSString *)endTime;

- (void)postPTORecord:(NSString *)startDay withDuration:(NSInteger)duration withComplete:(void (^)(void))completeBlock fail:(void (^)(NSError *))failBlock;

@end
