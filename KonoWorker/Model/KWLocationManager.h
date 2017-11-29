//
//  KWLocationManager.h
//  KonoWorker
//
//  Created by kuokuo on 2017/11/27.
//  Copyright © 2017年 Kono. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

#define STATUS_CHECK_THRESHOLD 5

typedef enum KWLocationStatus : NSUInteger{
    KWLocationStatusUnknown = 0,
    KWLocationStatusEnterCheck = 1,
    KWLocationStatusEnterConfirmed = 2,
    KWLocationStatusLeaveCheck = 3,
    KWLocationStatusLeaveConfirmed = 4
    
}KWLocationStatus;


@interface KWLocationManager : CLLocationManager

@property (nonatomic) KWLocationStatus currentLocationStatus;

+ (KWLocationManager* )sharedInstance;

- (KWLocationStatus)getCurrentLocationStatus:(CLRegionState)currentRegionState;

@end
