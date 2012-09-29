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
    HashTechniqueNone   = 1,
    HashTechniqueSHA1   = 2,
    HashTechniqueMD5    = 3
    
} HashTechnique;


@interface ShakingAlertView : UIAlertView <UITextFieldDelegate>

@property (nonatomic, retain) NSString *password;

@property (nonatomic, copy) void(^correctPasswordBlock)();
@property (nonatomic, copy) void(^dismissedWithoutPasswordBlock)();

@property (assign) HashTechnique hashTechnique;

- (id)initWithAlertTitle:(NSString *)title
        checkForPassword:(NSString *)password;

- (id)initWithAlertTitle:(NSString *)title
        checkForPassword:(NSString *)password
   usingHashingTechnique:(HashTechnique)hashingTechnique;

- (id)initWithAlertTitle:(NSString *)title
        checkForPassword:(NSString *)password
   usingHashingTechnique:(HashTechnique)hashingTechnique
    correctPasswordBlock:(void(^)())correctPasswordBlock
dismissedWithoutPasswordBlock:(void(^)())dismissedWithoutPasswordBlock;

@end    

