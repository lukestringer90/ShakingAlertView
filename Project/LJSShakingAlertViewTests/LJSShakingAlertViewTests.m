//
//  LJSShakingAlertViewTests.m
//  LJSShakingAlertView
//
//  Created by Luke Stringer on 23/12/2013.
//  Copyright (c) 2013 Luke James Stringer. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <LJSShakingAlertView/LJSShakingAlertView.h>
#import <OCMock/OCMock.h>

@interface LJSShakingAlertView (TestVisibility) <UIAlertViewDelegate>

@end

@interface LJSShakingAlertViewTests : XCTestCase
// sut is the "Subject Under Test"
@property (nonatomic, strong) LJSShakingAlertView *sut;
@end

@implementation LJSShakingAlertViewTests

#pragma mark - Helper
- (id)partialMockShakingAlertView:(LJSShakingAlertView *)shakingAlertView stubbedWithSecureTextFieldWithText:(NSString *)secureEntryText {
    id shakingPartialMock = [OCMockObject partialMockForObject:shakingAlertView];
    id secureTextFieldMock = [OCMockObject mockForClass:[UITextField class]];
    [[[secureTextFieldMock stub] andReturn:secureEntryText] text];
    [[[shakingPartialMock stub] andReturn:secureTextFieldMock] textFieldAtIndex:0];
    return shakingPartialMock;
}

#pragma mark - Initialisation tests
- (void)testInitialisesWithStoredProperties {
    void (^completion)(BOOL textEntryWasCorrect) = ^void(BOOL textEntryWasCorrect) {};
    
    _sut = [[LJSShakingAlertView alloc] initWithTitle:@"Title"
                                              message:@"Message."
                                           secretText:@"password"
                                           completion:completion
                                    cancelButtonTitle:@"Cancel"
                                     otherButtonTitle:@"OK"];
    
    XCTAssertNotNil(_sut, @"");
    XCTAssertEqualObjects(_sut.title, @"Title", @"");
    XCTAssertEqualObjects(_sut.message, @"Message.", @"");
    XCTAssertEqualObjects(_sut.secretText, @"password", @"");
    XCTAssertEqualObjects(_sut.completionHandler, completion, @"");
    XCTAssertEqualObjects(_sut.cancelButtonTitle, @"Cancel", @"");
    XCTAssertEqualObjects(_sut.otherButtonTitle, @"OK", @"");
}

- (void)testInitialisesWithSecureInputeAlertViewStyle {
    _sut = [[LJSShakingAlertView alloc] initWithTitle:@"Title"
                                              message:@"Message."
                                           secretText:@"password"
                                           completion:^void(BOOL textEntryWasCorrect) {}
                                    cancelButtonTitle:@"Cancel"
                                     otherButtonTitle:@"OK"];
    
    XCTAssertEqual(_sut.alertViewStyle, (NSInteger)UIAlertViewStyleSecureTextInput, @"");
}

- (void)testReturnsNilWhenInitialisedWithoutSecretText {
    _sut = [[LJSShakingAlertView alloc] initWithTitle:@"Title"
                                              message:@"Message."
                                           secretText:nil
                                           completion:^void(BOOL textEntryWasCorrect) {}
                                    cancelButtonTitle:@"Cancel"
                                     otherButtonTitle:@"OK"];
    XCTAssertNil(_sut, @"");
}

#pragma mark - Completion handler tests
- (void)testCallsCompletionHandlerForCorrectTextEntry {
    __block BOOL completionBlockWasCalled;
    __block BOOL capturedTextEntryWasCorrectValue;
    _sut = [[LJSShakingAlertView alloc] initWithTitle:@"Title"
                                              message:@"Message."
                                           secretText:@"password"
                                           completion:^void(BOOL textEntryWasCorrect) {
                                               completionBlockWasCalled = YES;
                                               capturedTextEntryWasCorrectValue = textEntryWasCorrect;
                                           }
                                    cancelButtonTitle:@"Cancel"
                                     otherButtonTitle:@"OK"];
    
    // Stub the secure text field with a mock text field specific text
    id sutMock = [self partialMockShakingAlertView:_sut stubbedWithSecureTextFieldWithText:@"password"];
    
    // "tap OK button"
    [[sutMock delegate] alertView:sutMock clickedButtonAtIndex:1];
    
    XCTAssertTrue(completionBlockWasCalled, @"");
    XCTAssertTrue(capturedTextEntryWasCorrectValue, @"");
}

- (void)testCallsCompletionHandlerForIncorrectTextEntry {
    __block BOOL completionBlockWasCalled;
    __block BOOL capturedTextEntryWasCorrectValue;
    _sut = [[LJSShakingAlertView alloc] initWithTitle:@"Title"
                                              message:@"Message."
                                           secretText:@"password"
                                           completion:^void(BOOL textEntryWasCorrect) {
                                               completionBlockWasCalled = YES;
                                               capturedTextEntryWasCorrectValue = textEntryWasCorrect;
                                           }
                                    cancelButtonTitle:@"Cancel"
                                     otherButtonTitle:@"OK"];
    
    // Stub the secure text field with a mock text field specific text
    id sutMock = [self partialMockShakingAlertView:_sut stubbedWithSecureTextFieldWithText:@"incorrect-secure-text"];
    
    // "tap OK button"
    [sutMock alertView:sutMock clickedButtonAtIndex:1];
    
    XCTAssertTrue(completionBlockWasCalled, @"");
    XCTAssertFalse(capturedTextEntryWasCorrectValue, @"");

}

@end
