//
//  ViewController.m
//  GroupChatClient
//
//  Created by AYuan on 16/4/25.
//  Copyright © 2016年 AYuan. All rights reserved.
//

#import "ViewController.h"
#import "GCDAsyncSocket.h"

@interface ViewController ()<UITableViewDataSource,GCDAsyncSocketDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextField *textField;

- (IBAction)sendM:(id)sender;
@property(nonatomic,strong)GCDAsyncSocket *socket;
/**数据源*/
@property(nonatomic,strong)NSMutableArray *dataSource;
@end

@implementation ViewController

-(NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    
    return _dataSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //实现聊天室
    // 1.连接到群聊服务器
    //1.1创建一个客户端的socket对象
    GCDAsyncSocket *socket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_global_queue(0, 0)];
    
    [socket connectToHost:@"127.0.0.1" onPort:5200 error:nil];
    self.socket = socket;
    
}



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ID = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    cell.textLabel.text = self.dataSource[indexPath.row];
    cell.textLabel.numberOfLines = 0;
    return cell;
}


-(void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag{
    
    // 1.读取数据
    NSString *dataStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"%@",dataStr);
    
    // 2.添加到数据源
    [self.dataSource addObject:dataStr];
    
    // 3.刷新数据
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [self.tableView reloadData];
    }];
    
    // 4.每次接收完数据，都要再次监听数据
    [sock readDataWithTimeout:-1 tag:0];
}

#pragma mark socket代理
-(void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port{
    NSLog(@"连接主机成功");
    // 监听数据
    [self.socket readDataWithTimeout:-1 tag:0];
}

-(void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err{
    NSLog(@"连接主机失败 %@",err);
}

- (IBAction)sendM:(id)sender {
    if (self.textField.text.length > 0) {
        // 发送数据到服务器
        [self.socket writeData:[self.textField.text dataUsingEncoding:NSUTF8StringEncoding] withTimeout:-1 tag:0];
        
        // 添加到数据源
        [self.dataSource addObject:self.textField.text];
        
        // 刷新
        [self.tableView reloadData];
    }

    
}
@end
