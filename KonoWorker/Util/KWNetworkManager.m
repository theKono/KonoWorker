//
//  KWNetworkManager.m
//  KonoWorker
//
//  Created by kuokuo on 2017/11/28.
//  Copyright © 2017年 Kono. All rights reserved.
//

#import "KWNetworkManager.h"


@implementation KWNetworkManager

+ (KWNetworkManager* )sharedManager {
    
    static dispatch_once_t pred;
    static KWNetworkManager *obj = nil;
    
    dispatch_once(&pred, ^{
        
        obj = [[KWNetworkManager alloc]init];
        obj.httpSessionManager = [AFHTTPSessionManager manager];
        obj.httpSessionManager.requestSerializer = [AFJSONRequestSerializer serializer];
        obj.httpSessionManager.responseSerializer = [AFJSONResponseSerializer serializer];
        
    });
    
    return obj;
}


@end
