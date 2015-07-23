//
//  BWMAMSmoothAlert.m
//  BWMAlertView
//
//  Created by 伟明 毕 on 15/3/29.
//  Copyright (c) 2015年 Bi Weiming. All rights reserved.
//

#import "BWMAMSmoothAlertView.h"
#import "AMSmoothAlertView.h"

@interface BWMAMSmoothAlertView() {
    AMSmoothAlertView *_alertView;
    NSMutableDictionary *_buttonDict;
}
@end

@implementation BWMAMSmoothAlertView

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message type:(BWMAlertViewType)type targetVC:(UIViewController *)targetVC {
    if (self = [super initWithTitle:title message:message type:type targetVC:targetVC]) {
        _buttonDict = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void)addButtonWithTitle:(NSString *)title buttonType:(BWMAlertViewButtonType)buttonType callBlock:(BWMAlertViewTaskBlock)callBlock {
    
    NSMutableDictionary *tempDict = [[NSMutableDictionary alloc] init];
    tempDict[@"title"] = title;
    if (callBlock) {
        tempDict[@"callBlock"] = [callBlock copy];
    }
    
    _buttonDict[@(buttonType)] = tempDict;
}

- (void)show {
    AlertType alertType;
    switch (self.type) {
        case BWMAlertViewTypeSuccess:
            alertType = AlertSuccess;
            break;
            
        case BWMAlertViewTypeError:
            alertType = AlertFailure;
            break;
            
        case BWMAlertViewTypeInfo:
        case BWMAlertViewTypeWarning:
            alertType = AlertInfo;
            break;
    }
    
    NSString *okTitle = nil;
    BWMAlertViewTaskBlock okBlock = nil;
    NSString *cancelTitle = nil;
    BWMAlertViewTaskBlock cancelBlock = nil;
    
    BOOL hasCancelButton = NO;
    
    if (_buttonDict[@(BWMAlertViewButtonTypeCancel)] && _buttonDict[@(BWMAlertViewButtonTypeCancel)][@"title"]) {
        hasCancelButton = YES;
    }
    
    if (! (_buttonDict[@(BWMAlertViewButtonTypeOKey)] && _buttonDict[@(BWMAlertViewButtonTypeOKey)][@"title"])) {
        hasCancelButton = NO;
    }
    
    if (self.type != BWMAlertViewTypeWarning) {
        _alertView = [[AMSmoothAlertView alloc] initDropAlertWithTitle:self.title andText:self.message andCancelButton:hasCancelButton forAlertType:alertType];
    } else {
        _alertView = [[AMSmoothAlertView alloc] initDropAlertWithTitle:self.title andText:self.message andCancelButton:hasCancelButton forAlertType:alertType andColor:[UIColor colorWithRed:253/255.0 green:179/255.0 blue:73/255.0 alpha:1]];
    }
    
    [_alertView setCornerRadius:3.0f];

    
    
    if (_buttonDict[@(BWMAlertViewButtonTypeOKey)] && _buttonDict[@(BWMAlertViewButtonTypeOKey)][@"title"]) {
        okTitle = _buttonDict[@(BWMAlertViewButtonTypeOKey)][@"title"];
        [_alertView.defaultButton setTitle:okTitle forState:UIControlStateNormal];
    }
    
    if (_buttonDict[@(BWMAlertViewButtonTypeOKey)] && _buttonDict[@(BWMAlertViewButtonTypeOKey)][@"callBlock"]) {
        okBlock = _buttonDict[@(BWMAlertViewButtonTypeOKey)][@"callBlock"];
    }
    
    if (_buttonDict[@(BWMAlertViewButtonTypeCancel)] && _buttonDict[@(BWMAlertViewButtonTypeCancel)][@"title"]) {
        cancelTitle = _buttonDict[@(BWMAlertViewButtonTypeCancel)][@"title"];
        [_alertView.cancelButton setTitle:cancelTitle forState:UIControlStateNormal];
    }
    
    if (_buttonDict[@(BWMAlertViewButtonTypeCancel)] && _buttonDict[@(BWMAlertViewButtonTypeCancel)][@"callBlock"]) {
        cancelBlock = _buttonDict[@(BWMAlertViewButtonTypeCancel)][@"callBlock"];
    }
    
    if (okTitle == nil) {
        [_alertView.defaultButton setTitle:cancelTitle forState:UIControlStateNormal];
    }
    
    SafeSelf(safeSelf);
    [_alertView setCompletionBlock:^(AMSmoothAlertView *alertView, UIButton *btn){
        if(btn == alertView.defaultButton) {
            if (okBlock) {
                okBlock(safeSelf);
            }
            
            if (okTitle == nil) {
                cancelBlock(safeSelf);
            }
        } else if (btn == alertView.cancelButton) {
            if (cancelBlock) {
                cancelBlock(safeSelf);
            }
        }
    }];
    
    [_alertView show];
}

- (void)dismiss {
    [_alertView dismissAlertView];
}

@end
