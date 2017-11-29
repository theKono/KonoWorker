//
//  KWLocalDatabase.h
//  KonoWorker
//
//  Created by kuokuo on 2017/11/21.
//  Copyright © 2017年 Kono. All rights reserved.
//
#import "KWAttendanceRecord.h"
#import <Foundation/Foundation.h>
#import <Realm/Realm.h>

@interface KWLocalDatabase : NSObject

+ (void)initRealmConfiguration;

@end
