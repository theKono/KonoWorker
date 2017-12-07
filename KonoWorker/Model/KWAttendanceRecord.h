//
//  KWAttendanceRecord.h
//  KonoWorker
//
//  Created by kuokuo on 2017/11/21.
//Copyright © 2017年 Kono. All rights reserved.
//

#import <Realm/Realm.h>

typedef enum KELeaveRecordStatus : NSUInteger{
    
    KELeaveRecordStatusInvalid = 0,
    KELeaveRecordStatusNew = 1,
    KELeaveRecordStatusIntermediate = 2,
    KELeaveRecordStatus7HR = 3,
    KELeaveRecordStatus9HRAbove = 4
    
}KELeaveRecordStatus;


@interface KWAttendanceRecord : RLMObject

@property NSString *workerID;
@property NSString *workDate;
@property NSString *workRecordYear;
@property NSString *workRecordMonth;
@property NSString *workRecordDay;
@property NSString *workLocation;
@property NSDate *startTime;
@property NSDate *leaveTime;
@property NSInteger duration;
@property BOOL isPTO;
@property BOOL isWorkOutside;

+ (RLMResults *)getAttendanceRecord:(NSString *)userID;

+ (BOOL)updateAttendanceRecord:(NSString *)userID withDay:(NSString *)date withStartTime:(NSDate *)time;

+ (KELeaveRecordStatus)updateAttendanceRecord:(NSString *)userID withDay:(NSString *)date withLeaveTime:(NSDate *)time;

+ (BOOL)updateAttendanceRecordPTO:(NSString *)userID withDay:(NSString *)date withDuration:(NSInteger)duration;

+ (BOOL)updateAttendanceRecordWorkOutside:(NSString *)userID withDay:(NSString *)date withLocation:(NSString *)location withStartTime:(NSDate *)start withEndTime:(NSDate *)end;

@end

// This protocol enables typed collections. i.e.:
// RLMArray<KWAttendanceRecord *><KWAttendanceRecord>
RLM_ARRAY_TYPE(KWAttendanceRecord)
