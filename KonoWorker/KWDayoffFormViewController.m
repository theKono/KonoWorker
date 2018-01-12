//
//  KWDayoffFormViewController.m
//  KonoWorker
//
//  Created by kuokuo on 2018/1/12.
//  Copyright © 2018年 Kono. All rights reserved.
//

#import "KWDayoffFormViewController.h"
#import "KWWorker.h"
#import "KWUtil.h"

NSArray *dayOffTypeArray;
NSArray *dayOffLengthArray;

@interface KWDayoffFormViewController ()
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet KWPickViewField *typeTextField;
@property (weak, nonatomic) IBOutlet UITextField *dateTextField;
@property (weak, nonatomic) IBOutlet KWPickViewField *lengthTextField;
@property (weak, nonatomic) IBOutlet UITextField *agentTextField;
@property (weak, nonatomic) IBOutlet UITextField *commentTextField;
@property (weak, nonatomic) IBOutlet UIScrollView *backgroundScrollView;
@property (weak, nonatomic) IBOutlet UILabel *dateDetailLabel;

@property (nonatomic) CGFloat inputViewOffset;
@property (strong, nonatomic) UITextField *currentEditingTextField;
@property (weak, nonatomic) IBOutlet UIPickerView *inputPickView;
@end

@implementation KWDayoffFormViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"請假表單";
    
    dayOffTypeArray = @[@"特休#PTO",@"病假",@"事假",@"婚假",@"生理假",@"產假",@"喪假",@"公傷病假",@"產檢假",@"陪產假",@"補休"];
    dayOffLengthArray = @[@"0.5",@"1",@"2",@"3",@"4",@"5"];
    
    self.nameTextField.delegate = self;
    self.nameTextField.tag = KWCurrentInputFieldName;
    
    self.typeTextField.delegate = self;
    self.typeTextField.tag = KWCurrentInputFieldType;
    self.typeTextField.inputView = self.inputPickView;
    
    self.dateTextField.delegate = self;
    self.dateTextField.tag = KWCurrentInputFieldDate;
    
    self.lengthTextField.delegate = self;
    self.lengthTextField.tag = KWCurrentInputFieldLength;
    self.lengthTextField.inputView = self.inputPickView;
    
    self.agentTextField.delegate = self;
    self.agentTextField.tag = KWCurrentInputFieldAgent;
    
    self.commentTextField.delegate = self;
    self.commentTextField.tag = KWCurrentInputFieldComment;
    
    self.inputPickView.delegate = self;
    self.inputPickView.dataSource = self;
    
    self.dateDetailLabel.hidden = YES;
    [self.inputPickView removeFromSuperview];
    self.inputPickView.showsSelectionIndicator = YES;
    self.inputPickView.frame = CGRectMake(0, 0, self.view.frame.size.width, 200);
    [self initDefaultText];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initDefaultText {
    
    KWWorker *currentWorker = [KWWorker worker];
    self.nameTextField.text = currentWorker.userName;
    self.typeTextField.text = dayOffTypeArray[0];
    self.dateTextField.text = [KWUtil getTodayDateString];
    self.lengthTextField.text = dayOffLengthArray[1];
    
}


#pragma mark - customize view for this viewcontroller

- (UIView*) inputAccessoryView {
    
    UIToolbar *myToolbar = [[UIToolbar alloc] initWithFrame:
                            CGRectMake(0,0, self.view.frame.size.width, 44)];
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    UIButton *doneBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    
    [doneBtn setTitle:@"Done" forState:UIControlStateNormal];
    doneBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    doneBtn.titleLabel.numberOfLines = 1;
    doneBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
    doneBtn.titleLabel.lineBreakMode = NSLineBreakByClipping;
    [doneBtn sizeToFit];
    [doneBtn setTitleColor:[UIColor colorWithRed:255/255.0 green:114/255.0 blue:26/255.0 alpha:1.0] forState:UIControlStateNormal];
    [doneBtn addTarget:self action:@selector(selectActionDone) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithCustomView:doneBtn];
    
    [myToolbar setItems:[NSArray arrayWithObjects: flexibleSpace,doneButton,nil] animated:NO];
    
    return myToolbar;
}

- (void)selectActionDone{
    
    if(self.currentEditingTextField) {
        [self.currentEditingTextField endEditing:YES];
        self.currentEditingTextField = nil;
    }
    
}

#pragma mark - picker delegate function

-(NSInteger) numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

-(NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    
    NSInteger numOfSelection = 1;
    switch (self.currentEditingTextField.tag) {
        case KWCurrentInputFieldType:
            numOfSelection = dayOffTypeArray.count;
            break;
        case KWCurrentInputFieldLength:
            numOfSelection = dayOffLengthArray.count;
            break;
        default:
            break;
    }
    return numOfSelection;
}

-(NSString*) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    NSString *candicatedString;
    
    switch (self.currentEditingTextField.tag) {
        case KWCurrentInputFieldType:
            candicatedString = dayOffTypeArray[row];
            break;
        case KWCurrentInputFieldLength:
            candicatedString = dayOffLengthArray[row];
            break;
        default:
            candicatedString = @"bug";
            break;
    }
    return candicatedString;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    NSArray *dataSourceArray;
    
    switch (self.currentEditingTextField.tag) {
        case KWCurrentInputFieldType:
            dataSourceArray = dayOffTypeArray;
            break;
        case KWCurrentInputFieldLength:
            dataSourceArray = dayOffLengthArray;
            break;
        default:
            break;
    }
    self.currentEditingTextField.text = dataSourceArray[row];
}



