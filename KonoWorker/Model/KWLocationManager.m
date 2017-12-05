//
//  KWLocationManager.m
//  KonoWorker
//
//  Created by kuokuo on 2017/11/27.
//  Copyright © 2017年 Kono. All rights reserved.
//

#import "KWLocationManager.h"

@interface KWLocationManager ()

@property (nonatomic) NSUInteger checkedCount;

@end


@implementation KWLocationManager

#pragma mark - Singleton pattern

+ (KWLocationManager* )sharedInstance{
    static dispatch_once_t pred;
    static KWLocationManager *obj = nil;
    
    dispatch_once(&pred, ^{
        obj = [[KWLocationManager alloc]init];
    });
    obj.distanceFilter = kCLDistanceFilterNone;
    obj.desiredAccuracy = kCLLocationAccuracyBest;
    obj.checkedCount = 0;
    return obj;
}

- (KWLocationStatus)getCurrentLocationStatus:(CLRegionState)currentRegionState {
    
    if ( currentRegionState == CLRegionStateInside) {
        switch (self.currentLocationStatus) {
            case KWLocationStatusUnknown:
                self.currentLocationStatus = KWLocationStatusEnterCheck;
                self.checkedCount = 1;
                break;
            case KWLocationStatusEnterCheck:{
                if (self.checkedCount >= ENTER_STATUS_CHECK_THRESHOLD ) {
                    self.currentLocationStatus = KWLocationStatusEnterConfirmed;
                }
                else {
                    self.checkedCount++;
                }
            }
                break;
            case KWLocationStatusLeaveCheck:
            case KWLocationStatusLeaveConfirmed:
                self.checkedCount = 0;
                self.currentLocationStatus = KWLocationStatusUnknown;
                break;
            case KWLocationStatusEnterConfirmed:
            default:
                break;
        }
    }
    else if( currentRegionState == CLRegionStateOutside ){
        switch (self.currentLocationStatus) {
            case KWLocationStatusUnknown:
                self.currentLocationStatus = KWLocationStatusLeaveCheck;
                self.checkedCount = 1;
                break;
            case KWLocationStatusLeaveCheck:{
                if (self.checkedCount >= LEAVE_STATUS_CHECK_THRESHOLD ) {
                    self.currentLocationStatus = KWLocationStatusLeaveConfirmed;
                }
                else {
                    self.checkedCount++;
                }
            }
                break;
            case KWLocationStatusEnterCheck:
            case KWLocationStatusEnterConfirmed:
                self.checkedCount = 0;
                self.currentLocationStatus = KWLocationStatusUnknown;
                break;
            case KWLocationStatusLeaveConfirmed:
            default:
                break;
        }
    }
    
    return self.currentLocationStatus;
}


@end
