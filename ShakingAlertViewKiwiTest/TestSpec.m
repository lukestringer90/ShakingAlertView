//
//  TestSpec.m
//  ExampleProject
//
//  Created by Luke on 17/02/2013.
//  Copyright 2013 Luke Stringer. All rights reserved.
//

#import "Kiwi.h"


SPEC_BEGIN(TestSpec)

describe(@"NSString", ^{
    it(@"should have length 0 if there are no characters", ^{
        NSString *string = @"";
        [[theValue(string.length) should] equal:theValue(0)];
    });
});

SPEC_END


