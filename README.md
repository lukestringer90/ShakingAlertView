ShakingAlertView
===================

ShakingAlertView is a UIAlertView subclass with a password entry textfield. Incorrect password entry causes a "shake" animation similar to the OS X account login screen.

![screen](https://github.com/stringer630/ShakingAlertView/blob/master/screens/screen0.png?raw=true)

[Video Demo](https://github.com/stringer630/ShakingAlertView/blob/master/screens/video_demo.mov?raw=true)

## Usage
### Plain text password

Use ShakingAlertView just like UIAlertView. For a checking a plain text password:

```
    ShakingAlertView *shakingAlert = nil;
    shakingAlert = [[ShakingAlertView alloc] initWithAlertTitle:@"Enter Password"
                                                checkForPassword:@"pass"];
    
    [shakingAlert setCorrectPasswordBlock:^{
        // Code to execute on correct password entry
    }];
    
    [shakingAlert setDismissedWithoutPasswordBlock:^{
        // Code to execute on alert dismissal without password entry
    }];
    
    [shakingAlert show];
    [shakingAlert release];
```

Rather than using a delegate, pass the instance a completion block to be executed for correct password entry and alert dismissal.

### Hashed passwords

ShakingAlertView uses the [Common Crypto](https://developer.apple.com/library/mac/documentation/security/Conceptual/cryptoservices/GeneralPurposeCrypto/GeneralPurposeCrypto.html#//apple_ref/doc/uid/TP40011172-CH9-SW4) C API to hash the entered text to SHA1 or MD5. Therefore if you only know the hashed counterpart of a password string you can specify this along with the hashing algorithm type in the constructor. 

```
    ShakingAlertView *shakingAlert = nil;
    shakingAlert = [[ShakingAlertView alloc] initWithAlertTitle:@"Enter Password"
                                                checkForPassword:@"W6ph5Mm5Pz8GgiULbPgzG37mj9g=" //sha1 hash of 'password'
                                           usingHashingTechnique:HashTechniqueSHA1];
```

The hashing algorithm to use is defined by an enum and passed into the constructor.
```
typedef enum {
	HashTechniqueNone,
    HashTechniqueSHA1,
    HashTechniqueMD5
} HashTechnique;
```

`HashTechniqueNone` is used if no technique is specified, like in the `initWithAlertTitle:checkForPassword` constructor.

## Acknowledgements
`NSData+Base64.h/m` and `b64.h/m` from [aqtoolkit](https://github.com/AlanQuatermain/aqtoolkit) by [AlanQuatermain](https://github.com/AlanQuatermain)

---

### Author

Follow me on twitter: [lukestringer90](http://twitter.com/lukestringer90)
