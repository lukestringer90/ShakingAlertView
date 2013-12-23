//
//  LJSShakingAlertView.h
//  LJSShakingAlertView
//
//  Created by Luke Stringer on 23/12/2013.
//  Copyright (c) 2013 Luke James Stringer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LJSShakingAlertView : UIAlertView

- (id)initWithAlertTitle:(NSString *)title
                 message:(NSString *)message
        secretText:(NSString *)password
              completion:(void(^)(BOOL *))completion
       cancelButtonTitle:(NSString *)cancelButtonTitle
       otherButtonTitle:(NSString *)otherButtonTitle;

@end
