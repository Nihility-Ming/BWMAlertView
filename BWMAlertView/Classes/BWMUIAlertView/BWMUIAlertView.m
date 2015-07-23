//
//  BWMUIAlertView.m
//  BWMAlertView
//
//  Created by 伟明 毕 on 15/3/28.
//  Copyright (c) 2015年 Bi Weiming. All rights reserved.
//

#import "BWMUIAlertView.h"

static BWMUIAlertView *_theView;

@interface BWMUIAlertView() <UIAlertViewDelegate> {
    UIAlertView *_alertView;
    NSMutableDictionary *_buttonsDict;
}

@end

@implementation BWMUIAlertView

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message type:(BWMAlertViewType)type targetVC:(UIViewController *)targetVC {
    if (self = [super initWithTitle:title message:message type:type targetVC:targetVC]) {
        _buttonsDict = [[NSMutableDictionary alloc] init];
    }
    _theView = self;
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
    NSString *okTitle = nil;
    NSString *cancelTitle = nil;
    
    if (_buttonsDict[@(BWMAlertViewButtonTypeOKey)]) {
        cancelTitle = _buttonsDict[@(BWMAlertViewButtonTypeOKey)][@"title"];
    }
    
    if (_buttonsDict[@(BWMAlertViewButtonTypeCancel)]) {
        okTitle = _buttonsDict[@(BWMAlertViewButtonTypeCancel)][@"title"];
    }
    
    if (cancelTitle == nil && okTitle) {
        _alertView = [[UIAlertView alloc] initWithTitle:self.title message:self.message delegate:self cancelButtonTitle:okTitle otherButtonTitles:nil, nil];
    } else {
        _alertView = [[UIAlertView alloc] initWithTitle:self.title message:self.message delegate:self cancelButtonTitle:cancelTitle otherButtonTitles:okTitle, nil];
    }
    
    [_alertView show];
}

- (void)dismiss {
    
}

#pragma mark- UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        if (_buttonsDict[@(BWMAlertViewButtonTypeOKey)] && _buttonsDict[@(BWMAlertViewButtonTypeOKey)][@"callBlock"]) {
            BWMAlertViewTaskBlock block = _buttonsDict[@(BWMAlertViewButtonTypeOKey)][@"callBlock"];
            block(self);
        } else if (_buttonsDict[@(BWMAlertViewButtonTypeCancel)] && _buttonsDict[@(BWMAlertViewButtonTypeCancel)][@"callBlock"]) {
            BWMAlertViewTaskBlock block = _buttonsDict[@(BWMAlertViewButtonTypeCancel)][@"callBlock"];
            block(self);
        }
    } else {
        if (_buttonsDict[@(BWMAlertViewButtonTypeCancel)] && _buttonsDict[@(BWMAlertViewButtonTypeCancel)][@"callBlock"]) {
            BWMAlertViewTaskBlock block = _buttonsDict[@(BWMAlertViewButtonTypeCancel)][@"callBlock"];
            block(self);
        }
    }
    
    _theView = nil;
}

@end
