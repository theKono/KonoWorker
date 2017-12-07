//
//  KWUIComponent.h
//  KonoWorker
//
//  Created by kuokuo on 2017/12/6.
//  Copyright © 2017年 Kono. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface KWUIComponent : NSObject

+ (UIBarButtonItem *)navigationFilterBtn:(id)handler withSelector:(SEL)selector;

+ (UIBarButtonItem *)navigationSortBtn:(id)handler withSelector:(SEL)selector;

@end
