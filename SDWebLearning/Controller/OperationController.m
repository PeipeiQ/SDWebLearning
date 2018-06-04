//
//  OperationController.m
//  SDWebLearning
//
//  Created by peipei on 2018/5/10.
//  Copyright © 2018年 沛沛. All rights reserved.
//

#import "OperationController.h"
#import "PPOperation.h"

@interface OperationController ()
@property(nonatomic,strong) NSOperation *operation;
@property(nonatomic,strong) NSOperationQueue *operationQueue;
@end

@implementation OperationController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *btn0 = [[UIButton alloc]initWithFrame:CGRectMake(30, kStatusBarAndNavigationBarHeight+30, 320, 24)];
    btn0.tag = 0;
    btn0.backgroundColor = [UIColor blueColor];
    [btn0 setTitle:@"展示dispatch_barrier_sync" forState:UIControlStateNormal];
    [btn0 addTarget:self action:@selector(gcdDemo:) forControlEvents:UIControlEventTouchUpInside];
    UIButton *btn1 = [[UIButton alloc]initWithFrame:CGRectMake(30, kStatusBarAndNavigationBarHeight+70, 320, 24)];
    btn1.tag = 1;
    btn1.backgroundColor = [UIColor redColor];
    [btn1 setTitle:@"展示dispatch_barrier_async" forState:UIControlStateNormal];
    [btn1 addTarget:self action:@selector(gcdDemo:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *btn3 = [[UIButton alloc]initWithFrame:CGRectMake(30, kStatusBarAndNavigationBarHeight+110, 320, 24)];
    btn3.backgroundColor = [UIColor purpleColor];
    [btn3 setTitle:@"展示系统operation" forState:UIControlStateNormal];
    [btn3 addTarget:self action:@selector(operationDemo) forControlEvents:UIControlEventTouchUpInside];
    UIButton *btn4 = [[UIButton alloc]initWithFrame:CGRectMake(30, kStatusBarAndNavigationBarHeight+150, 320, 24)];
    btn4.backgroundColor = [UIColor darkGrayColor];
    [btn4 setTitle:@"展示自定义的operation" forState:UIControlStateNormal];
    [btn4 addTarget:self action:@selector(myOperation) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *btn5 = [[UIButton alloc]initWithFrame:CGRectMake(30, kStatusBarAndNavigationBarHeight+190, 320, 24)];
    btn5.backgroundColor = [UIColor orangeColor];
    [btn5 setTitle:@"取消operation" forState:UIControlStateNormal];
    [btn5 addTarget:self action:@selector(cancelOperation) forControlEvents:UIControlEventTouchUpInside];


    [self.view addSubview:btn0];
    [self.view addSubview:btn1];
    [self.view addSubview:btn3];
    [self.view addSubview:btn4];
    [self.view addSubview:btn5];

}


//gcd一些高级用法
-(void)gcdDemo:(UIButton *)sender{
    //知识点补充
    /*
     dispatch_barrier_sync(queue,void(^block)())会将queue中barrier前面添加的任务block全部执行后,再执行barrier任务的block,再执行barrier后面添加的任务block.
     
     dispatch_barrier_async(queue,void(^block)())会将queue中barrier前面添加的任务block只添加不执行,继续添加barrier的block,再添加barrier后面的block,同时不影响主线程(或者操作添加任务的线程)中代码的执行!
     
     以上两个任务只对并行队列起作用
     读取操作可以并发执行，但是写入操作只能单独执行，所以写入操作使用dispatch_barrier_sync
     */
    dispatch_queue_t queue = dispatch_queue_create("thread", DISPATCH_QUEUE_CONCURRENT);     //并行队列
    dispatch_queue_t queue2 = dispatch_queue_create("thread", DISPATCH_QUEUE_SERIAL);        //串行队列

        dispatch_async(queue, ^{
            [NSThread sleepForTimeInterval:2];
            NSLog(@"1____%@",[NSThread currentThread]);
        });
        dispatch_async(queue, ^{
            NSLog(@"2____%@",[NSThread currentThread]);
        });
        dispatch_async(queue, ^{
            [NSThread sleepForTimeInterval:0.5];
            NSLog(@"3____%@",[NSThread currentThread]);
        });
    if (sender.tag==0) {
        dispatch_barrier_sync(queue, ^{
            [NSThread sleepForTimeInterval:1];
            NSLog(@"____%@",[NSThread currentThread]);
        });
    }else{
        dispatch_barrier_async(queue, ^{
            [NSThread sleepForTimeInterval:1];
            NSLog(@"____%@",[NSThread currentThread]);
        });
    }
        dispatch_async(queue, ^{
            [NSThread sleepForTimeInterval:0.5];
            NSLog(@"4____%@",[NSThread currentThread]);
        });
        NSLog(@"bbbbbbbb");
        dispatch_async(queue, ^{
            NSLog(@"5____%@",[NSThread currentThread]);
        });
        NSLog(@"ccccccc");
        dispatch_async(queue, ^{
            [NSThread sleepForTimeInterval:0.5];
            NSLog(@"6____%@",[NSThread currentThread]);
        });

}

//operation探索(多线程)
/*从简单意义上来说，NSOperation 是对 GCD 中的 block 进行的封装，它也表示一个要被执行的任务。
  与gcd相比，NSOperation 表示的任务还可以被取消。它还有三种状态 isExecuted、isFinished和 isCancelled 以方便我们通过 KVC 对它的状态进行监听。
 
 
  以下列举一些operation的新特性：
  1，取消任务
  2，设置依赖
  3，NSOperationQueue暂停与恢复
  4，NSOperation优先级
 
  NSOperation和GCD如何选择？
  1，GCD以 block 为单位，代码简洁。同时 GCD 中的队列、组、信号量、source、barriers 都是组成并行编程的基本原语。对于一次性的计算，或是仅仅为了加快现有方法的运行速度，选择轻量化的 GCD 就更加方便。
  2，而 NSOperation 可以用来规划一组任务之间的依赖关系，设置它们的优先级，任务能被取消。队列可以暂停、恢复。NSOperation还可以被子类化。这些都是GCD所不具备的。NSOperation 和 GCD 并不是互斥的，有效地结合两者可以开发出更棒的应用
 
 */

-(void)operationDemo{
    //如果没有加入新队列，任务在当前线程同步执行
    NSInvocationOperation *op = [[NSInvocationOperation alloc]initWithTarget:self selector:@selector(operationTap) object:nil];
    _operation = op;
    _operationQueue = [[NSOperationQueue alloc]init];
    //_operationQueue = queue;
    //    [op main];
    //串行队列和并行队列
    _operationQueue.maxConcurrentOperationCount = 6;
    [_operationQueue addOperation:op];
    [_operationQueue addOperationWithBlock:^{
        NSLog(@"这是第二个异步任务%@",[NSThread currentThread]);
    }];
    NSLog(@"主线任务");
}

-(void)myOperation{
    //实现一个自己的operation，并发执行
    //PPOperation *op = [[PPOperation alloc]initWithTarget:self action:@selector(operationTap)];
    PPOperation *op = [[PPOperation alloc]init];
    _operation = op;
    NSOperationQueue *queue = [[NSOperationQueue alloc]init];
    [queue addOperation:op];
    
    //添加对这两个属性的监听
    [_operation addObserver:self forKeyPath:@"isFinished" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    [_operation addObserver:self forKeyPath:@"isExecuting" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
}

-(void)operationTap{
    NSLog(@"这是一个异步任务");
    for (int i=0; i<10; i++) {
        [NSThread sleepForTimeInterval:1];
        NSLog(@"是否取消任务%d__%@",[_operation isCancelled],[NSThread currentThread]);
    }
}

-(void)cancelOperation{
    [_operation cancel];
}

//通过kvo来观察线程是否完成或者正在执行
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    NSLog(@"keypath:%@",keyPath);
    NSLog(@"object:%@",object);
    NSLog(@"change:%@",change);
    NSLog(@"context:%@",context);
}


@end
