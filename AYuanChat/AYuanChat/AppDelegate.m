//
//  AppDelegate.m
//  AYuanChat
//
//  Created by AYuan on 16/4/26.
//  Copyright © 2016年 AYuan. All rights reserved.
//

#import "AppDelegate.h"
#import "EMSDK.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSLog(@"%@",NSHomeDirectory());
    //AppKey:注册的appKey，详细见下面注释。
    //apnsCertName:推送证书名(不需要加后缀)，详细见下面注释。
    //1.初始化SDK,并隐藏环信SDK的日志输入
    EMOptions *options = [EMOptions optionsWithAppkey:@"ayuan#ayuanchat"];
    options.apnsCertName = @"nil";
    //设置日志
    options.logLevel = EMLogLevelWarning;
    [[EMClient sharedClient] initializeSDKWithOptions:options];
    
    //2.监听自动登录的状态
    if ([EMClient sharedClient].options.isAutoLogin) { //如果登录过，则直接来到主界面
        NSLog(@"自动登录");
        self.window.rootViewController = [UIStoryboard storyboardWithName:@"Main" bundle:nil].instantiateInitialViewController;
        }

    
    
    
    return YES;
}


// App进入后台
- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [[EMClient sharedClient] applicationDidEnterBackground:application];
}

// App将要从后台返回
- (void)applicationWillEnterForeground:(UIApplication *)application
{
    [[EMClient sharedClient] applicationWillEnterForeground:application];
}



- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
