//
//  ShakingAlertView.h
//
//  Created by Luke on 21/09/2012.
//  Copyright (c) 2012 Luke Stringer. All rights reserved.
//
//  https://github.com/stringer630/ShakingAlertView
//

//  This code is distributed under the terms and conditions of the MIT license.
// 
//  Copyright (c) 2012 Luke Stringer
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

#import <UIKit/UIKit.h>

typedef enum {
    HashTechniqueNone,
    HashTechniqueSHA1,
    HashTechniqueMD5
} HashTechnique;


@interface ShakingAlertView : UIAlertView <UITextFieldDelegate>

@property (nonatomic, retain) NSString *password;

@property (nonatomic, copy) void(^onCorrectPassword)();
@property (nonatomic, copy) void(^onDismissalWithoutPassword)();

@property (assign) HashTechnique hashTechnique;


// Constructors for plaintext password
- (id)initWithAlertTitle:(NSString *)title
        checkForPassword:(NSString *)password;

- (id)initWithAlertTitle:(NSString *)title
        checkForPassword:(NSString *)password
       onCorrectPassword:(void(^)())correctPasswordBlock
onDismissalWithoutPassword:(void(^)())dismissalWithoutPasswordBlock;


// Constructors for hashed passwords
- (id)initWithAlertTitle:(NSString *)title
        checkForPassword:(NSString *)password
   usingHashingTechnique:(HashTechnique)hashingTechnique;

- (id)initWithAlertTitle:(NSString *)title
        checkForPassword:(NSString *)password
   usingHashingTechnique:(HashTechnique)hashingTechnique
    onCorrectPassword:(void(^)())correctPasswordBlock
onDismissalWithoutPassword:(void(^)())dismissalWithoutPasswordBlock;

@end    

