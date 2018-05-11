//
//  NotificationController.m
//  SDWebLearning
//
//  Created by peipei on 2018/5/10.
//  Copyright © 2018年 沛沛. All rights reserved.
//

#import "NotificationController.h"
#import "NotiView.h"

@interface NotificationController ()
@property(nonatomic,strong) NSTimer *timer;
@property(nonatomic,strong) NotiView *notiView;
@end

@implementation NotificationController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self renderNotiView];
    [self notiDemo1];
    [self kvoDemo];
}

-(void)renderNotiView{
    NotiView *notiView = [[NotiView alloc]initWithFrame:CGRectMake(kScreenWidth/2-100, 300, 200, 200)];
    [self.view addSubview:notiView];
    _notiView = notiView;
}

//通知中心
/*
 Notification Center的概念：
 它是一个单例对象，允许当事件发生时通知一些对象，让对象做出相应反应。
 它允许我们在低程度耦合的情况下，满足控制器与一个任意的对象进行通信的目的。 这种模式的基本特征是为了让其他的对象能够接收到某种事件传递过来的通知，主要使用通知名称来发送和接收通知。
 基本上不用考虑其它影响因素，只需要使用同样的通知名称，监听该通知的对象（即观察者）再对通知做出反应即可。
 */

//最简单的用法，通过通知单例发出一个通知
-(void)notiDemo1{
    //每1秒执行一次
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:3 repeats:true block:^(NSTimer * _Nonnull timer) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"notiDemo1" object:nil];
    }];
    _timer = timer;
}


//通过object可以传递参数
-(void)notiDemo2{
    //每1秒执行一次
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1 repeats:true block:^(NSTimer * _Nonnull timer) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"notiDemo2" object:@{@"text":@"notiDemo2的参数"}];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"notiDemo3" object:nil userInfo:@{@"text":@"notiDemo2的参数"}];
    }];
    _timer = timer;
}

//kvo相关
-(void)kvoDemo{
    [_notiView.label addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld  context:nil];
    //该方法一旦收到通知会调用-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
    //可以猜想这里内部使用到了Notification Center来接受通知
    [_notiView addObserver:self forKeyPath:@"name" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld  context:nil];
}

//kvo原理？怎样发出通知？
/*
 Apple 使用了 isa 混写（isa-swizzling）来实现 KVO 。当观察对象A时，KVO机制动态创建一个新的名为： NSKVONotifying_A的新类，该类继承自对象A的本类，且KVO为NSKVONotifying_A重写观察属性的setter 方法，setter 方法会负责在调用原 setter 方法之前和之后，通知所有观察对象属性值的更改情况。（备注： isa 混写（isa-swizzling）isa：is a kind of ； swizzling：混合，搅合；）
 
 ①NSKVONotifying_A类剖析：在这个过程，被观察对象的 isa 指针从指向原来的A类，被KVO机制修改为指向系统新创建的子类 NSKVONotifying_A类，来实现当前类属性值改变的监听；
所以当我们从应用层面上看来，完全没有意识到有新的类出现，这是系统“隐瞒”了对KVO的底层实现过程，让我们误以为还是原来的类。但是此时如果我们创建一个新的名为“NSKVONotifying_A”的类()，就会发现系统运行到注册KVO的那段代码时程序就崩溃，因为系统在注册监听的时候动态创建了名为NSKVONotifying_A的中间类，并指向这个中间类了。（isa 指针的作用：每个对象都有isa 指针，指向该对象的类，它告诉 Runtime 系统这个对象的类是什么。所以对象注册为观察者时，isa指针指向新子类，那么这个被观察的对象就神奇地变成新子类的对象（或实例）了。） 因而在该对象上对 setter 的调用就会调用已重写的 setter，从而激活键值通知机制。
 —>我猜，这也是KVO回调机制，为什么都俗称KVO技术为黑魔法的原因之一吧：内部神秘、外观简洁。
 
 ②子类setter方法剖析：KVO的键值观察通知依赖于 NSObject 的两个方法:willChangeValueForKey:和 didChangevlueForKey:，在存取数值的前后分别调用2个方法：被观察属性发生改变之前，willChangeValueForKey:被调用，通知系统该 keyPath 的属性值即将变更；当改变发生后， didChangeValueForKey: 被调用，通知系统该 keyPath 的属性值已经变更；之后observeValueForKey:ofObject:change:context: 也会被调用。且重写观察属性的setter 方法这种继承方式的注入是在运行时而不是编译时实现的。
 
 KVO为子类的观察者属性重写调用存取方法的工作原理在代码中相当于：
 上述例子中，当 p1.name 的值改变时，p1对象的 isa 指针会指向 NSKVONotifying_Person，意味着，在程序运行时，会动态生成一个 NSKVONotifying_Person 类，该类继承于 Person，而且该类中也有个 -setName: 方法，方法中在设置 name 的同时实现了：willChangeValueForKey,didChangeValueForKey
 */
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    NSLog(@"keypath:%@",keyPath);
    NSLog(@"object:%@",object);
    NSLog(@"change:%@",change);
    NSLog(@"context:%@",context);
}


-(void)dealloc{
    //哪里有addObsever，就在哪里的dealloc函数中移除
    [_timer invalidate];
    [_notiView removeObserver:self forKeyPath:@"name"];
    [_notiView.label removeObserver:self forKeyPath:@"text"];
}


@end
