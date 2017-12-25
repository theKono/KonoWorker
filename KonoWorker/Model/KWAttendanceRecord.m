//
//  KWAttendanceRecord.m
//  KonoWorker
//
//  Created by kuokuo on 2017/11/21.
//Copyright © 2017年 Kono. All rights reserved.
//

#import "KWAttendanceRecord.h"

#define ONE_HOUR_BY_SEC 3600


@implementation KWAttendanceRecord


+ (NSArray *)sortByDateDescriptorWithAscending:(BOOL)ascending {
    
    return @[[RLMSortDescriptor sortDescriptorWithKeyPath:@"workRecordYear" ascending:ascending],
             [RLMSortDescriptor sortDescriptorWithKeyPath:@"workRecordMonth" ascending:ascending],
             [RLMSortDescriptor sortDescriptorWithKeyPath:@"workRecordDay" ascending:ascending]];
    
}

+ (RLMResults *)getAttendanceRecord:(NSString *)userID {
    
    NSArray *sortDescriptor = [self sortByDateDescriptorWithAscending:NO];
    
    return [[KWAttendanceRecord objectsWhere:@"workerID == %@ ",userID] sortedResultsUsingDescriptors:sortDescriptor];
    
}


+ (KWAttendanceRecord *)getAttendancePTORecord:(NSString *)userID withDay:(NSString *)date {
    
    KWAttendanceRecord *attendanceRecord;
    attendanceRecord = [[KWAttendanceRecord objectsWhere:@"workDate == %@ and workerID == %@ and isPTO == YES",date,userID] firstObject];
    
    return attendanceRecord;
}

+ (KWAttendanceRecord *)getAttendanceRecord:(NSString *)userID withDay:(NSString *)date {
    
    KWAttendanceRecord *attendanceRecord;
    attendanceRecord = [[KWAttendanceRecord objectsWhere:@"workDate == %@ and workerID == %@ and isPTO == NO and isWorkOutside == NO",date,userID] firstObject];
    
    return attendanceRecord;
}

+ (KWAttendanceRecord *)getAttendanceWorkOutsideRecord:(NSString *)userID withDay:(NSString *)date {
    
    KWAttendanceRecord *attendanceRecord;
    attendanceRecord = [[KWAttendanceRecord objectsWhere:@"workDate == %@ and workerID == %@ and isPTO == NO and isWorkOutside == YES",date,userID] firstObject];
    
    return attendanceRecord;
}


