//
//  NetworkUtil.h
//  SDWebLearning
//
//  Created by 沛沛 on 2018/5/30.
//  Copyright © 2018年 沛沛. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^successBlock)(id response,NSInteger httpStatusCode,NSDictionary* responseHeader);
typedef void(^errorBlock)(NSString *errorMessasge,NSError *error);

@interface NetworkUtil : NSObject
+(void)getFromUrl:(NSString*)urlString para:(NSDictionary*)paraDic successResult:(successBlock)successBlock errorResult:(errorBlock)errorBlock;
@end
