//
//  ShakingAlertView.h
//
//  Created by Luke on 21/09/2012.
//  Copyright (c) 2012 Luke Stringer. All rights reserved.
//
//  https://github.com/stringer630/ShakingAlertView
//

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

