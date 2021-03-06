//
//  KWLocalDatabase.m
//  KonoWorker
//
//  Created by kuokuo on 2017/11/21.
//  Copyright © 2017年 Kono. All rights reserved.
//

#import "KWLocalDatabase.h"


@implementation KWLocalDatabase

+ (void)initRealmConfiguration{
    
    RLMRealmConfiguration *config = [RLMRealmConfiguration defaultConfiguration];
    // Set the new schema version. This must be greater than the previously used
    // version (if you've never set a schema version before, the version is 0).
    config.schemaVersion = 4;
    
    // Set the block which will be called automatically when opening a Realm with a
    // schema version lower than the one set above
    config.migrationBlock = ^(RLMMigration *migration, uint64_t oldSchemaVersion) {
        // We haven’t migrated anything yet, so oldSchemaVersion == 0
        if (oldSchemaVersion < 3) {
            // Nothing to do!
            // Realm will automatically detect new properties and removed properties
            // And will update the schema on disk automatically
            [migration enumerateObjects:KWAttendanceRecord.className
                                  block:^(RLMObject *oldObject, RLMObject *newObject) {
                                      
                                      newObject[@"workLocation"] = @"Kono Taipei Office";
                                      newObject[@"isWorkOutside"] = @(NO);
                                  }];
        }
        if (oldSchemaVersion < 4 ) {
            [migration enumerateObjects:KWAttendanceRecord.className
                                  block:^(RLMObject *oldObject, RLMObject *newObject) {
                                        newObject[@"workRecordYear"] = @([oldObject[@"workRecordYear"] integerValue]);
                                        newObject[@"workRecordMonth"] = @([oldObject[@"workRecordMonth"] integerValue]);
                                        newObject[@"workRecordDay"] = @([oldObject[@"workRecordDay"] integerValue]);
                                  }];
        }
    };
    
    // Tell Realm to use this new configuration object for the default Realm
    [RLMRealmConfiguration setDefaultConfiguration:config];
    
    // Now that we've told Realm how to handle the schema change, opening the file
    // will automatically perform the migration
    [RLMRealm defaultRealm];
    
}

@end
