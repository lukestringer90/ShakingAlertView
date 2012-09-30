//
//  ShakingAlertView.m
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

#import "ShakingAlertView.h"
#include <CommonCrypto/CommonDigest.h>
#import "NSData+Base64.h"


@interface ShakingAlertView ()
// Private property as other instances shouldn't interact with this directly
@property (nonatomic, strong) UITextField *passwordField;
@end

// Enum for alert view button index
typedef enum {
    ShakingAlertViewButtonIndexDismiss = 0,
    ShakingAlertViewButtonIndexSuccess = 10
} ShakingAlertViewButtonIndex;

@implementation ShakingAlertView

#pragma mark - Constructors

- (id)initWithAlertTitle:(NSString *)title
        checkForPassword:(NSString *)password{
    
    self = [super initWithTitle:title     
                        message:@"---blank---" // password field will go here
                       delegate:self 
              cancelButtonTitle:@"Cancel" 
              otherButtonTitles:@"Enter", nil];
    if (self) {
        self.password = password;
        self.hashTechnique = HashTechniqueNone; // use no hashing by default
    }

    return self;
}

- (id)initWithAlertTitle:(NSString *)title
        checkForPassword:(NSString *)password
       onCorrectPassword:(void(^)())correctPasswordBlock
onDismissalWithoutPassword:(void(^)())dismissalWithoutPasswordBlock {
    
    self = [self initWithAlertTitle:title checkForPassword:password];
    if (self) {
        self.onCorrectPassword = correctPasswordBlock;
        self.onDismissalWithoutPassword = dismissalWithoutPasswordBlock;
    }
    
    
    return self;
    
}

- (id)initWithAlertTitle:(NSString *)title
        checkForPassword:(NSString *)password
   usingHashingTechnique:(HashTechnique)hashingTechnique {
    
    self = [self initWithAlertTitle:title checkForPassword:password];
    if (self) {
        self.hashTechnique = hashingTechnique;
    }
    return self;
    
}

- (id)initWithAlertTitle:(NSString *)title
        checkForPassword:(NSString *)password
   usingHashingTechnique:(HashTechnique)hashingTechnique
       onCorrectPassword:(void(^)())correctPasswordBlock
onDismissalWithoutPassword:(void(^)())dismissalWithoutPasswordBlock {

    
    self = [self initWithAlertTitle:title checkForPassword:password usingHashingTechnique:hashingTechnique];
    if (self) {
        self.onCorrectPassword = correctPasswordBlock;
        self.onDismissalWithoutPassword = dismissalWithoutPasswordBlock;
    }

    
    return self;
    
}

// Override show method to add the password field
- (void)show {
    
    // Textfield for the password
    // Position it over the message section of the alert
    UITextField *passwordField = [[UITextField alloc] initWithFrame:CGRectMake(14, 45, 256, 25)];
    passwordField.secureTextEntry = YES;
    passwordField.placeholder = @"password";
    passwordField.backgroundColor = [UIColor whiteColor];
    
    // Pad out the left side of the view to properly inset the text
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 6, 19)];
    passwordField.leftView = paddingView;
    [paddingView release];
    passwordField.leftViewMode = UITextFieldViewModeAlways;
    
    // Set delegate
    passwordField.delegate = self;
    
    // Set as property
    self.passwordField = passwordField;
    [passwordField release];

    // Add to subview
    [self addSubview:_passwordField];
    
    // Show alert
    [super show];
    
    // present keyboard for text entry
    [_passwordField performSelector:@selector(becomeFirstResponder) withObject:nil afterDelay:0.1]; 
    
}

