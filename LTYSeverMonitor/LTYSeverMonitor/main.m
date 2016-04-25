//
//  main.m
//  服务器监听
//
//  Created by ayuan on 16/4/24.
//  Copyright (c) 2016. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ServertListener.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        NSLog(@"Hello, World!");
        // 1.创建服务监听器
        ServertListener *listener = [[ServertListener alloc] init];
        
        // 2.开始监听
        [listener start];
        
        // 开启主运行循环
        [[NSRunLoop mainRunLoop] run];
    }
    return 0;
}
