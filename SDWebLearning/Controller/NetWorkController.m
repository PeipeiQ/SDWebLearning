//
//  NetWorkController.m
//  SDWebLearning
//
//  Created by peipei on 2018/5/10.
//  Copyright © 2018年 沛沛. All rights reserved.
//

#import "NetWorkController.h"

@interface NetWorkController ()

@end

@implementation NetWorkController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *btn0 = [[UIButton alloc]initWithFrame:CGRectMake(30, 80, 320, 24)];
    btn0.tag = 0;
    btn0.backgroundColor = [UIColor blueColor];
    [btn0 setTitle:@"展示get请求" forState:UIControlStateNormal];
    [btn0 addTarget:self action:@selector(urlSessionGet1) forControlEvents:UIControlEventTouchUpInside];
    UIButton *btn1 = [[UIButton alloc]initWithFrame:CGRectMake(30, 120, 320, 24)];
    btn1.tag = 1;
    btn1.backgroundColor = [UIColor redColor];
    [btn1 setTitle:@"展示post请求" forState:UIControlStateNormal];
    [btn1 addTarget:self action:@selector(urlSessionPost1) forControlEvents:UIControlEventTouchUpInside];
//
//    UIButton *btn3 = [[UIButton alloc]initWithFrame:CGRectMake(30, 160, 320, 24)];
//    btn3.backgroundColor = [UIColor purpleColor];
//    [btn3 setTitle:@"展示系统operation" forState:UIControlStateNormal];
//    [btn3 addTarget:self action:@selector(operationDemo) forControlEvents:UIControlEventTouchUpInside];
//    UIButton *btn4 = [[UIButton alloc]initWithFrame:CGRectMake(30, 200, 320, 24)];
//    btn4.backgroundColor = [UIColor darkGrayColor];
//    [btn4 setTitle:@"展示自定义的operation" forState:UIControlStateNormal];
//    [btn4 addTarget:self action:@selector(myOperation) forControlEvents:UIControlEventTouchUpInside];
//
//    UIButton *btn5 = [[UIButton alloc]initWithFrame:CGRectMake(30, 240, 320, 24)];
//    btn5.backgroundColor = [UIColor orangeColor];
//    [btn5 setTitle:@"取消operation" forState:UIControlStateNormal];
//    [btn5 addTarget:self action:@selector(cancelOperation) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self.view addSubview:btn0];
    [self.view addSubview:btn1];
//    [self.view addSubview:btn3];
//    [self.view addSubview:btn4];
//    [self.view addSubview:btn5];
}

//展示简单的urlSession的get请求的使用
-(void)urlSessionGet1{
    NSString *path = [NSString stringWithFormat:@"%@/content.json",BaseUrl];
    NSURL *url = [NSURL URLWithString:path];
    //构造请求
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    //配置请求
    request.HTTPMethod = @"GET";
    request.timeoutInterval = 10.0;
    
    //构造NSURLSessionConfiguration
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    //构造NSURLSession，网络会话；
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
    //构造NSURLSessionTask，会话任务；
    NSURLSessionTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        //请求到的数据以nsdata的数据格式返回
        NSLog(@"data:%@",data);
        //显示响应报文的信息
        NSLog(@"response:%@",response);
        //打印错误信息
        NSLog(@"error:%@",error);
        //将data数据转化为json格式
        id json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
        NSLog(@"json:%@",json);
        NSLog(@"显示当前所在的线程%@",[NSThread currentThread]);
    }];
    [task resume];
}

/*
 response打印出来的东西，可以一个个看(补充)
 { URL: http://localhost/content.json } { Status Code: 200, Headers {
 "Accept-Ranges" =     (
 bytes
 );
 Connection =     (
 "Keep-Alive"
 );
 "Content-Length" =     (
 520
 );
 "Content-Type" =     (
 "application/json"
 );
 Date =     (
 "Wed, 16 May 2018 14:20:28 GMT"
 );
 Etag =     (
 "\"208-56c523e4e7300\""
 );
 "Keep-Alive" =     (
 "timeout=5, max=100"
 );
 "Last-Modified" =     (
 "Wed, 16 May 2018 12:56:12 GMT"
 );
 Server =     (
 "Apache/2.4.25 (Unix)"
 );
 } }
 */

//简单的post请求
-(void)urlSessionPost1{
    NSString *path = [NSString stringWithFormat:@"%@/test/content.json",BaseUrl];
    NSURL *url = [NSURL URLWithString:path];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.timeoutInterval = 10.0;
    request.HTTPMethod = @"POST";
    
    //构造post请求的参数,并转为NSData对象
    NSDictionary *paraDic = @{@"id":@"123"};
    NSMutableString *paraStr = [[NSMutableString alloc]init];
    for (NSString *key in paraDic.allKeys) {
        [paraStr appendFormat:@"%@=%@&",key,paraDic[key]];
    }
    NSData *paraData = [[paraStr substringToIndex:paraStr.length-1] dataUsingEncoding:NSUTF8StringEncoding];
    
    request.HTTPBody = paraData;
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
    
    NSURLSessionTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        //请求到的数据以nsdata的数据格式返回
        NSLog(@"data:%@",data);
        //显示响应报文的信息
        NSLog(@"response:%@",response);
        //打印错误信息
        NSLog(@"error:%@",error);
        //将data数据转化为json格式
        id json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
        NSLog(@"json:%@",json);
        NSLog(@"显示当前所在的线程%@",[NSThread currentThread]);
    }];
    [task resume];
}














@end
