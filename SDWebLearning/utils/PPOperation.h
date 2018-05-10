//
//  PPOperation.h
//  Router
//
//  Created by peipei on 2018/4/23.
//  Copyright © 2018年 peipei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PPOperation : NSOperation
-(instancetype)initWithTarget:(id)atarget action:(SEL)aselector;
-(void)start;
@end
