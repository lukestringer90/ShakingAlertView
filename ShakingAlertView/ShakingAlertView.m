//
//  ShakingAlertView.m
//
//  Created by Luke on 21/09/2012.
//  Copyright (c) 2012 Luke Stringer. All rights reserved.
//
//  https://github.com/stringer630/ShakingAlertView
//

#import "ShakingAlertView.h"
#include <CommonCrypto/CommonDigest.h>
#import "NSData+Base64.h"


@interface ShakingAlertView ()
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
    correctPasswordBlock:(void(^)())correctPasswordBlock
dismissedWithoutPasswordBlock:(void(^)())dismissedWithoutPasswordBlock {

    
    self = [self initWithAlertTitle:title checkForPassword:password usingHashingTechnique:hashingTechnique];
    if (self) {
        self.correctPasswordBlock = correctPasswordBlock;
        self.dismissedWithoutPasswordBlock = dismissedWithoutPasswordBlock;
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
                
                // Translate to left
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
    if (buttonIndex == 1) {
        
        if ([self enteredTextIsCorrect]) {
            
            // Hide keyboard
            [self.passwordField resignFirstResponder];
            
            // Dismiss with success
            [alertView dismissWithClickedButtonIndex:ShakingAlertViewButtonIndexSuccess animated:YES];
            _correctPasswordBlock();
            
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
        case ShakingAlertViewButtonIndexDismiss:
            [super dismissWithClickedButtonIndex:ShakingAlertViewButtonIndexDismiss animated:animated];
            _dismissedWithoutPasswordBlock();
            break;
        case ShakingAlertViewButtonIndexSuccess:
            [super dismissWithClickedButtonIndex:ShakingAlertViewButtonIndexDismiss animated:animated];
            _correctPasswordBlock();
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
    
    [super dealloc];
}


@end
