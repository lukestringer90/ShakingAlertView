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
        
        it(@"should not be nil for plaintext password and completion blocks", ^{
            shakingAlertView = [[ShakingAlertView alloc] initWithAlertTitle:title
                                                           checkForPassword:password
                                                          onCorrectPassword:correctPassword
                                                 onDismissalWithoutPassword:dismissed];
            [shakingAlertView shouldNotBeNil];
        });
        
        it(@"should not be nil when using HashTechniqueNone ", ^{
            shakingAlertView = [[ShakingAlertView alloc] initWithAlertTitle:title
                                                           checkForPassword:password
                                                      usingHashingTechnique:HashTechniqueNone];
            
            [shakingAlertView shouldNotBeNil];

        });
        
        it(@"should not be nil when using HashTechniqueSHA1 ", ^{
            shakingAlertView = [[ShakingAlertView alloc] initWithAlertTitle:title
                                                           checkForPassword:password
                                                      usingHashingTechnique:HashTechniqueSHA1];
            
            [shakingAlertView shouldNotBeNil];
            
        });
        
        it(@"should not be nil when using HashTechniqueMD5 ", ^{
            shakingAlertView = [[ShakingAlertView alloc] initWithAlertTitle:title
                                                           checkForPassword:password
                                                      usingHashingTechnique:HashTechniqueMD5];
            
            [shakingAlertView shouldNotBeNil];
            
        });
        
        it(@"should not be nil when using a HashTechnique and completion blocks", ^{
            shakingAlertView = [[ShakingAlertView alloc] initWithAlertTitle:title
                                                           checkForPassword:password
                                                      usingHashingTechnique:HashTechniqueMD5
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
        
        it(@"should succeed and call block for correct password entry", ^{
            __block BOOL successReached = NO;
            __block BOOL failureReached = NO;
            
            shakingAlertView = [[ShakingAlertView alloc] initWithAlertTitle:title
                                                           checkForPassword:password
                                                          onCorrectPassword:^{
                                                              successReached = YES;
                                                          }
                                                 onDismissalWithoutPassword:^{
                                                     failureReached = YES;
                                                 }];
            // Show it
            [shakingAlertView show];
            
            // Type password
            shakingAlertView.passwordField.text = @"password";
            
            // Done with typing
            [shakingAlertView textFieldShouldReturn:shakingAlertView.passwordField];
            
            // Sucess block should be called and failure should not be called
            [[theValue(successReached) should] beTrue];
            [[theValue(failureReached) shouldNot] beTrue];
            
        });
        
        
        it(@"should succeed and call block for correct password entry when block set after constrruction", ^{
            __block BOOL successReached = NO;
            
            // Setup
            shakingAlertView = [[ShakingAlertView alloc] initWithAlertTitle:title
                                                           checkForPassword:password];
            shakingAlertView.onCorrectPassword = ^{ successReached = YES; };

            // Show it
            [shakingAlertView show];
            
            // Type password
            shakingAlertView.passwordField.text = @"password";
            
            // Done with typing
            [shakingAlertView textFieldShouldReturn:shakingAlertView.passwordField];
            
            // Block should have been called
            [[theValue(successReached) should] beTrue];
            
        });
        
        
        it(@"should shake for incorrect password entry", ^{
            
            __block BOOL successReached = NO;
            __block BOOL failureReached = NO;
            shakingAlertView = [[ShakingAlertView alloc] initWithAlertTitle:title
                                                           checkForPassword:password onCorrectPassword:^{
                                                               successReached = YES;
                                                           } onDismissalWithoutPassword:^{
                                                               failureReached = NO;
                                                           }];
            // Show it
            [shakingAlertView show];
            
            // Type incorrect password
            shakingAlertView.passwordField.text = @"incorrect_password";
            
            // Should shake when done typing
            [[shakingAlertView should] receive:@selector(animateIncorrectPassword)];
            
            // Done with typing
            [shakingAlertView textFieldShouldReturn:shakingAlertView.passwordField];
            
            // Neither of the completion blocks should have been called
            [[theValue(successReached) should] beFalse];
            [[theValue(successReached) should] beFalse];
            
        });
        
        it(@"should fail and call block for incorrect password entry", ^{
            
            __block BOOL successReached = NO;
            __block BOOL failureReached = NO;
            shakingAlertView = [[ShakingAlertView alloc] initWithAlertTitle:title
                                                           checkForPassword:password
                                                          onCorrectPassword:^{
                                                              successReached = YES;
                                                          }
                                                 onDismissalWithoutPassword:^{
                                                     failureReached = YES;
                                                 }];
            
            // Show it
            [shakingAlertView show];
            
            // Dismiss it with cancel nutton
            [shakingAlertView dismissWithClickedButtonIndex:shakingAlertView.cancelButtonIndex animated:YES];
            
            // Failure block should be called and sucess should not be called
            [[theValue(failureReached) should] beTrue];
            [[theValue(successReached) shouldNot] beTrue];
            
        });
        
    });
    
});

SPEC_END


