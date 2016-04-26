//
//  LTYAddFreindViewController.m
//  AYuanChat
//
//  Created by AYuan on 16/4/26.
//  Copyright © 2016年 AYuan. All rights reserved.
//

#import "LTYAddFreindViewController.h"
#import "EMClient.h"

@interface LTYAddFreindViewController ()<EMContactManagerDelegate>

@property (weak, nonatomic) IBOutlet UITextField *userName;
@end

@implementation LTYAddFreindViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //注册好友回调
    [[EMClient sharedClient].contactManager addDelegate:self delegateQueue:nil];
}



/**
 添加好友
 */
- (IBAction)sendBtn:(id)sender {

    //1.获取要添加好友的名字
    NSString *username = self.userName.text;
    //2.向服务器发送一个添加好友的请求
    //message : 情趣添加好友的额外信息
    NSString *message = [@"我是" stringByAppendingString:username];
    EMError *error = [[EMClient sharedClient].contactManager addContact:username message:message];
    if (!error) {
        NSLog(@"添加成功");
    }
}

#pragma mark - EMContactManagerDelegate
- (void)didReceiveAgreedFromUsername:(NSString *)aUsername
{
    NSString *msgstr = [NSString stringWithFormat:@"%@同意了加好友申请", aUsername];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:msgstr delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alertView show];
}

- (void)didReceiveDeclinedFromUsername:(NSString *)aUsername
{
    NSString *msgstr = [NSString stringWithFormat:@"%@拒绝了加好友申请", aUsername];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:msgstr delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alertView show];
}

@end
