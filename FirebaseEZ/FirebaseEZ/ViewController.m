//
//  ViewController.m
//  FirebaseEZ
//
//  Created by Joan Molinas Ramon on 27/12/16.
//  Copyright © 2016 NSBeard. All rights reserved.
//

#import "ViewController.h"
#import "FEZAuth.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if ([FEZAuth currentUser]) {
        [self performSegueWithIdentifier:@"connectSegue" sender:self];
    }
}

- (IBAction)connect:(UIButton *)sender {
    __weak typeof(self) weakSelf = self;
    [FEZAuth signInWithEmail:@"joan@joan.com" password:@"123456789" successCallback:^(FIRUser * _Nullable user) {
        __strong typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf performSegueWithIdentifier:@"connectSegue" sender:self];
        NSLog(@"User logged -> %@", user.email);
    } failureCallback:^(NSError * _Nullable error) {
        NSLog(@"SignIn error -> %@", error.localizedDescription);
    }];
}



@end
