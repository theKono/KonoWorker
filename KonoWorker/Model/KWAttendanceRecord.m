//
//  KWAttendanceRecord.m
//  KonoWorker
//
//  Created by kuokuo on 2017/11/21.
//Copyright © 2017年 Kono. All rights reserved.
//

#import "KWAttendanceRecord.h"

@implementation KWAttendanceRecord

+ (RLMResults *)getAttendanceRecord:(NSString *)userID {
    
    return [[KWAttendanceRecord objectsWhere:@"workerID == %@ ",userID] sortedResultsUsingKeyPath:@"workDate" ascending:YES];
    
}


+ (KWAttendanceRecord *)getAttendanceRecord:(NSString *)userID withDay:(NSString *)date isForPTO:(BOOL)isPTO{
    
    KWAttendanceRecord *attendanceRecord;
    attendanceRecord = [[KWAttendanceRecord objectsWhere:@"workDate == %@ and workerID == %@ and isPTO == %@",date,userID,[NSNumber numberWithBool:isPTO]] firstObject];
    
    return attendanceRecord;
}


+ (BOOL)updateAttendanceRecord:(NSString *)userID withDay:(NSString *)date withStartTime:(NSDate *)time {
    
    RLMRealm *realm = [RLMRealm defaultRealm];
    KWAttendanceRecord *attendanceRecord = [self getAttendanceRecord:userID withDay:date isForPTO:NO];
    NSArray *timeInfo = [date componentsSeparatedByString:@"/"];
    BOOL isValidRequest = NO;
    if( nil == attendanceRecord ){
        //insert new reading object
        attendanceRecord = [[KWAttendanceRecord alloc] init];
        attendanceRecord.workerID = userID;
        attendanceRecord.workDate = date;
        attendanceRecord.workRecordYear = timeInfo[0];
        attendanceRecord.workRecordMonth = timeInfo[1];
        attendanceRecord.workRecordDay = timeInfo[2];
        attendanceRecord.startTime = time;
        attendanceRecord.leaveTime = time;
        attendanceRecord.isPTO = NO;
        
        // Add to Realm with transaction
        [realm beginWriteTransaction];
        [realm addObject:attendanceRecord];
        [realm commitWriteTransaction];
        isValidRequest = YES;
    }
    else if( [attendanceRecord.startTime compare:time] == NSOrderedDescending ){
        //we get an eariler time than local database, update it!
        [realm beginWriteTransaction];
        attendanceRecord.startTime = time;
        [realm commitWriteTransaction];
        isValidRequest = YES;
    }
    return isValidRequest;
}

+ (BOOL)updateAttendanceRecord:(NSString *)userID withDay:(NSString *)date withLeaveTime:(NSDate *)time {
    
    RLMRealm *realm = [RLMRealm defaultRealm];
    KWAttendanceRecord *attendanceRecord = [self getAttendanceRecord:userID withDay:date isForPTO:NO];
    NSArray *timeInfo = [date componentsSeparatedByString:@"/"];
    BOOL isValidRequest = NO;
    
    if( nil == attendanceRecord ){
        //insert new reading object
        attendanceRecord = [[KWAttendanceRecord alloc] init];
        attendanceRecord.workerID = userID;
        attendanceRecord.workDate = date;
        attendanceRecord.workRecordYear = timeInfo[0];
        attendanceRecord.workRecordMonth = timeInfo[1];
        attendanceRecord.workRecordDay = timeInfo[2];
        attendanceRecord.startTime = time;
        attendanceRecord.leaveTime = time;
        attendanceRecord.isPTO = NO;
        
        // Add to Realm with transaction
        [realm beginWriteTransaction];
        [realm addObject:attendanceRecord];
        [realm commitWriteTransaction];
        isValidRequest = YES;
    }
    else if( [attendanceRecord.leaveTime compare:time] == NSOrderedAscending ){
        //we get an eariler time than local database, update it!
        [realm beginWriteTransaction];
        attendanceRecord.leaveTime = time;
        attendanceRecord.duration = [attendanceRecord.leaveTime timeIntervalSinceDate:attendanceRecord.startTime];
        [realm commitWriteTransaction];
        isValidRequest = YES;
    }
    return isValidRequest;
}

+ (BOOL)updateAttendanceRecordPTO:(NSString *)userID withDay:(NSString *)date withDuration:(NSInteger)duration{
    
    RLMRealm *realm = [RLMRealm defaultRealm];
    KWAttendanceRecord *attendanceRecord = [self getAttendanceRecord:userID withDay:date isForPTO:YES];
    NSArray *timeInfo = [date componentsSeparatedByString:@"/"];
    BOOL isValidRequest = NO;
    
    if( nil == attendanceRecord ){
        attendanceRecord = [[KWAttendanceRecord alloc] init];
        attendanceRecord.workerID = userID;
        attendanceRecord.workDate = date;
        attendanceRecord.workRecordYear = timeInfo[0];
        attendanceRecord.workRecordMonth = timeInfo[1];
        attendanceRecord.workRecordDay = timeInfo[2];
        attendanceRecord.isPTO = YES;
        attendanceRecord.duration = duration;
        // Add to Realm with transaction
        [realm beginWriteTransaction];
        [realm addObject:attendanceRecord];
        [realm commitWriteTransaction];
        
        isValidRequest = YES;
    }
    else {
        if (attendanceRecord.duration + duration <= 86400 ) {
            [realm beginWriteTransaction];
            attendanceRecord.isPTO = YES;
            attendanceRecord.duration += duration;
            [realm commitWriteTransaction];
            isValidRequest = YES;
        }
    }
    return  isValidRequest;
}

+ (void)updateAttendanceRecordWorkFromHome:(NSString *)userID withDay:(NSString *)date {
    
    NSDate *workEndTime = [[NSDate alloc] initWithTimeIntervalSinceNow:8*60*60];
    [self updateAttendanceRecord:userID withDay:date withStartTime:[NSDate date]];
    [self updateAttendanceRecord:userID withDay:date withLeaveTime:workEndTime];
    
}


@end
