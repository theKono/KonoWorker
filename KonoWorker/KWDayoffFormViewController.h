//
//  KWDayoffFormViewController.h
//  KonoWorker
//
//  Created by kuokuo on 2018/1/12.
//  Copyright © 2018年 Kono. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum KWCurrentInputField : NSUInteger{
    KWCurrentInputFieldNone = 10,
    KWCurrentInputFieldName = 11,
    KWCurrentInputFieldType = 12,
    KWCurrentInputFieldDate = 13,
    KWCurrentInputFieldLength = 14,
    KWCurrentInputFieldAgent = 15,
    KWCurrentInputFieldComment = 16
    
}KWCurrentInputField;

@class DayOffInfo;

@interface KWDayoffFormViewController : UIViewController <UIPickerViewDelegate, UITextFieldDelegate,UIPickerViewDataSource>

@end