- (void)animateIncorrectPassword {
    // Clear the password field
    _passwordField.text = nil;
    
    // Animate the alert to show that the entered string was wrong
    // "Shakes" similar to OS X login screen
    CGAffineTransform moveRight = CGAffineTransformTranslate(CGAffineTransformIdentity, 20, 0);
    CGAffineTransform moveLeft = CGAffineTransformTranslate(CGAffineTransformIdentity, -20, 0);
    CGAffineTransform resetTransform = CGAffineTransformTranslate(CGAffineTransformIdentity, 0, 0);
    
    [UIView animateWithDuration:0.1 animations:^{
        // Translate left
        self.transform = moveLeft;
        
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:0.1 animations:^{
            
            // Translate right
            self.transform = moveRight;
            
        } completion:^(BOOL finished) {
            
            [UIView animateWithDuration:0.1 animations:^{
                
                // Translate left
                self.transform = moveLeft;
                
            } completion:^(BOOL finished) {
                
                [UIView animateWithDuration:0.1 animations:^{
                    
                    // Translate to origin
                    self.transform = resetTransform;
                }];
            }];
            
        }];
    }];

}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    // If "Enter" button pressed on alert view then check password
    if (buttonIndex == alertView.firstOtherButtonIndex) {
        
        if ([self enteredTextIsCorrect]) {
            
            // Hide keyboard
            [self.passwordField resignFirstResponder];
            
            // Dismiss with success
            [alertView dismissWithClickedButtonIndex:ShakingAlertViewButtonIndexSuccess animated:YES];
            _onCorrectPassword();
            
        }
        
        // If incorrect then animate
        else {
            [self animateIncorrectPassword];
        }
    }
}


// Overide to customise when alert is dimsissed
- (void)dismissWithClickedButtonIndex:(NSInteger)buttonIndex animated:(BOOL)animated {

    // Only dismiss for ShakingAlertViewButtonIndexDismiss or ShakingAlertViewButtonIndexSuccess
    // This means we don't dissmis for the case where "Enter" button is pressed and password is incorrect
    switch (buttonIndex) {
        case ShakingAlertViewButtonIndexSuccess:
            [super dismissWithClickedButtonIndex:ShakingAlertViewButtonIndexDismiss animated:animated];
            _onCorrectPassword();
            break;
        case ShakingAlertViewButtonIndexDismiss:
            [super dismissWithClickedButtonIndex:ShakingAlertViewButtonIndexDismiss animated:animated];
            _onDismissalWithoutPassword();
            break;
        default:
            break;
    }

}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {    
    // Check password
    if ([self enteredTextIsCorrect]) {
        
        // Hide keyboard
        [self.passwordField resignFirstResponder];
        
        // Dismiss with success
        [self dismissWithClickedButtonIndex:ShakingAlertViewButtonIndexSuccess animated:YES];
        
        return YES;
    }
    
    // Password is incorrect to so animate
    [self animateIncorrectPassword];
    return NO;
}

- (BOOL)enteredTextIsCorrect {
    switch (_hashTechnique) {
            
        // No hashing algorithm used
        case HashTechniqueNone:
            return [_passwordField.text isEqualToString:_password];
            break;
        
            
        // SHA1 used
        case HashTechniqueSHA1: {
            
            unsigned char digest[CC_SHA1_DIGEST_LENGTH];
            NSData *stringBytes = [_passwordField.text dataUsingEncoding: NSUTF8StringEncoding];
            CC_SHA1([stringBytes bytes], [stringBytes length], digest);
            
            NSData *pwHashData = [[NSData alloc] initWithBytes:digest length:CC_SHA1_DIGEST_LENGTH];
            NSString *hashedEnteredPassword = [pwHashData base64EncodedString];
            [pwHashData release];
            
            return [hashedEnteredPassword isEqualToString:_password];

        }
            break;
        
        
        // MD5 used    
        case HashTechniqueMD5: {
            
            unsigned char digest[CC_MD5_DIGEST_LENGTH];
            NSData *stringBytes = [_passwordField.text dataUsingEncoding: NSUTF8StringEncoding];
            CC_MD5([stringBytes bytes], [stringBytes length], digest);
            
            NSData *pwHashData = [[NSData alloc] initWithBytes:digest length:CC_MD5_DIGEST_LENGTH];
            NSString *hashedEnteredPassword = [pwHashData base64EncodedString];
            [pwHashData release];
            
            return [hashedEnteredPassword isEqualToString:_password];
            
        }
            break;
            
        default:
            break;
    }
    
    
    // To stop Xcode complaining return NO by default
    return NO;
    
}

#pragma mark - Memory Managment
- (void)dealloc {
    [_passwordField release];
    [_password release];
    [_onCorrectPassword release];
    [_onDismissalWithoutPassword release];
    
    [super dealloc];
}


@end
