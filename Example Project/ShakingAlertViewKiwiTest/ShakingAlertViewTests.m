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
    
    context(@"construction", ^{
        __block ShakingAlertView *shakingAlertView ;
        __block NSString *title;
        __block NSString *password;
        __block void (^correctPassword)(void);
        __block void (^dismissed)(void);
        
        beforeAll(^{
            shakingAlertView = nil;
            title = @"Test Title";
            password = @"password";
            correctPassword = ^(void) { NSLog(@"Correct Password"); };
            dismissed = ^(void) { NSLog(@"Dimssed"); };
        });
        
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
        
        it(@"should use HashTechniqueNone by default", ^{
            shakingAlertView = [[ShakingAlertView alloc] initWithAlertTitle:title
                                                           checkForPassword:password];
            [[theValue(shakingAlertView.hashTechnique) should] equal:theValue(HashTechniqueNone)];
        });
        
        it(@"should return specified password property after construction", ^{
            shakingAlertView = [[ShakingAlertView alloc] initWithAlertTitle:title
                                                           checkForPassword:password];
            [[shakingAlertView.password should] equal:password];
        });
        
        it(@"should return specified title property after construction", ^{
            shakingAlertView = [[ShakingAlertView alloc] initWithAlertTitle:title
                                                           checkForPassword:password];
            [[shakingAlertView.title should] equal:title];
        });
        
        it(@"should return specified HashTechnique property after construction", ^{
            shakingAlertView = [[ShakingAlertView alloc] initWithAlertTitle:title
                                                           checkForPassword:password usingHashingTechnique:HashTechniqueSHA1];
            [[theValue(shakingAlertView.hashTechnique) should] equal:theValue(HashTechniqueSHA1)];
        });
        
        it(@"should have valid public properties after construction", ^{
            shakingAlertView = [[ShakingAlertView alloc] initWithAlertTitle:title
                                                           checkForPassword:password
                                                      usingHashingTechnique:HashTechniqueMD5
                                                          onCorrectPassword:correctPassword
                                                 onDismissalWithoutPassword:dismissed];
            
            [shakingAlertView.title shouldNotBeNil];
            [shakingAlertView.password shouldNotBeNil];
            [shakingAlertView.onCorrectPassword shouldNotBeNil];
            [shakingAlertView.onDismissalWithoutPassword shouldNotBeNil];
            [theValue(shakingAlertView.hashTechnique) shouldNotBeNil];
            
        });

    });
    // context end
    // ----------------------------------------------
    
    context(@"alert view buttons tapped", ^{
        __block ShakingAlertView *shakingAlertView;
        __block NSString *title;
        __block NSString *password;
        
        beforeAll(^{
            shakingAlertView = nil;
            title = @"Test Title";
            password = @"password";
        });
        
        afterEach(^{
            [shakingAlertView release];
            shakingAlertView = nil;
        });
        
        it(@"should succeed with button tap and call block for correct password entry", ^{
            __block BOOL successReached = NO;
            __block BOOL failureReached = NO;
            __block int successReachedCount = 0;
            shakingAlertView = [[ShakingAlertView alloc] initWithAlertTitle:title
                                                           checkForPassword:password
                                                          onCorrectPassword:^{
                                                              successReached = YES;
                                                              successReachedCount++;
                                                          }
                                                 onDismissalWithoutPassword:^{
                                                     failureReached = YES;
                                                 }];
            [shakingAlertView show];
            
            // Type and tap OK button
            shakingAlertView.passwordField.text = @"password";
            [shakingAlertView.delegate alertView:shakingAlertView clickedButtonAtIndex:shakingAlertView.firstOtherButtonIndex];
            
            // Success block should be called once, and failure should not be called at all
            [[theValue(successReached) should] beTrue];
            [[theValue(failureReached) shouldNot] beTrue];
            [[theValue(successReachedCount) should] equal:theValue(1)];
        });
        
        it(@"should fail with button tap and call block for incorrect password entry", ^{
            __block BOOL successReached = NO;
            __block BOOL failureReached = NO;
            __block int failureReachedCount = 0;
            shakingAlertView = [[ShakingAlertView alloc] initWithAlertTitle:title
                                                           checkForPassword:password
                                                          onCorrectPassword:^{
                                                              successReached = YES;
                                                          }
                                                 onDismissalWithoutPassword:^{
                                                     failureReached = YES;
                                                     failureReachedCount++;
                                                 }];
            
            [shakingAlertView show];
            
            // Dismiss it with cancel button
            [shakingAlertView dismissWithClickedButtonIndex:shakingAlertView.cancelButtonIndex animated:YES];
            
            // Failure block should be called once, and sucess should not be called at all
            [[theValue(failureReached) should] beTrue];
            [[theValue(successReached) shouldNot] beTrue];
            [[theValue(failureReachedCount) should] equal:theValue(1)];
        });
        
        it(@"should shake with button for incorrect password entry", ^{
            __block BOOL successReached = NO;
            __block BOOL failureReached = NO;
            shakingAlertView = [[ShakingAlertView alloc] initWithAlertTitle:title
                                                           checkForPassword:password onCorrectPassword:^{
                                                               successReached = YES;
                                                           } onDismissalWithoutPassword:^{
                                                               failureReached = NO;
                                                           }];
            [shakingAlertView show];
            
            // Type and tap return
            // Test the view shakes for the incorrect password
            shakingAlertView.passwordField.text = @"incorrect_password";
            [[shakingAlertView should] receive:@selector(animateIncorrectPassword)];
            [shakingAlertView.delegate alertView:shakingAlertView clickedButtonAtIndex:shakingAlertView.firstOtherButtonIndex];
            
            // Neither of the completion blocks should have been called
            [[theValue(successReached) should] beFalse];
            [[theValue(successReached) should] beFalse];
        });
    });
    // context end
    // ----------------------------------------------
    
    context(@"return key tapped", ^{
        __block ShakingAlertView *shakingAlertView;
        __block NSString *title;
        __block NSString *password;
        
        beforeAll(^{
            shakingAlertView = nil;
            title = @"Test Title";
            password = @"password";
        });
        
        afterEach(^{
            [shakingAlertView release];
            shakingAlertView = nil;
        });
        
        it(@"should succeed with return key and call block for correct password entry", ^{
            __block BOOL successReached = NO;
            __block BOOL failureReached = NO;
            __block int successReachedCount = 0;
            shakingAlertView = [[ShakingAlertView alloc] initWithAlertTitle:title
                                                           checkForPassword:password
                                                          onCorrectPassword:^{
                                                              successReached = YES;
                                                              successReachedCount++;
                                                          }
                                                 onDismissalWithoutPassword:^{
                                                     failureReached = YES;
                                                 }];
            [shakingAlertView show];
            
            // Type and tap return key
            shakingAlertView.passwordField.text = @"password";
            [shakingAlertView textFieldShouldReturn:shakingAlertView.passwordField];
            
            // Success block should be called once, and failure should not be called at all
            [[theValue(successReached) should] beTrue];
            [[theValue(failureReached) shouldNot] beTrue];
            [[theValue(successReachedCount) should] equal:theValue(1)];
        });
        
        
        it(@"should shake with return key for incorrect password entry", ^{
            __block BOOL successReached = NO;
            __block BOOL failureReached = NO;
            shakingAlertView = [[ShakingAlertView alloc] initWithAlertTitle:title
                                                           checkForPassword:password onCorrectPassword:^{
                                                               successReached = YES;
                                                           } onDismissalWithoutPassword:^{
                                                               failureReached = NO;
                                                           }];
            [shakingAlertView show];
            
            // Type and tap return key
            // Test the view shakes for the incorrect password
            shakingAlertView.passwordField.text = @"incorrect_password";
            [[shakingAlertView should] receive:@selector(animateIncorrectPassword)];
            [shakingAlertView textFieldShouldReturn:shakingAlertView.passwordField];
            
            // Neither of the completion blocks should have been called
            [[theValue(successReached) should] beFalse];
            [[theValue(successReached) should] beFalse];
        });
    });
    
    // context end
    // ----------------------------------------------
    
    context(@"SHA1 password checking", ^{
        __block ShakingAlertView *shakingAlertView;
        __block NSString *title;
        __block NSString *SHA1Password;
        
        beforeAll(^{
            shakingAlertView = nil;
            title = @"Test Title";
            SHA1Password = @"W6ph5Mm5Pz8GgiULbPgzG37mj9g=";
        });
        
        afterEach(^{
            [shakingAlertView release];
            shakingAlertView = nil;
        });
        
        it(@"should succeed and call block for correct password entry using SHA1", ^{
            __block BOOL successReached = NO;
            __block BOOL failureReached = NO;
            __block int successReachedCount = 0;
            shakingAlertView = [[ShakingAlertView alloc] initWithAlertTitle:title
                                                           checkForPassword:SHA1Password
                                                      usingHashingTechnique:HashTechniqueSHA1
                                                          onCorrectPassword:^{
                                                              successReached = YES;
                                                              successReachedCount++;
                                                          }
                                                 onDismissalWithoutPassword:^{
                                                     failureReached = YES;
                                                 }];
            
            [shakingAlertView show];
            
            // Type and tap return key
            shakingAlertView.passwordField.text = @"password";
            [shakingAlertView textFieldShouldReturn:shakingAlertView.passwordField];
            
            // Success block should be called once, and failure should not be called at all
            [[theValue(successReached) should] beTrue];
            [[theValue(failureReached) shouldNot] beTrue];
            [[theValue(successReachedCount) should] equal:theValue(1)];
        });
        
        it(@"should fail and call block for incorrect password entry using SHA1", ^{
            __block BOOL successReached = NO;
            __block BOOL failureReached = NO;
            __block int failureReachedCount = 0;
            shakingAlertView = [[ShakingAlertView alloc] initWithAlertTitle:title
                                                           checkForPassword:SHA1Password
                                                      usingHashingTechnique:HashTechniqueSHA1
                                                          onCorrectPassword:^{
                                                              successReached = YES;
                                                          }
                                                 onDismissalWithoutPassword:^{
                                                     failureReached = YES;
                                                     failureReachedCount++;
                                                 }];
            
            [shakingAlertView show];
            
            // Dismiss it with cancel button
            [shakingAlertView dismissWithClickedButtonIndex:shakingAlertView.cancelButtonIndex animated:YES];
            
            // Failure block should be called once, and sucess should not be called at all
            [[theValue(failureReached) should] beTrue];
            [[theValue(successReached) shouldNot] beTrue];
            [[theValue(failureReachedCount) should] equal:theValue(1)];
        });
        
        it(@"should shake for incorrect password entry using SHA1", ^{
            __block BOOL successReached = NO;
            __block BOOL failureReached = NO;
            shakingAlertView = [[ShakingAlertView alloc] initWithAlertTitle:title
                                                           checkForPassword:SHA1Password
                                                      usingHashingTechnique:HashTechniqueSHA1
                                                          onCorrectPassword:^{
                                                               successReached = YES;
                                                           } onDismissalWithoutPassword:^{
                                                               failureReached = NO;
                                                           }];
            [shakingAlertView show];
            
            // Type and tap return
            // Test the view shakes for the incorrect password
            shakingAlertView.passwordField.text = @"incorrect_password";
            [[shakingAlertView should] receive:@selector(animateIncorrectPassword)];
            [shakingAlertView.delegate alertView:shakingAlertView clickedButtonAtIndex:shakingAlertView.firstOtherButtonIndex];
            
            // Neither of the completion blocks should have been called
            [[theValue(successReached) should] beFalse];
            [[theValue(successReached) should] beFalse];
        });

        
    });
    // context end
    // ----------------------------------------------
    
    context(@"MD5 password checking", ^{
        __block ShakingAlertView *shakingAlertView;
        __block NSString *title;
        __block NSString *MD5Password;
        
        beforeAll(^{
            shakingAlertView = nil;
            title = @"Test Title";
            MD5Password = @"X03MO1qnZdYdgyfeuILPmQ==";
        });
        
        afterEach(^{
            [shakingAlertView release];
            shakingAlertView = nil;
        });
        
        it(@"should succeed and call block for correct password entry using SHA1", ^{
            __block BOOL successReached = NO;
            __block BOOL failureReached = NO;
            __block int successReachedCount = 0;
            shakingAlertView = [[ShakingAlertView alloc] initWithAlertTitle:title
                                                           checkForPassword:MD5Password
                                                      usingHashingTechnique:HashTechniqueMD5
                                                          onCorrectPassword:^{
                                                              successReached = YES;
                                                              successReachedCount++;
                                                          }
                                                 onDismissalWithoutPassword:^{
                                                     failureReached = YES;
                                                 }];
            
            [shakingAlertView show];
            
            // Type and tap return key
            shakingAlertView.passwordField.text = @"password";
            [shakingAlertView textFieldShouldReturn:shakingAlertView.passwordField];
            
            // Success block should be called once, and failure should not be called at all
            [[theValue(successReached) should] beTrue];
            [[theValue(failureReached) shouldNot] beTrue];
            [[theValue(successReachedCount) should] equal:theValue(1)];
        });
        
        it(@"should fail and call block for incorrect password entry using SHA1", ^{
            __block BOOL successReached = NO;
            __block BOOL failureReached = NO;
            __block int failureReachedCount = 0;
            shakingAlertView = [[ShakingAlertView alloc] initWithAlertTitle:title
                                                           checkForPassword:MD5Password
                                                      usingHashingTechnique:HashTechniqueMD5
                                                          onCorrectPassword:^{
                                                              successReached = YES;
                                                          }
                                                 onDismissalWithoutPassword:^{
                                                     failureReached = YES;
                                                     failureReachedCount++;
                                                 }];
            
            [shakingAlertView show];
            
            // Dismiss it with cancel button
            [shakingAlertView dismissWithClickedButtonIndex:shakingAlertView.cancelButtonIndex animated:YES];
            
            // Failure block should be called once, and sucess should not be called at all
            [[theValue(failureReached) should] beTrue];
            [[theValue(successReached) shouldNot] beTrue];
            [[theValue(failureReachedCount) should] equal:theValue(1)];
        });
        
        it(@"should shake for incorrect password entry using SHA1", ^{
            __block BOOL successReached = NO;
            __block BOOL failureReached = NO;
            shakingAlertView = [[ShakingAlertView alloc] initWithAlertTitle:title
                                                           checkForPassword:MD5Password
                                                      usingHashingTechnique:HashTechniqueMD5
                                                          onCorrectPassword:^{
                                                              successReached = YES;
                                                          } onDismissalWithoutPassword:^{
                                                              failureReached = NO;
                                                          }];
            [shakingAlertView show];
            
            // Type and tap return
            // Test the view shakes for the incorrect password
            shakingAlertView.passwordField.text = @"incorrect_password";
            [[shakingAlertView should] receive:@selector(animateIncorrectPassword)];
            [shakingAlertView.delegate alertView:shakingAlertView clickedButtonAtIndex:shakingAlertView.firstOtherButtonIndex];
            
            // Neither of the completion blocks should have been called
            [[theValue(successReached) should] beFalse];
            [[theValue(successReached) should] beFalse];
        });


    });
    // context end
    // ----------------------------------------------
    
});

SPEC_END


