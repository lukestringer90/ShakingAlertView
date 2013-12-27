//
//  LJSShakingAlertView.m
//  LJSShakingAlertView
//
//  Created by Luke Stringer on 23/12/2013.
//  Copyright (c) 2013 Luke James Stringer. All rights reserved.
//

#import "LJSShakingAlertView.h"

@interface LJSShakingAlertView () <UIAlertViewDelegate>
@property (nonatomic, strong, readwrite) NSString *secretText;
@property (nonatomic, copy, readwrite) void (^completionHandler)(BOOL textEntryWasCorrect);
@property (nonatomic, strong, readwrite) NSString *cancelButtonTitle;
@property (nonatomic, strong, readwrite) NSString *otherButtonTitle;
@end

@implementation LJSShakingAlertView

- (instancetype)initWithTitle:(NSString *)title
                      message:(NSString *)message
                   secretText:(NSString *)secretText
                   completion:(void(^)(BOOL textEntryWasCorrect))completion
            cancelButtonTitle:(NSString *)cancelButtonTitle
             otherButtonTitle:(NSString *)otherButtonTitle {
    if (!secretText) {
        return nil;
    }
    
    self = [super initWithTitle:title
                        message:message
                       delegate:self
              cancelButtonTitle:cancelButtonTitle
              otherButtonTitles:otherButtonTitle, nil];
    
    if (self) {
        self.alertViewStyle = UIAlertViewStyleSecureTextInput;
        self.secretText = secretText;
        self.completionHandler = completion;
        self.cancelButtonTitle = cancelButtonTitle;
        self.otherButtonTitle = otherButtonTitle;
    }
    return self;
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    BOOL textEntryWasCorrect;
    
    if (self.cancelButtonIndex == buttonIndex) {
        textEntryWasCorrect = NO;
    }
    else {
        UITextField *secureTextField = [self textFieldAtIndex:0];
        textEntryWasCorrect = [secureTextField.text isEqualToString:self.secretText];
    }
    
    if (self.completionHandler) {
        self.completionHandler(textEntryWasCorrect);
    }
}

@end
