//
//  BWMSIAlertView.m
//  BWMAlertView
//
//  Created by 伟明 毕 on 15/3/28.
//  Copyright (c) 2015年 Bi Weiming. All rights reserved.
//

#import "BWMSIAlertView.h"
#import "SIAlertView.h"

@interface BWMSIAlertView() {
    SIAlertView *_alertView;
}
@end

@implementation BWMSIAlertView

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message type:(BWMAlertViewType)type targetVC:(UIViewController *)targetVC {
    if (self = [super initWithTitle:title message:message type:type targetVC:targetVC]) {
        _alertView = [[SIAlertView alloc] initWithTitle:title andMessage:message];
        _alertView.transitionStyle = (NSInteger)type;
        _alertView.backgroundStyle = SIAlertViewBackgroundStyleGradient;
    }
    return self;
}

- (void)addButtonWithTitle:(NSString *)title buttonType:(BWMAlertViewButtonType)buttonType callBlock:(BWMAlertViewTaskBlock)callBlock {
    SafeSelf(safeSelf);
    [_alertView addButtonWithTitle:title type:(NSInteger)buttonType+1 handler:^(SIAlertView *alertView) {
        if (callBlock) callBlock(safeSelf);
    }];
}

- (void)show {
    [_alertView show];
}

- (void)dismiss {
    [_alertView dismissAnimated:YES];
}

@end
