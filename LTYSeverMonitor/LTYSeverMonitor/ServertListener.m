//
//  ServertListener.m
//  服务器监听
//
//  Created by ayuan on 16/4/24.
//  Copyright (c) 2016. All rights reserved.
//

#import "ServertListener.h"
#import "GCDAsyncSocket.h"

@interface ServertListener()<GCDAsyncSocketDelegate>

/**
 * 服务端Socket
 */
@property(nonatomic,strong)GCDAsyncSocket *serverSocket;

/*
 * 所有的客户端
 */
@property(nonatomic,strong)NSMutableArray *clientSockets;

@property(nonatomic,strong)NSMutableString *log;//日志

@end

@implementation ServertListener

-(NSMutableString *)log{
    if (!_log) {
        _log = [NSMutableString string];
    }
    
    return _log;
}

-(NSMutableArray *)clientSockets{
    if (!_clientSockets) {
        _clientSockets = [NSMutableArray array];
    }
    
    return _clientSockets;
}

-(instancetype)init{
    if (self = [super init]) {
        self.serverSocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_global_queue(0, 0)];
    }
    
    return self;
}


-(void)start{
    NSError *error = nil;
    BOOL success = [self.serverSocket acceptOnPort:5200 error:&error];
    if (success) {
        NSLog(@"5200端口开启成功,并监听客户端请求连接...");
    }else{
        NSLog(@"5200端口开启失...");
    }
}

#pragma mark -代理
-(void)socket:(GCDAsyncSocket *)serverSocket didAcceptNewSocket:(GCDAsyncSocket *)clientSocket{

    NSLog(@"%@ IP: %@: %zd 客户端请求连接...",clientSocket,clientSocket.connectedHost,clientSocket.connectedPort);
    // 1.将客户端socket保存起来
    [self.clientSockets addObject:clientSocket];
    
    // 2.一旦同意连接，监听数据读取，如果有数据会调用下面的代理方法
    [clientSocket readDataWithTimeout:-1 tag:0];
    
    // 3.返回 "服务" 选项
    NSMutableString *options = [NSMutableString string];
    [options appendString:@"欢迎来到LTY在线服务 请输入下面的数字选择服务\n"];
    [options appendString:@"[0]在线问答\n"];
    [options appendString:@"[1]在线反馈\n"];
    [options appendString:@"[2]在线活动\n"];
    [options appendString:@"[3]其他服务\n"];
    [options appendString:@"[4]退出\n"];
    NSData *data = [options dataUsingEncoding:NSUTF8StringEncoding];
    [clientSocket writeData:data withTimeout:-1 tag:0];
}



-(void)socket:(GCDAsyncSocket *)clientSocket didReadData:(NSData *)data withTag:(long)tag{

    // 1.客户端 传递的数据 转成字符串
    NSString *clientStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    NSString *log = [NSString stringWithFormat:@"IP:%@ %zd data:%@\n",clientSocket.connectedHost,clientSocket.connectedPort, clientStr];
    NSLog(@"%@",log);
    [self.log appendString:log];
    [self.log writeToFile:@"/Users/Fung/Desktop/server.log" atomically:NO encoding:NSUTF8StringEncoding error:nil];
    
    NSInteger serverCode = [clientStr integerValue];
    switch (serverCode) {
        case 0:
            [self writeDataWithSocket:clientSocket str:@"现在没有客户问答噢～\n"];
            break;
        case 1:
            [self writeDataWithSocket:clientSocket str:@"反馈暂停，服务器维护中～\n"];
            break;
        case 2:
            [self writeDataWithSocket:clientSocket str:@"你想要什么服务\n"];
            break;
        case 3:
            [self writeDataWithSocket:clientSocket str:@"呵呵..\n"];
            break;
        case 4:
            [self exitWithSocket:clientSocket];
            break;

        default:
            [self writeDataWithSocket:clientSocket str:@"请按规则出牌...\n"];
            break;
    }
    
    // 2.监听数据读取
   [clientSocket readDataWithTimeout:-1 tag:0];
}



-(void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag{

    NSLog(@"数据发送成功..");
}

-(void)exitWithSocket:(GCDAsyncSocket *)clientSocket{
    [self writeDataWithSocket:clientSocket str:@"成功退出\n"];
    [self.clientSockets removeObject:clientSocket];
    
    NSLog(@"当前在线用户个数:%ld",self.clientSockets.count);
}

#pragma mark -私有方法
#pragma mark -写数据
-(void)writeDataWithSocket:(GCDAsyncSocket *)clientSocket str:(NSString *)str{
    
    [clientSocket writeData:[str dataUsingEncoding:NSUTF8StringEncoding] withTimeout:-1 tag:0];
    
}

@end
