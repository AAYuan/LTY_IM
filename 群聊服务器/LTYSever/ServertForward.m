//
//  ServertForward.m
//  群聊服务器
//
//  Created by ayuan on 16/4/24..
//  Copyright (c) 2016 AYuan All rights reserved.
//

#import "ServertForward.h"
#import "GCDAsyncSocket.h"

@interface ServertForward()<GCDAsyncSocketDelegate>

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

@implementation ServertForward

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

#pragma mark - 有客户端socket连接到服务器

-(void)socket:(GCDAsyncSocket *)serverSocket didAcceptNewSocket:(GCDAsyncSocket *)clientSocket{

    NSLog(@"serverSocket %@",serverSocket);
    NSLog(@"%@ IP: %@: %zd 客户端请求连接...",clientSocket,clientSocket.connectedHost,clientSocket.connectedPort);
    // 1.将客户端socket保存起来
    [self.clientSockets addObject:clientSocket];
    
    // 2.一旦同意连接，监听客户端有没有数据上传，如果有数据会调用下面的代理方法
    //timeout -1 代表不超时
     //tag 标识作用，现在不用，就写0
    [clientSocket readDataWithTimeout:-1 tag:0];
    NSLog(@"当前有%ld客户已经连接到服务器",self.clientSockets.count);
    
}


#pragma mark 读取客户端请求的数据
-(void)socket:(GCDAsyncSocket *)clientSocket didReadData:(NSData *)data withTag:(long)tag{

    // 1.客户端 传递的数据 转成字符串
    NSString *clientStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    NSString *log = [NSString stringWithFormat:@"IP:%@ %zd data:%@",clientSocket.connectedHost,clientSocket.connectedPort, clientStr];
    NSLog(@"%@",log);
    [self.log appendString:log];
    [self.log writeToFile:@"/Users/Fung/Desktop/server.log" atomically:NO encoding:NSUTF8StringEncoding error:nil];
    
    // 将信息转发给其它已经连接的服务端
    for (GCDAsyncSocket *sokcet in self.clientSockets) {
        if (![clientSocket isEqual:sokcet]) {
            [self writeDataWithSocket:sokcet str:log];
        }
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
