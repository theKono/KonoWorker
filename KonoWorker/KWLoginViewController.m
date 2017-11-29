//
//  ViewController.m
//  KonoWorker
//
//  Created by kuokuo on 2017/11/17.
//  Copyright © 2017年 Kono. All rights reserved.
//

#import "KWLoginViewController.h"
#import "KWMainViewController.h"
#import "KWWorker.h"

@interface KWLoginViewController ()

@end

@implementation KWLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [GIDSignIn sharedInstance].delegate = self;
    [GIDSignIn sharedInstance].uiDelegate = self;
    
    
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    if ([KWWorker worker].userID) {
        [self enterRecordPage];
    }
    else {
        [[GIDSignIn sharedInstance] signInSilently];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)enterRecordPage {

    UIStoryboard *storyboard;
    storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    
    KWMainViewController *ulvc = [storyboard instantiateViewControllerWithIdentifier:@"KWMainViewController"];
    
    UINavigationController *naviVC = [[UINavigationController alloc] initWithRootViewController:ulvc];
    
    [self presentViewController:naviVC animated:YES completion:^{
        
    }];
    
}

#pragma mark - GIDSignInDelegate

- (void)signIn:(GIDSignIn *)signIn
didSignInForUser:(GIDGoogleUser *)user
     withError:(NSError *)error {

    if( nil == error) {
        KWWorker *currentWorker = [KWWorker worker];
        currentWorker.userID = user.userID;
        currentWorker.userName = user.profile.name;
        currentWorker.userEmail = user.profile.email;
        if (user.profile.hasImage) {
            currentWorker.userImageURLString = [[user.profile imageURLWithDimension:120] absoluteString];
        }
        [self enterRecordPage];
    }
}

- (void)signIn:(GIDSignIn *)signIn
didDisconnectWithUser:(GIDGoogleUser *)user
     withError:(NSError *)error {
    // Perform any operations when the user disconnects from app here.
    // ...
}



- (IBAction)signInBtnPressed:(id)sender {
    
    [[GIDSignIn sharedInstance] signIn];

}


@end
