//
//  LJSShakingAlertView.m
//  LJSShakingAlertView
//
//  Created by Luke Stringer on 23/12/2013.
//  Copyright (c) 2013 Luke James Stringer. All rights reserved.
//

#import "LJSShakingAlertView.h"

@interface LJSShakingAlertView ()
@property (nonatomic, strong, readwrite) NSString *secretText;
@property (nonatomic, copy, readwrite) void (^completionHandler)(BOOL entryWasCorrect);
@property (nonatomic, strong, readwrite) NSString *cancelButtonTitle;
@property (nonatomic, strong, readwrite) NSString *otherButtonTitle;
@end

@implementation LJSShakingAlertView

- initWithTitle:(NSString *)title
                         message:(NSString *)message
                      secretText:(NSString *)secretText
                      completion:(void(^)(BOOL entryWasCorrect))completion
               cancelButtonTitle:(NSString *)cancelButtonTitle
                otherButtonTitle:(NSString *)otherButtonTitle {
    self = [super initWithTitle:title
                        message:message
                       delegate:self
              cancelButtonTitle:cancelButtonTitle
              otherButtonTitles:otherButtonTitle, nil];
    if (self) {
        self.secretText = secretText;
        self.completionHandler = completion;
        self.cancelButtonTitle = cancelButtonTitle;
        self.otherButtonTitle = otherButtonTitle;
    }
    return self;
}

@end
