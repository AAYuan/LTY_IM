//
//  ViewController.m
//  AYuanChat
//
//  Created by AYuan on 16/4/26.
//  Copyright © 2016年 AYuan. All rights reserved.
//

#import "ViewController.h"
#import "EMSDK.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *userName;
@property (weak, nonatomic) IBOutlet UITextField *password;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}
- (IBAction)registerBtn:(id)sender {
    
    if (!(self.userName.text.length || self.password.text.length)) {
        NSLog(@"请输入用户名或密码");
    }else {//开启异步线程进行登录操作
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            EMError *error = [[EMClient sharedClient] registerWithUsername:self.userName.text  password:self.password.text];
            //注册完成后回到主线程
            dispatch_async(dispatch_get_main_queue(), ^{
                if (!error) {
                    NSLog(@"注册成功");
                }
            });
        });
    }

}

- (IBAction)loginBtn:(id)sender {

    if (!(self.userName.text.length || self.password.text.length)) {
        NSLog(@"请输入用户名或密码");
    }else {//开启异步线程进行登录操作
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            EMError *error = [[EMClient sharedClient] loginWithUsername:self.userName.text password:self.password.text];
            //登录完成后回到主线程
            dispatch_async(dispatch_get_main_queue(), ^{
                if (!error) {
                    NSLog(@"登陆成功");
                    //登录成功后设置开启自动登录
                    [[EMClient sharedClient].options setIsAutoLogin:YES];
                    //来到主界面
                    self.view.window.rootViewController = [UIStoryboard storyboardWithName:@"Main" bundle:nil].instantiateInitialViewController;
                } else {
                    NSLog(@"登录失败 %@",error);
                    
                }
                
            });
            
            
        });
    }
}

@end
