//
//  LJSViewController.m
//  LJSShakingAlertView
//
//  Created by Luke Stringer on 23/12/2013.
//  Copyright (c) 2013 Luke James Stringer. All rights reserved.
//

#import "LJSViewController.h"

@interface LJSViewController ()

@end

@implementation LJSViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@"Title"
                          message:@"message"
                          delegate:nil
                          cancelButtonTitle:@"thing"
                          otherButtonTitles: nil];
    [alert setAlertViewStyle:UIAlertViewStyleSecureTextInput];
    [alert show];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
