//
//  KWAttendanceRecord.h
//  KonoWorker
//
//  Created by kuokuo on 2017/11/21.
//Copyright © 2017年 Kono. All rights reserved.
//

#import <Realm/Realm.h>

@interface KWAttendanceRecord : RLMObject

@property NSString *workerID;
@property NSString *workDate;
@property NSString *workRecordYear;
@property NSString *workRecordMonth;
@property NSString *workRecordDay;
@property NSDate *startTime;
@property NSDate *leaveTime;
@property NSInteger duration;
@property BOOL isPTO;

+ (RLMResults *)getAttendanceRecord:(NSString *)userID;

+ (BOOL)updateAttendanceRecord:(NSString *)userID withDay:(NSString *)date withStartTime:(NSDate *)time;

+ (BOOL)updateAttendanceRecord:(NSString *)userID withDay:(NSString *)date withLeaveTime:(NSDate *)time;

+ (BOOL)updateAttendanceRecordPTO:(NSString *)userID withDay:(NSString *)date withDuration:(NSInteger)duration;

+ (void)updateAttendanceRecordWorkFromHome:(NSString *)userID withDay:(NSString *)date;

@end

// This protocol enables typed collections. i.e.:
// RLMArray<KWAttendanceRecord *><KWAttendanceRecord>
RLM_ARRAY_TYPE(KWAttendanceRecord)
