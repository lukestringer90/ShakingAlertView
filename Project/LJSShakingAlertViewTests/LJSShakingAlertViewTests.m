//
//  LJSShakingAlertViewTests.m
//  LJSShakingAlertView
//
//  Created by Luke Stringer on 23/12/2013.
//  Copyright (c) 2013 Luke James Stringer. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <LJSShakingAlertView/LJSShakingAlertView.h>

@interface LJSShakingAlertViewTests : XCTestCase
// sut is the "Subject Under Test"
@property (nonatomic, strong) LJSShakingAlertView *sut;
@end

@implementation LJSShakingAlertViewTests


#pragma mark - Initialisation tests
- (void)testInitialisesWithStoredProperties {
    void (^completion)(BOOL entryWasCorrect) = ^void(BOOL entryWasCorrect) {};
    
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
                                                               completion:nil
                                                        cancelButtonTitle:@"Cancel"
                                                         otherButtonTitle:@"OK"];
    
    XCTAssertEqual(_sut.alertViewStyle, (NSInteger)UIAlertViewStyleSecureTextInput, @"");
}


@end
