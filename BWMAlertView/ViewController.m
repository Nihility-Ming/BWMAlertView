//
//  ViewController.m
//  BWMAlertView
//
//  Created by 伟明 毕 on 15/3/28.
//  Copyright (c) 2015年 Bi Weiming. All rights reserved.
//

#import "ViewController.h"

// BWMAlertView抽象类
#import "BWMAlertView.h"

// BWMAlertView具体类
#import "BWMSIAlertView.h"
#import "BWMSCLAlertView.h"
#import "BWMHHAlertView.h"
#import "BWMUIAlertView.h"
#import "BWMDXAlertView.h"

// Default Is BWMSAMSmoothAlertView
NSString *_alertViewClassSelectedName = nil;

NSArray *_alertViewClassesArray = nil;

@interface ViewController () <UIPickerViewDataSource, UIPickerViewDelegate> {
    
}

@property (strong, nonatomic) IBOutlet UIPickerView *pickerView;

// Show Alert View Private Method
- (void)p_showAlertViewWithType:(BWMAlertViewType)alertViewType;

@end

@implementation ViewController

// 此类方法每个类都有，这个类被初次使用的时候调用，且只会调用一次，用来初始化全局变量非常适合
+ (void)initialize {
    // 因为此方法涉及继承链，要判断一下再用
    if ([self class] == [ViewController class]) {
        NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"BWMAlertViewClasses" ofType:@"plist"];
        _alertViewClassesArray = [[NSMutableArray alloc] initWithContentsOfFile:plistPath];
        
        _alertViewClassSelectedName = [_alertViewClassesArray firstObject];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

#pragma mark- Private Methods 重点！
- (void)p_showAlertViewWithType:(BWMAlertViewType)alertViewType {
    // 获取已经选择的类
    Class AlertViewClass = NSClassFromString(_alertViewClassSelectedName);
    
    // 初始化BWMAlertView
    BWMAlertView<BWMAlertView> *theAlertView = [[AlertViewClass alloc]
                                             initWithTitle:@"标题 Title"
                                             message:@"写点什么吧... Write about it ..."
                                             type:alertViewType //BWMAlertViewType
                                             targetVC:self];
    
    // AlertViewClass也就是BWMAlertView具体类，在使用中也可以直接这样
    /*
     BWMAlertView<BWMAlertView> *theAlertView = [[BWMAMSmoothAlertView alloc] initWithTitle:@"标题 Title" message:@"写点什么吧... Write about it ..." type:BWMAlertViewTypeSuccess targetVC:self];
     
     也就直接采用了BWMAMSmoothAlertView
     */
    
    
    /* 添加按钮，上限两个。并且BWMAlertViewButtonType类型BWMAlertViewButtonTypeOKey、BWMAlertViewButtonTypeCancel只能有且限一个 */
    
    // 添加确定按钮
    [theAlertView addButtonWithTitle:@"确定"
                       buttonType:BWMAlertViewButtonTypeOKey
                        callBlock:^(BWMAlertView<BWMAlertView> *alertView) {
                            NSLog(@"确定 %s", __FUNCTION__);
                            
                            [alertView dismiss]; // dismiss
                        }];
    
    
    // 添加Cancel按钮
    [theAlertView addButtonWithTitle:@"关闭"
                       buttonType:BWMAlertViewButtonTypeCancel
                        callBlock:^(BWMAlertView<BWMAlertView> *alertView) {
                            NSLog(@"关闭 %s", __FUNCTION__);
                            
                            [alertView dismiss]; // dismiss
                        }];
    
    // 确定按钮和Cancel按钮可以只添加一个，也可以同时出现，但是它们仅能各出现一次！ -- important!
    
    [theAlertView show];
}

#pragma mark- UIPickerViewDataSource And UIPickerViewDelegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return _alertViewClassesArray.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return _alertViewClassesArray[row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    _alertViewClassSelectedName = _alertViewClassesArray[row];
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 30.0f;
}

#pragma mark- UITableViewDataSrouce And UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        [self p_showAlertViewWithType:indexPath.row];
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}

@end
