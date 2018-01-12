//
//  KWDayOffInfo.h
//  KonoWorker
//
//  Created by kuokuo on 2018/1/12.
//  Copyright © 2018年 Kono. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KWDayOffInfo : NSObject

@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *dayoffType;
@property (nonatomic, copy) NSString *dayoffDate;
@property (nonatomic, copy) NSString *dayoffStartTime;
@property (nonatomic, copy) NSString *dayoffEndTime;
@property (nonatomic, copy) NSString *dayoffLength;
@property (nonatomic, copy) NSString *dayoffAgent;
@property (nonatomic, copy) NSString *dayoffComment;


@end
