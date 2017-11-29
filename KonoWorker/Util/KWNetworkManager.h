//
//  KWNetworkManager.h
//  KonoWorker
//
//  Created by kuokuo on 2017/11/28.
//  Copyright © 2017年 Kono. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking.h>

@interface KWNetworkManager : NSObject

+ (KWNetworkManager* ) sharedManager;

@property (nonatomic, strong) AFHTTPSessionManager *httpSessionManager;

@end
