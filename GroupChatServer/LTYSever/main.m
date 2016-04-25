//
//  main.m
//  服务器监听
//
//  Created by Vincent_Guo on 15/9/11.
//  Copyright (c) 2015年 稳食哥 wechat:vg-ios. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ServertForward.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        NSLog(@"Hello, World!");
        // 1.创建服务监听器
        ServertForward *listener = [[ServertForward alloc] init];
        
        // 2.开始监听
        [listener start];
        
        // 开启主运行循环
        [[NSRunLoop mainRunLoop] run];
    }
    return 0;
}
