//
//  BWMDXAlertView.m
//  BWMAlertView
//
//  Created by 伟明 毕 on 15/3/29.
//  Copyright (c) 2015年 Bi Weiming. All rights reserved.
//

#import "BWMDXAlertView.h"
#import "DXAlertView.h"

@interface BWMDXAlertView() {
    DXAlertView *_alertView;
    NSMutableDictionary *_buttonsDict;
}

@end

@implementation BWMDXAlertView

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message type:(BWMAlertViewType)type targetVC:(UIViewController *)targetVC {
    if (self = [super initWithTitle:title message:message type:type targetVC:targetVC]) {
        _buttonsDict = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void)addButtonWithTitle:(NSString *)title buttonType:(BWMAlertViewButtonType)buttonType callBlock:(BWMAlertViewTaskBlock)callBlock {
    NSMutableDictionary *tempDict = [[NSMutableDictionary alloc] init];
    [tempDict setObject:title forKey:@"title"];
    if (callBlock) {
        [tempDict setObject:[callBlock copy] forKey:@"callBlock"];
    }
    
    [_buttonsDict setObject:tempDict forKey:@(buttonType)];
}

- (void)show {
    NSString *leftButtonTitle = nil;
    BWMAlertViewTaskBlock leftButtonBlock = nil;
    
    NSString *rightButtonTitle = nil;
    BWMAlertViewTaskBlock rightButtonBlock = nil;
    
    if (_buttonsDict[@(BWMAlertViewButtonTypeOKey)]) {
        leftButtonTitle = _buttonsDict[@(BWMAlertViewButtonTypeOKey)][@"title"];
        if (_buttonsDict[@(BWMAlertViewButtonTypeOKey)][@"callBlock"]) {
            leftButtonBlock = _buttonsDict[@(BWMAlertViewButtonTypeOKey)][@"callBlock"];
        }
    }
    
    if (_buttonsDict[@(BWMAlertViewButtonTypeCancel)]) {
        rightButtonTitle = _buttonsDict[@(BWMAlertViewButtonTypeCancel)][@"title"];
        if (_buttonsDict[@(BWMAlertViewButtonTypeCancel)][@"callBlock"]) {
            rightButtonBlock = _buttonsDict[@(BWMAlertViewButtonTypeCancel)][@"callBlock"];
        }
    }
    
    SafeSelf(safeSelf);
    
    if (leftButtonTitle && rightButtonTitle) {
        _alertView = [[DXAlertView alloc] initWithTitle:self.title contentText:self.message leftButtonTitle:leftButtonTitle rightButtonTitle:rightButtonTitle];
        [_alertView setLeftBlock:^{
            leftButtonBlock(safeSelf);
        }];
        [_alertView setRightBlock:^{
            rightButtonBlock(safeSelf);
        }];
    } else {
        if (leftButtonTitle) {
            _alertView = [[DXAlertView alloc] initWithTitle:self.title contentText:self.message leftButtonTitle:nil rightButtonTitle:leftButtonTitle];
            [_alertView setRightBlock:^{
                leftButtonBlock(safeSelf);
            }];
        } else {
            _alertView = [[DXAlertView alloc] initWithTitle:self.title contentText:self.message leftButtonTitle:nil rightButtonTitle:rightButtonTitle];
            [_alertView setRightBlock:^{
                rightButtonBlock(safeSelf);
            }];
        }
    }

    [_alertView show];
}

- (void)dismiss {
    
}

@end
