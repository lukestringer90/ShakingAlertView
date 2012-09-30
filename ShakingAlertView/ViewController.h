//
//  ViewController.h
//  ShakingAlertView
//
//  Created by Luke on 21/09/2012.
//  Copyright (c) 2012 Luke Stringer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShakingAlertView.h"


@interface ViewController : UIViewController <UIAlertViewDelegate>

- (IBAction)plainTextLoginTapped:(id)sender;
- (IBAction)sha1LoginTapped:(id)sender;
- (IBAction)md5LoginTaped:(id)sender;

@end
