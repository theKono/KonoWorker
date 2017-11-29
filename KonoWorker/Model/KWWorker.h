//
//  KWWorker.h
//  KonoWorker
//
//  Created by kuokuo on 2017/11/28.
//  Copyright © 2017年 Kono. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KWWorker : NSObject

@property (nonatomic, strong) NSUserDefaults *userDefault;
@property (nonatomic, strong) NSString *userID;
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *userEmail;
@property (nonatomic, strong) NSString *userImageURLString;

+ (KWWorker *)worker;

- (void)postPTOMessageToSlack:(NSString *)startDay withDuration:(NSInteger)duration;

- (void)postWorkFromHomeMessageToSlack;

@end
