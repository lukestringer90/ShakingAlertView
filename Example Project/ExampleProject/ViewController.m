//
//  ViewController.m
//  ShakingAlertView
//
//  Created by Luke on 21/09/2012.
//  Copyright (c) 2012 Luke Stringer. All rights reserved.
//
//
//

#import "ViewController.h"
#import "ModalViewController.h"

@implementation ViewController

#pragma mark - IBActions
- (IBAction)plainTextLoginTapped:(id)sender {
    
    // Make the alert
    // Here was are using a plantext password check
    ShakingAlertView *shakingAlert = [[ShakingAlertView alloc] initWithAlertTitle:@"Enter Password"
                                                                  checkForPassword:@"password"];
    
    // Block to excute on success
    [shakingAlert setOnCorrectPassword:^{
        // Show a modal view
        [self showModalView];
        
    }];
    
    // Block to execute on alert dismissal
    [shakingAlert setOnDismissalWithoutPassword:^{
        // Show regular UIAlertView to give them another go
        [self showFailedPasswordAlert];
        
    }];
    
    // Show and release
    [shakingAlert show];
    
}

- (IBAction)sha1LoginTapped:(id)sender {
    // Make the alert
    // Speficify we want to use SHA1 hashing
    ShakingAlertView *shakingAlert = [[ShakingAlertView alloc]
                                       initWithAlertTitle:@"Enter Password"
                                       checkForPassword:@"W6ph5Mm5Pz8GgiULbPgzG37mj9g=" //SHA1 hash of 'password'
                                      usingHashingTechnique:HashTechniqueSHA1];
    
    // Block to excute on success
    [shakingAlert setOnCorrectPassword:^{
        // Show a modal view
        [self showModalView];
        
    }];
    
    // Block to execute on alert dismissal
    [shakingAlert setOnDismissalWithoutPassword:^{
        // Show regular UIAlertView to give them another go
        [self showFailedPasswordAlert];
        
    }];
    
    
    // Show and release
    [shakingAlert show];
    
}

- (IBAction)md5LoginTaped:(id)sender {
    
    // Make the alert
    // Speficify we want to use MD5 hashing
    // Here we use a constructor that also takes the blocks
    ShakingAlertView *shakingAlert = [[ShakingAlertView alloc]
                                       initWithAlertTitle:@"Enter Password"
                                       checkForPassword:@"X03MO1qnZdYdgyfeuILPmQ==" //MD5 hash of 'password'
                                       usingHashingTechnique:HashTechniqueMD5
                                       onCorrectPassword:^{
                                           // Show a modal view
                                           [self showModalView];
                                       }
                                       onDismissalWithoutPassword:^{
                                           // Show regular UIAlertView to give them another go
                                           [self showFailedPasswordAlert];
                                           
                                       }];
    
    
    // Show and release
    [shakingAlert show];
}

#pragma mark - Others
- (void)showModalView {
    
    ModalViewController *modalVC = nil;
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        modalVC = [[ModalViewController alloc] initWithNibName:@"ModalViewController_iPhone" bundle:nil];
    } else {
        modalVC = [[ModalViewController alloc] initWithNibName:@"ModalViewController_iPad" bundle:nil];
    }
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:modalVC];
    navController.modalPresentationStyle = UIModalPresentationFormSheet;
    
    [self presentModalViewController:navController animated:YES];

}

- (void)showFailedPasswordAlert {
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@"Failed Password Entry"
                          message:@"To access the password protected view you must enter a valid password. Try again?"
                          delegate:self
                          cancelButtonTitle:@"No"
                          otherButtonTitles:@"Yes", nil];
    [alert show];
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    
    // Give them another go at entering correct password
    if (buttonIndex != alertView.cancelButtonIndex) {
        [self plainTextLoginTapped:nil];
    }
}


@end
