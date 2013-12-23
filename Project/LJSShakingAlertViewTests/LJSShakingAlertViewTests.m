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

@end

@implementation LJSShakingAlertViewTests

- (void)testInitialisesWithStoredProperties {
    void (^completion)(BOOL entryWasCorrect) = ^void(BOOL entryWasCorrect) {};
    
    LJSShakingAlertView *sut = [[LJSShakingAlertView alloc] initWithTitle:@"Title"
                                                                  message:@"Message."
                                                               secretText:@"password"
                                                               completion:completion
                                                        cancelButtonTitle:@"Cancel"
                                                         otherButtonTitle:@"OK"];
    
    XCTAssertNotNil(sut, @"");
    XCTAssertEqualObjects(sut.title, @"Title", @"");
    XCTAssertEqualObjects(sut.message, @"Message.", @"");
    XCTAssertEqualObjects(sut.secretText, @"password", @"");
    XCTAssertEqualObjects(sut.completionHandler, completion, @"");
    XCTAssertEqualObjects(sut.cancelButtonTitle, @"Cancel", @"");
    XCTAssertEqualObjects(sut.otherButtonTitle, @"OK", @"");
}

@end
