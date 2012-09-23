ShakingAlertView
===================

ShakingAlertView is a UIAlertView subclass with a password entry textfield. Incorrect password entry causes a "shake" animation similar to the OS X account login screen.

![screen](https://github.com/stringer630/ShakingAlertView/blob/master/screens/screen0.png?raw=true)

[Video Demo](https://github.com/stringer630/ShakingAlertView/blob/master/screens/video_demo.mov?raw=true)

## Usage

Use ShakingAlertView just like UIAlertView.

```
    ShakingAlertView *passwordAlert = [[ShakingAlertView alloc] initWithAlertTitle:@"Enter Password"
                                                                        checkForPassword:@"pass"];
    
    [passwordAlert setCorrectPasswordBlock:^{
        // Code to execute on correct password entry
    }];
    
    [passwordAlert setDismissedWithoutPasswordBlock:^{
        // Code to execute on alert dismissal without password entry
    }];
    
    [passwordAlert show];
    [passwordAlert release];
```

Rather than using a delegate, pass the instance a completion block to be executed for correct password entry and alert dismissal.

---

### Author

Follow me on twitter: [lukestringer90](twitter.com/lukestringer90)