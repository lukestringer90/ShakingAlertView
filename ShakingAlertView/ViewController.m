//
//  ViewController.m
//  LSPasswordAlertView
//
//  Created by Luke on 21/09/2012.
//  Copyright (c) 2012 Luke Stringer. All rights reserved.
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
    [self setStatusLabel:nil];
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

- (IBAction)loginButtonTapped:(id)sender {
    
    ShackingAlertView *passwordAlert = [[ShackingAlertView alloc] initWithAlertTitle:@"Enter Password"
                                                                        checkForPassword:@"pass"];
    
    [passwordAlert setCorrectPasswordBlock:^{
        
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
    
    [passwordAlert setDismissedWithoutPasswordBlock:^{

        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"Failed Password Entry"
                              message:@"To access the password protected view you must enter a valid password. Try again?"
                              delegate:self
                              cancelButtonTitle:@"No"
                              otherButtonTitles:@"Yes", nil];
        [alert show];
        [alert release];
        
    }];
    
    [passwordAlert show];
    [passwordAlert release];
    
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex != alertView.cancelButtonIndex) {
        [self loginButtonTapped:nil];
    }
}


@end
