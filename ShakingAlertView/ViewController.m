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

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

- (IBAction)plainTextLoginTapped:(id)sender {
    
    // Make the alert
    ShakingAlertView *passwordAlert = [[ShakingAlertView alloc] initWithAlertTitle:@"Enter Password"
                                                                  checkForPassword:@"password"
                                                             usingHashingTechnique:HashTechniqueNone];
    
    // Block to excute on sucess
    [passwordAlert setOnCorrectPassword:^{
        
        // Show a modal view
        
        ModalViewController *modalVC = nil;
        
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
            modalVC = [[ModalViewController alloc] initWithNibName:@"ModalViewController_iPhone" bundle:nil];
        } else {
            modalVC = [[ModalViewController alloc] initWithNibName:@"ModalViewController_iPad" bundle:nil];
        }
        
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:modalVC];
        navController.modalPresentationStyle = UIModalPresentationFormSheet;
        
        [self presentModalViewController:navController animated:YES];
        [navController release];
        [modalVC release];
        
        
    }];
    
    // Block to execute on alert dismissal
    [passwordAlert setOnDismissalWithoutPassword:^{
        
        // Show regular UIAlertView to give them another go
        
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"Failed Password Entry"
                              message:@"To access the password protected view you must enter a valid password. Try again?"
                              delegate:self
                              cancelButtonTitle:@"No"
                              otherButtonTitles:@"Yes", nil];
        [alert show];
        [alert release];
        
    }];
    
    // Show and release
    [passwordAlert show];
    [passwordAlert release];
    
}

- (IBAction)sha1LoginTapped:(id)sender {
    // Make the alert
    ShakingAlertView *passwordAlert = [[ShakingAlertView alloc]
                                       initWithAlertTitle:@"Enter Password"
                                       checkForPassword:@"W6ph5Mm5Pz8GgiULbPgzG37mj9g=" //sha1 hash of 'password'
                                       usingHashingTechnique:HashTechniqueSHA1
                                       onCorrectPassword:^{
                                           // Show a modal view
                                           ModalViewController *modalVC = nil;
                                           
                                           if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
                                               modalVC = [[ModalViewController alloc] initWithNibName:@"ModalViewController_iPhone" bundle:nil];
                                           } else {
                                               modalVC = [[ModalViewController alloc] initWithNibName:@"ModalViewController_iPad" bundle:nil];
                                           }
                                           
                                           UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:modalVC];
                                           navController.modalPresentationStyle = UIModalPresentationFormSheet;
                                           
                                           [self presentModalViewController:navController animated:YES];
                                           [navController release];
                                           [modalVC release];
                                           
                                       }
                                       onDismissalWithoutPassword:^{
                                           // Show regular UIAlertView to give them another go
                                           UIAlertView *alert = [[UIAlertView alloc]
                                                                 initWithTitle:@"Failed Password Entry"
                                                                 message:@"To access the password protected view you must enter a valid password. Try again?"
                                                                 delegate:self
                                                                 cancelButtonTitle:@"No"
                                                                 otherButtonTitles:@"Yes", nil];
                                           [alert show];
                                           [alert release];
                                           
                                       }];
    
    
    // Show and release
    [passwordAlert show];
    [passwordAlert release];
    
}

- (IBAction)md5LoginTaped:(id)sender {
    
    // Make the alert
    ShakingAlertView *passwordAlert = [[ShakingAlertView alloc]
                                       initWithAlertTitle:@"Enter Password"
                                       checkForPassword:@"X03MO1qnZdYdgyfeuILPmQ==" //md5 hash of 'password'
                                       usingHashingTechnique:HashTechniqueMD5
                                       onCorrectPassword:^{
                                           // Show a modal view
                                           ModalViewController *modalVC = nil;
                                           
                                           if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
                                               modalVC = [[ModalViewController alloc] initWithNibName:@"ModalViewController_iPhone" bundle:nil];
                                           } else {
                                               modalVC = [[ModalViewController alloc] initWithNibName:@"ModalViewController_iPad" bundle:nil];
                                           }
                                           
                                           UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:modalVC];
                                           navController.modalPresentationStyle = UIModalPresentationFormSheet;
                                           
                                           [self presentModalViewController:navController animated:YES];
                                           [navController release];
                                           [modalVC release];
                                           
                                       }
                                       onDismissalWithoutPassword:^{
                                           // Show regular UIAlertView to give them another go
                                           UIAlertView *alert = [[UIAlertView alloc]
                                                                 initWithTitle:@"Failed Password Entry"
                                                                 message:@"To access the password protected view you must enter a valid password. Try again?"
                                                                 delegate:self
                                                                 cancelButtonTitle:@"No"
                                                                 otherButtonTitles:@"Yes", nil];
                                           [alert show];
                                           [alert release];
                                           
                                       }];
    
    
    // Show and release
    [passwordAlert show];
    [passwordAlert release];
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    
    // Give them another go at entering correct password
    if (buttonIndex != alertView.cancelButtonIndex) {
        [self plainTextLoginTapped:nil];
    }
}


@end
