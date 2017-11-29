//
//  ViewController.h
//  KonoWorker
//
//  Created by kuokuo on 2017/11/17.
//  Copyright © 2017年 Kono. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Google/SignIn.h>

@interface KWLoginViewController : UIViewController <GIDSignInDelegate,GIDSignInUIDelegate>

@property (weak, nonatomic) IBOutlet GIDSignInButton *signInButton;
@property (weak, nonatomic) IBOutlet UIButton *slackSingInButton;

@end

