//
//  PPOperation.m
//  Router
//
//  Created by peipei on 2018/4/23.
//  Copyright © 2018年 peipei. All rights reserved.
//

#import "PPOperation.h"

//继承operation

@interface PPOperation(){
    id target;
    SEL selector;
}
//考虑到线程执行的时间，这两个属性一般通过kvo来发出通知
@property (assign, nonatomic, getter = isExecuting) BOOL executing;
@property (assign, nonatomic, getter = isFinished) BOOL finished;
@end

@implementation PPOperation

//覆写了系统的属性需要手动合成
@synthesize executing = _executing;
@synthesize finished = _finished;

-(instancetype)initWithTarget:(id)atarget action:(SEL)aselector{
    if(self = [super init]){
        target = atarget;
        selector = aselector;
    }
    return self;
}


-(void)start{
    if ([target respondsToSelector:selector]){
        [target performSelector:selector];
    }
    if ([self isCancelled]) {
        return;
    }
    NSLog(@"这是一个异步任务");
    for (int i=0; i<10; i++) {
        if ([self isCancelled]) {
            self.finished = YES;
            self.executing = NO;
            break;
        }
        [NSThread sleepForTimeInterval:1];
        if (i==9) {
            self.finished = YES;
            self.executing = NO;
        }
    }
}

-(void)cancel{
    [super cancel];
    if (self.isExecuting) self.executing = NO;
    if (!self.isFinished) self.finished = YES;
}

/*
 我们用 @synthesize 关键字手动合成了两个实例变量 _executing 和 _finished ，然后分别在重写的 isExecuting 和 isFinished 方法中返回了这两个实例变量。另外，我们通过查看 NSOperation 类的头文件可以发现，executing 和 finished 属性都被声明成了只读的 readonly 。所以我们在 NSOperation 子类中就没有办法直接通过 setter 方法来自动触发 KVO 通知，这也是为什么我们需要在接下来的代码中手动触发 KVO 通知的原因。
 */
- (void)setFinished:(BOOL)finished {
    [self willChangeValueForKey:@"isFinished"];
    _finished = finished;
    [self didChangeValueForKey:@"isFinished"];
}

- (void)setExecuting:(BOOL)executing {
    [self willChangeValueForKey:@"isExecuting"];
    _executing = executing;
    [self didChangeValueForKey:@"isExecuting"];
}

-(BOOL)isExecuting{
    return _executing;
}

-(BOOL)isFinished{
    return _finished;
}

- (BOOL)isConcurrent {
    return YES;
}



@end
