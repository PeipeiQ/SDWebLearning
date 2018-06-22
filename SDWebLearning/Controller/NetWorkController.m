//
//  NetWorkController.m
//  SDWebLearning
//
//  Created by peipei on 2018/5/10.
//  Copyright © 2018年 沛沛. All rights reserved.
//

#import "NetWorkController.h"

@interface NetWorkController ()<NSURLSessionDownloadDelegate>
/// 自定义session,设置代理
@property (nonatomic, strong) NSURLSession *downloadSession;
/// 全局的下载任务
@property (nonatomic, strong) NSURLSessionDownloadTask *downloadTask;
/// 保存续传数据
@property (nonatomic, strong) NSData *resumeData;
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

    UIButton *btn3 = [[UIButton alloc]initWithFrame:CGRectMake(30, 160, 320, 24)];
    btn3.backgroundColor = [UIColor purpleColor];
    [btn3 setTitle:@"展示文件上传" forState:UIControlStateNormal];
    [btn3 addTarget:self action:@selector(NSURLSessionBinaryUploadTaskTest) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *btn4 = [[UIButton alloc]initWithFrame:CGRectMake(30, 200, 320, 24)];
    btn4.backgroundColor = [UIColor darkGrayColor];
    [btn4 setTitle:@"文件下载" forState:UIControlStateNormal];
    [btn4 addTarget:self action:@selector(urlSessionBeginToDowload) forControlEvents:UIControlEventTouchUpInside];

//    UIButton *btn5 = [[UIButton alloc]initWithFrame:CGRectMake(30, 240, 320, 24)];
//    btn5.backgroundColor = [UIColor orangeColor];
//    [btn5 setTitle:@"取消operation" forState:UIControlStateNormal];
//    [btn5 addTarget:self action:@selector(cancelOperation) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self.view addSubview:btn0];
    [self.view addSubview:btn1];
    [self.view addSubview:btn3];
    [self.view addSubview:btn4];
    
    UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(100, 400, 50, 50)];
    [imgView sd_setImageWithURL:[NSURL URLWithString:@"https://images2018.cnblogs.com/news/24442/201806/24442-20180611171134854-1629599186.jpg"]];
    [self.view addSubview:imgView];
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
    NSString *path = [NSString stringWithFormat:@"%@:7070/api/user/register",BaseUrl];
    NSURL *url = [NSURL URLWithString:path];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.timeoutInterval = 10.0;
    request.HTTPMethod = @"POST";
    
    //构造post请求的参数,并转为NSData对象
    NSDictionary *paraDic = @{@"username":@"123",@"password":@"2134",@"repassword":@"2134"};
    NSMutableString *paraStr = [[NSMutableString alloc]init];
    for (NSString *key in paraDic.allKeys) {
        [paraStr appendFormat:@"%@=%@&",key,paraDic[key]];
    }
    NSData *paraData = [[paraStr substringToIndex:paraStr.length-1] dataUsingEncoding:NSUTF8StringEncoding];
    
    request.HTTPBody = paraData;
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
    
    NSURLSessionTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if(!error){
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
        }
    
    }];
    [task resume];
}

//文件上传
- (void) NSURLSessionBinaryUploadTaskTest {
    // 1.创建url  采用Apache本地服务器
    NSString *urlString = [NSString stringWithFormat:@"%@/test",BaseUrl];
//    urlString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    NSURL *url = [NSURL URLWithString:urlString];
    
    // 2.创建请求
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    // 文件上传使用post
    request.HTTPMethod = @"POST";
    
    [[[UIImageView alloc]init] sd_setImageWithURL:[NSURL URLWithString:@"https://ss0.bdstatic.com/5aV1bjqh_Q23odCf/static/superman/img/logo_top_ca79a146.png"] placeholderImage:nil options:0 completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        
    }];
    
    // 3.开始上传   request的body data将被忽略，而由fromData提供
    [[[NSURLSession sharedSession] uploadTaskWithRequest:request fromData:[NSData dataWithContentsOfFile:@"/Users/qiupei/Library/Developer/CoreSimulator/Devices/12C01CE7-3DD8-4640-87EA-8DCBE3D59322/data/Containers/Data/Application/BE31D0E3-FC5F-4BEB-9D95-DD778B56BA08/Library/Caches/default/com.hackemist.SDWebImageCache.default/837202ed431d343204a3c9b545a300ed.png"]     completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error == nil) {
            NSLog(@"upload success：%@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
        } else {
            NSLog(@"upload error:%@",error);
        }
    }] resume];
}

