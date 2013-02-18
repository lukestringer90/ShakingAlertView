//
//  ShakingAlertViewTests.m
//  ExampleProject
//
//  Created by Luke on 17/02/2013.
//  Copyright 2013 Luke Stringer. All rights reserved.
//

#import "Kiwi.h"
#import "ShakingAlertView.h"

// Mirror the class extension in ShakingAlertView.m so we can get to the private parts of the class
@interface ShakingAlertView ()
@property (nonatomic, strong) UITextField *passwordField;
- (void)animateIncorrectPassword;
@end


SPEC_BEGIN(ShakingAlertViewTests)

describe(@"ShakingAlertView", ^{
    
    context(@"being set up", ^{
        
        __block ShakingAlertView *shakingAlertView = nil;
        __block NSString *title = @"Test Title";
        __block NSString *password = @"password";
        __block void (^correctPassword)(void) = ^(void) { NSLog(@"Correct Password"); };
        __block void (^dismissed)(void) = ^(void) { NSLog(@"Dimssed"); };
        
        // Cleaup
        afterEach(^{
            [shakingAlertView release];
            shakingAlertView = nil;
        });
        
        it(@"should not be nil for plaitext password", ^{
            shakingAlertView = [[ShakingAlertView alloc] initWithAlertTitle:title
                                                           checkForPassword:password];
            [shakingAlertView shouldNotBeNil];
        });
        
        it(@"should not be nil for plaintext password with specified blocks", ^{
            shakingAlertView = [[ShakingAlertView alloc] initWithAlertTitle:title
                                                           checkForPassword:password
                                                          onCorrectPassword:correctPassword
                                                 onDismissalWithoutPassword:dismissed];
            [shakingAlertView shouldNotBeNil];
        });
        
    });
    
    context(@"received a password", ^{
        __block ShakingAlertView *shakingAlertView = nil;
        __block NSString *title = @"Test Title";
        __block NSString *password = @"password";
        
        // Cleaup
        afterEach(^{
            [shakingAlertView release];
            shakingAlertView = nil;
        });
        
        it(@"should call success block for correct password entry", ^{
            __block BOOL successReached = NO;
            
            shakingAlertView = [[ShakingAlertView alloc] initWithAlertTitle:title
                                                           checkForPassword:password
                                                          onCorrectPassword:^{
                                                              successReached = YES;
                                                          }
                                                 onDismissalWithoutPassword:nil];
            // Show it
            [shakingAlertView show];
            
            // Type password
            shakingAlertView.passwordField.text = @"password";
            
            // Done with typing
            [shakingAlertView textFieldShouldReturn:shakingAlertView.passwordField];
            
            // Block should be called
            [[theValue(successReached) should] beTrue];
            
        });
        
        it(@"should shake for incorrect password entry", ^{
            
            shakingAlertView = [[ShakingAlertView alloc] initWithAlertTitle:title
                                                           checkForPassword:password];
            // Show it
            [shakingAlertView show];
            
            // Type incorrect password
            shakingAlertView.passwordField.text = @"incorrect_password";
            
            // Should shake when done typing
            [[shakingAlertView should] receive:@selector(animateIncorrectPassword)];
            
            // Done with typing
            [shakingAlertView textFieldShouldReturn:shakingAlertView.passwordField];
            
            
        });
        
    });
    
});

SPEC_END


