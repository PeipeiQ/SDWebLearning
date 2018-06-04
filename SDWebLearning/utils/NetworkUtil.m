//
//  NetworkUtil.m
//  SDWebLearning
//
//  Created by 沛沛 on 2018/5/30.
//  Copyright © 2018年 沛沛. All rights reserved.
//

#import "NetworkUtil.h"

@interface NetworkUtil()

@end

@implementation NetworkUtil
+(void)getFromUrl:(NSString*)urlString para:(NSDictionary*)paraDic successResult:(successBlock)successBlock errorResult:(errorBlock)errorBlock{
    urlString = [NSString stringWithFormat:@"%@%@",BaseUrl,urlString];
    if (paraDic.count>0) {
        NSArray *allKeys = [paraDic allKeys];
        NSMutableString *paraString = [NSMutableString new];
        [allKeys enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [paraString appendFormat:@"%@=%@&",obj,paraDic[obj]];
        }];
        urlString = [NSString stringWithFormat:@"%@?%@",urlString,[paraString substringToIndex:paraString.length-1]];
    }
    NSLog(@"请求url:%@", urlString);
    
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0];
    request.HTTPMethod = @"Get";
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        //模拟网络延时
        [NSThread sleepForTimeInterval:1.0];
        if (error) {
            NSString *errorMessage = @"";
            errorBlock(errorMessage,error);
            return ;
        }

        //解析response
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)response;
        NSString *responseType = httpResponse.allHeaderFields[@"Content-Type"];
        //NSString *subtype = [[responseType componentsSeparatedByString:@"/"] firstObject];
        //NSString *parameterType = [[responseType componentsSeparatedByString:@"/"] lastObject];
        
        if ([responseType rangeOfString:@"application/json"].location !=NSNotFound) {
            //json转字典
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
            NSLog(@"response json:%@",json);
            successBlock(json,httpResponse.statusCode,httpResponse.allHeaderFields);
            return;
        }
        if ([responseType rangeOfString:@"image"].location !=NSNotFound) {
            UIImage *image = [UIImage imageWithData:data];
            NSLog(@"image:%@",image);
            successBlock(image,httpResponse.statusCode,httpResponse.allHeaderFields);
            return;
        }
        successBlock(data,httpResponse.statusCode,httpResponse.allHeaderFields);
    }];
    [task resume];
}
@end
