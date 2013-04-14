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
    
    // ------------------------------------------------------------------------
    
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
    
    // ------------------------------------------------------------------------
    
    context(@"received a password for plaintext checking", ^{
        
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
            [shakingAlertView show];
    
            // Type and tap return
            shakingAlertView.passwordField.text = @"password";
            [shakingAlertView textFieldShouldReturn:shakingAlertView.passwordField];
            
            [[theValue(successReached) should] beTrue];
            [[theValue(failureReached) shouldNot] beTrue];
        });
        
        
        it(@"should succeed and call block for correct password entry when block set after constrruction", ^{
            __block BOOL successReached = NO;
            shakingAlertView = [[ShakingAlertView alloc] initWithAlertTitle:title
                                                           checkForPassword:password];
            shakingAlertView.onCorrectPassword = ^{
                successReached = YES;
            };

            [shakingAlertView show];
            
            // Type and tap return
            shakingAlertView.passwordField.text = @"password";
            [shakingAlertView textFieldShouldReturn:shakingAlertView.passwordField];
            
            [[theValue(successReached) should] beTrue]; 
        });
        
        it(@"should succeed and call the completion block ONCE only when enter pressed", ^{
            __block int successReachedCount = 0;
            shakingAlertView = [[ShakingAlertView alloc] initWithAlertTitle:title
                                                           checkForPassword:password];
            shakingAlertView.onCorrectPassword = ^{
                successReachedCount++;
            };
            
            [shakingAlertView show];
            
            // Type and tap return
            shakingAlertView.passwordField.text = @"password";
            [shakingAlertView textFieldShouldReturn:shakingAlertView.passwordField];
            
            [[theValue(successReachedCount) should] equal:theValue(1)];
        });
        
        it(@"should succeed and call the completion block ONCE only when OK button tapped", ^{
            __block int successReachedCount = 0;
            shakingAlertView = [[ShakingAlertView alloc] initWithAlertTitle:title
                                                           checkForPassword:password];
            shakingAlertView.onCorrectPassword = ^{
                successReachedCount++;
            };
            
            [shakingAlertView show];
            
            // Type and tap return
            shakingAlertView.passwordField.text = @"password";
            [shakingAlertView.delegate alertView:shakingAlertView clickedButtonAtIndex:shakingAlertView.firstOtherButtonIndex];
            
            [[theValue(successReachedCount) should] equal:theValue(1)];
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
            [shakingAlertView show];
            
            // Type and tap return
            // Test the view shakes for the incorrect password
            shakingAlertView.passwordField.text = @"incorrect_password";
            [[shakingAlertView should] receive:@selector(animateIncorrectPassword)];
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
            
            [shakingAlertView show];
            
            // Dismiss it with cancel button
            [shakingAlertView dismissWithClickedButtonIndex:shakingAlertView.cancelButtonIndex animated:YES];
            
            // Failure block should be called and sucess should not be called
            [[theValue(failureReached) should] beTrue];
            [[theValue(successReached) shouldNot] beTrue]; 
        });
        
        it(@"should fail and call block for incorrect password entry when block set after construction", ^{
            __block BOOL failureReached = NO;
            shakingAlertView = [[ShakingAlertView alloc] initWithAlertTitle:title
                                                           checkForPassword:password];
            shakingAlertView.onDismissalWithoutPassword = ^{
                failureReached = YES;
            };
            
            [shakingAlertView show];
            
            // Dismiss it with cancel nutton
            [shakingAlertView dismissWithClickedButtonIndex:shakingAlertView.cancelButtonIndex animated:YES];
            
            // Failure block should be called
            [[theValue(failureReached) should] beTrue];
        });
        
        it(@"should fail and call the completion block ONCE only", ^{
            // Setup
            __block int failureReachedCount = 0;
            shakingAlertView = [[ShakingAlertView alloc] initWithAlertTitle:title
                                                           checkForPassword:password];
            shakingAlertView.onDismissalWithoutPassword = ^{
                failureReachedCount++;
            };
            
            // Dismiss it with cancel nutton
            [shakingAlertView dismissWithClickedButtonIndex:shakingAlertView.cancelButtonIndex animated:YES];
            
            // Failure block should be called
            [shakingAlertView textFieldShouldReturn:shakingAlertView.passwordField];
            
            // Test
            [[theValue(failureReachedCount) should] equal:theValue(1)];
        });
        
        it(@"should fail and call the completion block ONCE only when OK button tapped", ^{
            // Setup
            __block int failureReachedCount = 0;
            shakingAlertView = [[ShakingAlertView alloc] initWithAlertTitle:title
                                                           checkForPassword:password];
            shakingAlertView.onDismissalWithoutPassword = ^{
                failureReachedCount++;
            };
            
            // Dismiss it with cancel button
            [shakingAlertView dismissWithClickedButtonIndex:shakingAlertView.cancelButtonIndex animated:YES];
            
            // Press OK button
            [shakingAlertView.delegate alertView:shakingAlertView clickedButtonAtIndex:shakingAlertView.firstOtherButtonIndex];
            
            [[theValue(failureReachedCount) should] equal:theValue(1)];
        });

        
    });
    
    // ------------------------------------------------------------------------
    
    context(@"recieved a password for SHA1 testing", ^{
        
        __block ShakingAlertView *shakingAlertView = nil;
        __block NSString *title = @"Test Title";
        __block NSString *SHA1Password = @"W6ph5Mm5Pz8GgiULbPgzG37mj9g=";
        
        // Cleaup
        afterEach(^{
            [shakingAlertView release];
            shakingAlertView = nil;
        });
        
        it(@"should succeed and call block for correct password entry using SHA1 specified in constructor", ^{
            // Setup
            __block BOOL successReached = NO;
            __block BOOL failureReached = NO;
            shakingAlertView = [[ShakingAlertView alloc] initWithAlertTitle:title
                                                           checkForPassword:SHA1Password
                                                      usingHashingTechnique:HashTechniqueSHA1
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
            
            [[theValue(successReached) should] beTrue];
            [[theValue(failureReached) shouldNot] beTrue];
        });
        
        it(@"should succeed and call block for correct password entry using SHA1 specified after construction", ^{
            // Setup
            __block BOOL successReached = NO;
            __block BOOL failureReached = NO;
            shakingAlertView = [[ShakingAlertView alloc] initWithAlertTitle:title
                                                           checkForPassword:SHA1Password
                                                          onCorrectPassword:^{
                                                              successReached = YES;
                                                          }
                                                 onDismissalWithoutPassword:^{
                                                     failureReached = YES;
                                                 }];
            shakingAlertView.hashTechnique = HashTechniqueSHA1;
            
            // Show it
            [shakingAlertView show];
            
            // Type password
            shakingAlertView.passwordField.text = @"password";
            
            // Done with typing
            [shakingAlertView textFieldShouldReturn:shakingAlertView.passwordField];
            
            [[theValue(successReached) should] beTrue];
            [[theValue(failureReached) shouldNot] beTrue];
        });
        
    });
    
    
    // ------------------------------------------------------------------------
    
    context(@"recieved a password for MD5 testing", ^{
        
        __block ShakingAlertView *shakingAlertView = nil;
        __block NSString *title = @"Test Title";
        __block NSString *MD5Password = @"X03MO1qnZdYdgyfeuILPmQ==";
        
        it(@"should succeed and call block for correct password entry using MD5 specified in constructor", ^{
            // Setup
            __block BOOL successReached = NO;
            __block BOOL failureReached = NO;
            shakingAlertView = [[ShakingAlertView alloc] initWithAlertTitle:title
                                                           checkForPassword:MD5Password
                                                      usingHashingTechnique:HashTechniqueMD5
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
            
            [[theValue(successReached) should] beTrue];
            [[theValue(failureReached) shouldNot] beTrue];
        });
        
        it(@"should succeed and call block for correct password entry using MD5 specified after construction", ^{
            // Setup
            __block BOOL successReached = NO;
            __block BOOL failureReached = NO;
            shakingAlertView = [[ShakingAlertView alloc] initWithAlertTitle:title
                                                           checkForPassword:MD5Password
                                                          onCorrectPassword:^{
                                                              successReached = YES;
                                                          }
                                                 onDismissalWithoutPassword:^{
                                                     failureReached = YES;
                                                 }];
            shakingAlertView.hashTechnique = HashTechniqueMD5;
            
            // Show it
            [shakingAlertView show];
            
            // Type password
            shakingAlertView.passwordField.text = @"password";
            
            // Done with typing
            [shakingAlertView textFieldShouldReturn:shakingAlertView.passwordField];
            
            [[theValue(successReached) should] beTrue];
            [[theValue(failureReached) shouldNot] beTrue];
        });

    });
    
    
    // ------------------------------------------------------------------------
    
});

SPEC_END