//文件下载
/*
 NSURLSession实现文件下载和断点下载
 NSURLSession实现文件下载时,使用代理去下载,内存就不暴涨,而且可以直接的检测到文件下载的进度
 NSURLSessionDownloadTask : 在使用它的时候,如果你遵守了代理,就不能使用回调,一旦使用了回调,代理就无效了.
 提示 : 代理和回调只能二选一.
 续传数据时,依然不能使用回调
 使用session实现文件下载时,文件下载结束之后,默认会删除,所以文件下载结束之后,需要我们手动的保存一份
 一旦指定了 session 的代理，session会对代理进行强引用，如果不主动取消 session，会造成内存泄漏！
 下载任务 一旦调用了cancel方法之后,就真的取消了.所以继续下载其实是新建一个下载任务去继续下载文件.
 */
-(NSURLSession *)downloadSession{
    if (!_downloadSession) {
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        _downloadSession = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:nil];
    }
    return _downloadSession;
}

-(void)urlSessionBeginToDowload{
    // 1. URL
    NSString *path = [NSString stringWithFormat:@"%@/book.pdf",BaseUrl];
    NSURL *url = [NSURL URLWithString:path];
    // 2. 发起下载任务
    /*
     NSURLSessionDownloadTask : 在使用它的时候,如果你遵守了代理,就不能使用回调,一旦使用了回调,代理就无效了.
     提示 : 代理和回调只能二选一
     */
    self.downloadTask = [self.downloadSession downloadTaskWithURL:url];
    // 3. 启动下载任务
    [self.downloadTask resume];
}

//暂停
- (void)pauseClick {
    [self.downloadTask cancelByProducingResumeData:^(NSData * _Nullable resumeData) {
        // resumeData : 续传数据,当暂停下载之后,会把续传的数据回调出去,方便我们做断点下载
        // resumeData : 已经下载的字节数...
        self.resumeData = resumeData;
        
        // 拿到续传数据之后,把续传数据保存在沙盒中,APP重启之后,就可以继续下载
        NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"resume.data"];
        [resumeData writeToFile:fullPath atomically:YES];
        
        // 当我们第一次点击暂停时,会成功的回调resumeData数据,但是再次点击时,就回调一个空的resumeData
        NSLog(@"%tu",resumeData.length);
        
        // 为了避免第二次点击暂停时,resumeData为空,
        self.downloadTask = nil;
    }];
    
    // suspend有时候不太靠谱,而且如果成功的暂停了,程序退出,再启动,不能实现继续下载
    //    [self.downloadTask suspend];
    NSLog(@"暂停");
}

//断点下载
- (void)resumeClick {
    // 0.541026 0.543065
    // 当内存中没有续传数据时,重新启动程序时
    if (self.resumeData == nil) {
        NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"resume.data"];
        NSData *resume_data = [NSData dataWithContentsOfFile:fullPath];
        if (resume_data == nil) {
            // 即没有内存续传数据,也没有沙盒续传数据,就续传了
            return;
        } else {
            // 当沙盒有续传数据时,在内存中保存一份
            self.resumeData = resume_data;
        }
    }
    
    // 续传数据时,依然不能使用回调
    // 续传数据时起始新发起了一个下载任务,因为cancel方法是把之前的下载任务干掉了 (类似于NSURLConnection的cancel)
    // resumeData : 当新建续传数据时,resumeData不能为空,一旦为空,就崩溃
    // downloadTaskWithResumeData :已经把Range封装进去了
    
    if (self.resumeData != nil) {
        self.downloadTask = [self.downloadSession downloadTaskWithResumeData:self.resumeData];
        // 重新发起续传任务时,也要手动的启动任务
        [self.downloadTask resume];
        NSLog(@"继续");
    }
}

#pragma -mark 下载的代理
-(void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite{
    // 计算进度
    float progress = (float)totalBytesWritten / totalBytesExpectedToWrite;
    NSLog(@"%f",progress);
}

-(void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location{
    NSLog(@"下载完成%@",downloadTask.response);
    NSLog(@"文件下载结束之后的缓存路径%@",location);
    NSLog(@"文件下载结束之后的缓存路径%@",location.path);
    //将下载的东西移动到硬盘
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *toPath = [documentPath stringByAppendingPathComponent:downloadTask.response.suggestedFilename];
    [[NSFileManager defaultManager] moveItemAtPath:location.path toPath:toPath error:nil];
}











@end
