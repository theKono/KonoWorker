//
//  KWUIComponent.m
//  KonoWorker
//
//  Created by kuokuo on 2017/12/6.
//  Copyright © 2017年 Kono. All rights reserved.
//

#import "KWUIComponent.h"
#import <Masonry.h>

@implementation KWUIComponent

+ (UIBarButtonItem *)navigationFilterBtn:(id)handler withSelector:(SEL)selector {
    
    UIButton *filterBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 24, 44)];
    
    [filterBtn setImage:[UIImage imageNamed:@"btn_filter"] forState:UIControlStateNormal];
    [filterBtn addTarget:handler action:selector forControlEvents:UIControlEventTouchUpInside];
    filterBtn.imageEdgeInsets = UIEdgeInsetsMake(10, 0, 10, 4);
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:filterBtn];
    if (([[[UIDevice currentDevice] systemVersion] floatValue] >= 11.0)){
        [barButton.customView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.width.equalTo(@(28));
            make.height.equalTo(@(44));
        }];
    }
    return barButton;
    
}

+ (UIBarButtonItem *)navigationSortBtn:(id)handler withSelector:(SEL)selector {
    
    UIButton *sortBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 24, 44)];
    
    [sortBtn setImage:[UIImage imageNamed:@"btn_sort"] forState:UIControlStateNormal];
    [sortBtn addTarget:handler action:selector forControlEvents:UIControlEventTouchUpInside];
    sortBtn.imageEdgeInsets = UIEdgeInsetsMake(10, 4, 10, 0);
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:sortBtn];
    if (([[[UIDevice currentDevice] systemVersion] floatValue] >= 11.0)){
        [barButton.customView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@(28));
            make.height.equalTo(@(44));
        }];
    }
    return barButton;
    
}


@end
