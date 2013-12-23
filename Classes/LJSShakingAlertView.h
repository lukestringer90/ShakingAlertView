//
//  LJSShakingAlertView.h
//  LJSShakingAlertView
//
//  Created by Luke Stringer on 23/12/2013.
//  Copyright (c) 2013 Luke James Stringer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LJSShakingAlertView : UIAlertView

@property (nonatomic, strong, readonly) NSString *secretText;
@property (nonatomic, copy, readonly) void (^completionHandler)(BOOL entryWasCorrect);
@property (nonatomic, strong, readonly) NSString *cancelButtonTitle;
@property (nonatomic, strong, readonly) NSString *otherButtonTitle;

- (instancetype)initWithTitle:(NSString *)title
                      message:(NSString *)message
                   secretText:(NSString *)secretText
                   completion:(void(^)(BOOL entryWasCorrect))completion
            cancelButtonTitle:(NSString *)cancelButtonTitle
             otherButtonTitle:(NSString *)otherButtonTitle;

@end
