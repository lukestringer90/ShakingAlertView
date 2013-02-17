//
//  ShakingAlertViewTests.m
//  ExampleProject
//
//  Created by Luke on 17/02/2013.
//  Copyright 2013 Luke Stringer. All rights reserved.
//

#import "Kiwi.h"
#import "ShakingAlertView.h"

SPEC_BEGIN(ShakingAlertViewTests)

describe(@"ShakingAlertView", ^{
    
    context(@"Seting up", ^{
        
        __block ShakingAlertView *shakingAlertView = nil;
        __block NSString *title = @"Test Title";
        __block NSString *password = @"password";
        __block void (^correctPassword)(void) = ^(void) { NSLog(@"Correct Password"); };
        __block void (^dismissed)(void) = ^(void) { NSLog(@"Dimssed"); };
        
        // Cleanup
        afterEach(^{
            [shakingAlertView release];
            shakingAlertView = nil;
        });
        
        it(@"should not be nil for plaitext password", ^{
            shakingAlertView = [[ShakingAlertView alloc] initWithAlertTitle:title
                                                           checkForPassword:password];
            [shakingAlertView shouldNotBeNil];
        });
        
        it(@"should not be nil for plaitext password with specified blocks", ^{
            shakingAlertView = [[ShakingAlertView alloc] initWithAlertTitle:title
                                                           checkForPassword:password
                                                          onCorrectPassword:correctPassword
                                                 onDismissalWithoutPassword:dismissed];
            [shakingAlertView shouldNotBeNil];
        });
        
    });
    
    context(@"Correct Password Entry", ^{
        //
    });
    
    context(@"Incorrect Passowrd Entry", ^{
        //
    });
    
});

SPEC_END


