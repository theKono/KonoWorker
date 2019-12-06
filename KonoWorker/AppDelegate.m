//
//  AppDelegate.m
//  KonoWorker
//
//  Created by kuokuo on 2017/11/17.
//  Copyright © 2017年 Kono. All rights reserved.
//

#import "AppDelegate.h"
#import "KWWorker.h"
#import "KWLocalDatabase.h"
#import "KWLocationManager.h"
#import "KWUtil.h"
#import <Google/SignIn.h>

@interface AppDelegate ()<CLLocationManagerDelegate>

@property (strong, nonatomic) CLBeaconRegion *beaconRegion;
@property (strong, nonatomic) KWLocationManager *locationManager;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    NSError* configureError;
    [[GGLContext sharedInstance] configureWithError: &configureError];
    NSAssert(!configureError, @"Error configuring Google services: %@", configureError);
    
    [KWLocalDatabase initRealmConfiguration];
    
    if ([UIApplication instancesRespondToSelector:@selector(registerUserNotificationSettings:)]){
        [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound categories:nil]];
    }
    
    
    self.locationManager = [KWLocationManager sharedInstance];
    self.locationManager.delegate = self;
    
    
    if ([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
        [self.locationManager requestAlwaysAuthorization];
    }
    
    [self initRegion];
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)app
            openURL:(NSURL *)url
            options:(NSDictionary *)options {
    return [[GIDSignIn sharedInstance] handleURL:url
                               sourceApplication:options[UIApplicationOpenURLOptionsSourceApplicationKey]
                                      annotation:options[UIApplicationOpenURLOptionsAnnotationKey]];
}

#pragma mark - iBeacon
- (void)initRegion {
    
    NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:@"B5B182C7-EAB1-4988-AA99-B5C1517008D9"];
    self.beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:uuid identifier:uuid.UUIDString];
    self.beaconRegion.notifyOnEntry = YES;
    self.beaconRegion.notifyOnExit = YES;
    [self.locationManager startMonitoringForRegion:self.beaconRegion];
}

-(void)locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region {

    [self.locationManager requestStateForRegion:region];
    /*
    if ([beacons count]) {
        NSLog(@"beacon:%@  region:%@",[beacons firstObject],region);
        CLBeacon *monitorBeacon = [beacons firstObject];
        
    }
     */
}

-(void)locationManager:(CLLocationManager *)manager didDetermineState:(CLRegionState)state forRegion:(CLRegion *)region {
    
    KWWorker *currentWorker = [KWWorker worker];
    
    if (currentWorker.userID) {
        
        UILocalNotification *notification = [[UILocalNotification alloc] init];
        notification.soundName = UILocalNotificationDefaultSoundName;

        KWLocationStatus currentStatus = [self.locationManager getCurrentLocationStatus:state];
        BOOL isValidUpdate = NO;
        
        if ( KWLocationStatusEnterConfirmed == currentStatus ) {
            [self.locationManager stopRangingBeaconsInRegion:self.beaconRegion];
            isValidUpdate = [KWAttendanceRecord updateAttendanceRecord:currentWorker.userID withDay:[KWUtil getTodayDateString] withStartTime:[NSDate date]];
            notification.alertBody = @"Hello~ Work fun!";
            
        }
        else if (KWLocationStatusLeaveConfirmed == currentStatus ) {
            [self.locationManager stopRangingBeaconsInRegion:self.beaconRegion];
            //KELeaveRecordStatus leaveRecordStatus = [KWAttendanceRecord updateAttendanceRecord:currentWorker.userID withDay:[KWUtil getTodayDateString] withLeaveTime:[NSDate date]];
            //[currentWorker postLeaveNotificationWithStatus:leaveRecordStatus];
        }
        
        if (YES == isValidUpdate) {
            [[UIApplication sharedApplication] presentLocalNotificationNow:notification];
        }
    }

}

- (void)locationManager:(CLLocationManager *)manager didStartMonitoringForRegion:(CLRegion *)region {
    //[self.locationManager startRangingBeaconsInRegion:self.beaconRegion];
    [self.locationManager requestStateForRegion:region];
}


- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region {
    
    //[self.locationManager requestStateForRegion:region];
    [self.locationManager startRangingBeaconsInRegion:self.beaconRegion];
    
    
}

- (void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region {
    
    //[self.locationManager requestStateForRegion:region];
    [self.locationManager startRangingBeaconsInRegion:self.beaconRegion];
    
}



@end