#pragma mark - text field delegate function

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
    self.currentEditingTextField = textField;
    NSInteger pickerViewIndex = 0;
    switch (self.currentEditingTextField.tag) {
        case KWCurrentInputFieldType:
            pickerViewIndex = [dayOffTypeArray indexOfObject:self.currentEditingTextField.text];
            [self.inputPickView selectRow:pickerViewIndex inComponent:0 animated:NO];
            break;
        case KWCurrentInputFieldLength:
            pickerViewIndex = [dayOffLengthArray indexOfObject:self.currentEditingTextField.text];
            [self.inputPickView selectRow:pickerViewIndex inComponent:0 animated:NO];
            break;
        default:
            break;
    }
    
}


-(void)textFieldDidEndEditing:(UITextField *)textField{
    

}

#pragma mark - button handle function

- (IBAction)submitBtnPressed:(id)sender {
    
    KWWorker *currentWorker = [KWWorker worker];
    NSInteger totalPTODurationInSec = [self.lengthTextField.text floatValue] * 86400;
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy/LL/dd"];
    [dateFormat setLocale:[[NSLocale alloc] initWithLocaleIdentifier: @"zh_TW"]];
    NSDate *PTOStartDate = [dateFormat dateFromString:self.dateTextField.text];
    
    __block BOOL needShowAlert = YES;
    
    while (totalPTODurationInSec >0) {
        NSInteger PTODurationInSec = (totalPTODurationInSec > 86400) ? 86400 : totalPTODurationInSec;
        
        [KWAttendanceRecord updateAttendanceRecordPTO:currentWorker.userID withDay:[KWUtil getDateStringWithDate:PTOStartDate] withDuration:PTODurationInSec];
        KWDayOffInfo *info = [KWDayOffInfo new];
        info.userName = self.nameTextField.text;
        info.dayoffType = self.typeTextField.text;
        info.dayoffAgent = self.agentTextField.text;
        info.dayoffComment = self.commentTextField.text;
        info.dayoffDate = [KWUtil getDateStringWithDate:PTOStartDate];
        if (PTODurationInSec == 86400) {
            info.dayoffStartTime = @"上午 10:00:00";
            info.dayoffEndTime = @"下午 6:00:00";
            info.dayoffLength = @"1";
        }
        else if ([self.lengthTextField.text isEqualToString:@"0.5"]){
            info.dayoffStartTime = @"上午 10:00:00";
            info.dayoffEndTime = @"下午 2:00:00";
            info.dayoffLength = @"0.5";
        }
        else {
            info.dayoffStartTime = @"上午 10:00:00";
            info.dayoffEndTime = @"下午 2:00:00";
            info.dayoffLength = @"0.5";
        }
        
        
        [currentWorker postPTORecord:info withComplete:^{
            if( needShowAlert) {
                [KWUtil showSuccessAlert:self withString:@"請假紀錄已送出，安心放假囉~"];
                needShowAlert = NO;
            }
        } fail:^(NSError *error){
            [KWUtil showErrorAlert:self withErrorStr:@"請假紀錄未送至遠端，請聯絡工程師check!"];
        }];
        PTOStartDate = [PTOStartDate dateByAddingTimeInterval:86400];
        totalPTODurationInSec -= 86400;
    }
    
}


#pragma mark - input view show/hide handle function

- (void)setViewMovedUp:(BOOL)movedUp moveOffset:(CGRect)keyboardFrame{
    
    CGRect rect;
    CGFloat fixedHeight = 136;
    
    rect = CGRectMake(0,0, self.backgroundScrollView.contentSize.width, self.backgroundScrollView.contentSize.height);
    
    //NSLog(@"%f",keyboardFrame.size.height);
    if ( movedUp ){
        
        rect.size.height += fixedHeight;
        self.inputViewOffset = fixedHeight -20;
        
    }
    else{
        
        rect.size.height -= fixedHeight;
        self.inputViewOffset = 0;
    }
    self.backgroundScrollView.contentSize = CGSizeMake(rect.size.width, rect.size.height);
    
    [self.backgroundScrollView setContentOffset:CGPointMake(0, self.inputViewOffset + 88 ) animated:YES];
    
    [UIView commitAnimations];
    
}

- (void)keyboardWillShow:(NSNotification *)notification {
    
    // Animate the current view out of the way
    NSDictionary *info  = notification.userInfo;
    NSValue      *value = info[UIKeyboardFrameEndUserInfoKey];
    
    CGRect rawFrame      = [value CGRectValue];
    CGRect keyboardFrame = [self.view convertRect:rawFrame fromView:nil];
    
    
    [self setViewMovedUp:YES moveOffset:keyboardFrame];
    
}

- (void)keyboardWillHide:(NSNotification *)notification {
    
    NSDictionary *info  = notification.userInfo;
    NSValue      *value = info[UIKeyboardFrameEndUserInfoKey];
    
    CGRect rawFrame      = [value CGRectValue];
    CGRect keyboardFrame = [self.view convertRect:rawFrame fromView:nil];
    
    [self setViewMovedUp:NO moveOffset:keyboardFrame];
    
}

@end
