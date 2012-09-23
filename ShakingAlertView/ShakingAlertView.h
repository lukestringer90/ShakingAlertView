//
//  ShakingAlertView.h
//
//  Created by Luke on 21/09/2012.
//  Copyright (c) 2012 Luke Stringer. All rights reserved.
//
//  https://github.com/stringer630/ShakingAlertView
//

#import <UIKit/UIKit.h>


@interface ShakingAlertView : UIAlertView <UITextFieldDelegate>

@property (nonatomic, retain) NSString *password;

@property (nonatomic, copy) void(^correctPasswordBlock)();
@property (nonatomic, copy) void(^dismissedWithoutPasswordBlock)();

- (id)initWithAlertTitle:(NSString *)title
        checkForPassword:(NSString *)password;

- (id)initWithAlertTitle:(NSString *)title
        checkForPassword:(NSString *)password
    correctPasswordBlock:(void(^)())correctPasswordBlock
dismissedWithoutPasswordBlock:(void(^)())dismissedWithoutPasswordBlock;

@end    

@protocol LSAdminAlertViewDelegate <NSObject>

@end