+ (BOOL)updateAttendanceRecord:(NSString *)userID withDay:(NSString *)date withStartTime:(NSDate *)time {
    
    RLMRealm *realm = [RLMRealm defaultRealm];
    KWAttendanceRecord *attendanceRecord = [self getAttendanceRecord:userID withDay:date];
    NSArray *timeInfo = [date componentsSeparatedByString:@"/"];
    BOOL isValidRequest = NO;
    if( nil == attendanceRecord ){
        //insert new reading object
        attendanceRecord = [[KWAttendanceRecord alloc] init];
        attendanceRecord.workerID = userID;
        attendanceRecord.workDate = date;
        attendanceRecord.workRecordYear = [timeInfo[0] integerValue];
        attendanceRecord.workRecordMonth = [timeInfo[1] integerValue];
        attendanceRecord.workRecordDay = [timeInfo[2] integerValue];
        attendanceRecord.workLocation = @"Kono Taipei Office";
        attendanceRecord.startTime = time;
        attendanceRecord.leaveTime = time;
        attendanceRecord.isPTO = NO;
        attendanceRecord.isWorkOutside = NO;
        
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

+ (KELeaveRecordStatus )updateAttendanceRecord:(NSString *)userID withDay:(NSString *)date withLeaveTime:(NSDate *)time {
    
    RLMRealm *realm = [RLMRealm defaultRealm];
    KWAttendanceRecord *attendanceRecord = [self getAttendanceRecord:userID withDay:date];
    NSArray *timeInfo = [date componentsSeparatedByString:@"/"];
    KELeaveRecordStatus recordStatus = KELeaveRecordStatusInvalid;
    
    if( nil == attendanceRecord ){
        //insert new reading object
        attendanceRecord = [[KWAttendanceRecord alloc] init];
        attendanceRecord.workerID = userID;
        attendanceRecord.workDate = date;
        attendanceRecord.workRecordYear = [timeInfo[0] integerValue];
        attendanceRecord.workRecordMonth = [timeInfo[1] integerValue];
        attendanceRecord.workRecordDay = [timeInfo[2] integerValue];
        attendanceRecord.workLocation = @"Kono Taipei Office";
        attendanceRecord.startTime = time;
        attendanceRecord.leaveTime = time;
        attendanceRecord.isPTO = NO;
        attendanceRecord.isWorkOutside = NO;
        
        // Add to Realm with transaction
        [realm beginWriteTransaction];
        [realm addObject:attendanceRecord];
        [realm commitWriteTransaction];
        recordStatus = KELeaveRecordStatusNew;
    }
    else if( [attendanceRecord.leaveTime compare:time] == NSOrderedAscending ){
        //we get an eariler time than local database, update it!
        [realm beginWriteTransaction];
        attendanceRecord.leaveTime = time;
        attendanceRecord.duration = [attendanceRecord.leaveTime timeIntervalSinceDate:attendanceRecord.startTime];
        [realm commitWriteTransaction];
        
        if (attendanceRecord.duration < 7 * ONE_HOUR_BY_SEC){
            recordStatus = KELeaveRecordStatusIntermediate;
        }
        else if (attendanceRecord.duration > 7* ONE_HOUR_BY_SEC && attendanceRecord.duration < 9 * ONE_HOUR_BY_SEC ) {
            recordStatus = KELeaveRecordStatus7HR;
        }
        else {
            recordStatus = KELeaveRecordStatus9HRAbove;
        }
    }
    return recordStatus;
}

+ (BOOL)updateAttendanceRecordPTO:(NSString *)userID withDay:(NSString *)date withDuration:(NSInteger)duration{
    
    RLMRealm *realm = [RLMRealm defaultRealm];
    KWAttendanceRecord *attendanceRecord = [self getAttendancePTORecord:userID withDay:date];
    NSArray *timeInfo = [date componentsSeparatedByString:@"/"];
    BOOL isValidRequest = NO;
    
    if( nil == attendanceRecord ){
        attendanceRecord = [[KWAttendanceRecord alloc] init];
        attendanceRecord.workerID = userID;
        attendanceRecord.workDate = date;
        attendanceRecord.workRecordYear = [timeInfo[0] integerValue];
        attendanceRecord.workRecordMonth = [timeInfo[1] integerValue];
        attendanceRecord.workRecordDay = [timeInfo[2] integerValue];
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

+ (BOOL)updateAttendanceRecordWorkOutside:(NSString *)userID withDay:(NSString *)date withLocation:(NSString *)location withStartTime:(NSDate *)start withEndTime:(NSDate *)end{
    
    RLMRealm *realm = [RLMRealm defaultRealm];
    KWAttendanceRecord *attendanceRecord = [self getAttendanceWorkOutsideRecord:userID withDay:date];
    NSArray *timeInfo = [date componentsSeparatedByString:@"/"];
    BOOL isValidRequest = NO;
    
    if( nil == attendanceRecord ){
        attendanceRecord = [[KWAttendanceRecord alloc] init];
        attendanceRecord.workerID = userID;
        attendanceRecord.workDate = date;
        attendanceRecord.workRecordYear = [timeInfo[0] integerValue];
        attendanceRecord.workRecordMonth = [timeInfo[1] integerValue];
        attendanceRecord.workRecordDay = [timeInfo[2] integerValue];
        attendanceRecord.workLocation = location;
        attendanceRecord.startTime = start;
        attendanceRecord.leaveTime = end;
        attendanceRecord.isPTO = NO;
        attendanceRecord.isWorkOutside = YES;
        attendanceRecord.duration = [end timeIntervalSinceDate:start];;
        // Add to Realm with transaction
        [realm beginWriteTransaction];
        [realm addObject:attendanceRecord];
        [realm commitWriteTransaction];
        
        isValidRequest = YES;
    }
    else {
        if( [attendanceRecord.leaveTime compare:end] == NSOrderedAscending ){
            //we get an eariler time than local database, update it!
            [realm beginWriteTransaction];
            attendanceRecord.leaveTime = end;
            attendanceRecord.duration = [attendanceRecord.leaveTime timeIntervalSinceDate:attendanceRecord.startTime];
            [realm commitWriteTransaction];
            isValidRequest = YES;
        }
        if( [attendanceRecord.startTime compare:start] == NSOrderedDescending ){
            //we get an eariler time than local database, update it!
            [realm beginWriteTransaction];
            attendanceRecord.startTime = start;
            [realm commitWriteTransaction];
            isValidRequest = YES;
        }
    }
    return  isValidRequest;
}


@end
