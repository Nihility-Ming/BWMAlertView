//
//  BWMHHAlertView.m
//  BWMAlertView
//
//  Created by 伟明 毕 on 15/3/29.
//  Copyright (c) 2015年 Bi Weiming. All rights reserved.
//

#import "BWMHHAlertView.h"
#import "HHAlertView.h"

@interface BWMHHAlertView() {
    NSMutableDictionary *_buttonDict;
}

@end

@implementation BWMHHAlertView

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message type:(BWMAlertViewType)type targetVC:(UIViewController *)targetVC {
    if (self = [super initWithTitle:title message:message type:type targetVC:targetVC]) {
        _buttonDict = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void)addButtonWithTitle:(NSString *)title buttonType:(BWMAlertViewButtonType)buttonType callBlock:(BWMAlertViewTaskBlock)callBlock {
    NSMutableDictionary *tempDict = [[NSMutableDictionary alloc] init];
    [tempDict setObject:title forKey:@"title"];
    if (callBlock) {
        [tempDict setObject:[callBlock copy] forKey:@"callBlock"];
    }
    
    [_buttonDict setObject:tempDict forKey:@(buttonType)];
}

- (void)show {
    NSString *okTitle = nil;
    NSString *cancelTitle = nil;
    BWMAlertViewTaskBlock okBlock = nil;
    BWMAlertViewTaskBlock cancelBlock = nil;
    BOOL flag = NO;
    
    if (_buttonDict[@(BWMAlertViewButtonTypeOKey)]) {
        okTitle = _buttonDict[@(BWMAlertViewButtonTypeOKey)][@"title"];
    }
    
    if (_buttonDict[@(BWMAlertViewButtonTypeCancel)]) {
        cancelTitle = _buttonDict[@(BWMAlertViewButtonTypeCancel)][@"title"];
    }
    
    if (_buttonDict[@(BWMAlertViewButtonTypeOKey)]) {
        if (_buttonDict[@(BWMAlertViewButtonTypeOKey)][@"callBlock"]) {
            okBlock = _buttonDict[@(BWMAlertViewButtonTypeOKey)][@"callBlock"];
        }
    }
    
    if (_buttonDict[@(BWMAlertViewButtonTypeCancel)]) {
        if (_buttonDict[@(BWMAlertViewButtonTypeCancel)][@"callBlock"]) {
            cancelBlock = _buttonDict[@(BWMAlertViewButtonTypeCancel)][@"callBlock"];
        }
    }
    
    if (okTitle == nil) {
        okTitle = cancelTitle;
        cancelTitle = nil;
        flag = YES;
    }
    
    if (self.type == BWMAlertViewTypeSuccess) {
        [HHAlertView showAlertWithStyle:HHAlertStyleOk
                                 inView:self.targetViewController.view
                                  Title:self.title
                                 detail:self.message
                           cancelButton:cancelTitle
                               Okbutton:okTitle
                                  block:^(HHAlertButton buttonindex) {
                                      if (buttonindex == HHAlertButtonOk) {
                                          if (okBlock) {
                                              okBlock(self);
                                          }
                                      }
                                      else
                                      {
                                          if (cancelBlock) {
                                              cancelBlock(self);
                                          }
                                      }
                                      
                                      if (flag) {
                                          if (cancelBlock) {
                                              cancelBlock(self);
                                          }
                                      }
                                  }];
    } else if (self.type == BWMAlertViewTypeWarning || self.type == BWMAlertViewTypeInfo) {
        [HHAlertView showAlertWithStyle:HHAlertStyleWraning
                                 inView:self.targetViewController.view
                                  Title:self.title
                                 detail:self.message
                           cancelButton:cancelTitle
                               Okbutton:okTitle
                                  block:^(HHAlertButton buttonindex) {
                                      if (buttonindex == HHAlertButtonOk) {
                                          if (okBlock) {
                                              okBlock(self);
                                          }
                                      }
                                      else
                                      {
                                          if (cancelBlock) {
                                              cancelBlock(self);
                                          }
                                          
                                      }
                                      
                                      if (flag) {
                                          if (cancelBlock) {
                                              cancelBlock(self);
                                          }
                                      }
                                  }];
    } else if (self.type == BWMAlertViewTypeError) {
        [HHAlertView showAlertWithStyle:HHAlertStyleError
                                 inView:self.targetViewController.view
                                  Title:self.title
                                 detail:self.message
                           cancelButton:cancelTitle
                               Okbutton:okTitle
                                  block:^(HHAlertButton buttonindex) {
                                      if (buttonindex == HHAlertButtonOk) {
                                          if (okBlock) {
                                              okBlock(self);
                                          }
                                      }
                                      else
                                      {
                                          if (cancelBlock) {
                                              cancelBlock(self);
                                          }
                                          
                                      }
                                      
                                      if (flag) {
                                          if (cancelBlock) {
                                              cancelBlock(self);
                                          }
                                      }
                                  }];
    }
}

- (void)dismiss {
    
}

@end
