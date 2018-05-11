//
//  NotiView.m
//  SDWebLearning
//
//  Created by peipei on 2018/5/11.
//  Copyright © 2018年 沛沛. All rights reserved.
//

#import "NotiView.h"
@interface NotiView(){
    CGRect _frame;
    NSString *_name;
}
//@property(nonatomic,strong) NSString *name;
@end

@implementation NotiView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        _frame = frame;
        [self renderView];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(demo1) name:@"notiDemo1" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(demo2:) name:@"notiDemo2" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(demo3:) name:@"notiDemo3" object:nil];
    }
    return self;
}

-(void)renderView{
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, _frame.size.width, _frame.size.height)];
    _label = label;
    self.backgroundColor = [UIColor redColor];
    label.textColor = [UIColor whiteColor];
    label.numberOfLines = 0;
    [self addSubview:label];
}

-(void)demo1{
    static int i = 0;
    _label.text = [NSString stringWithFormat:@"demo1的第%d次通知",i];
    [self willChangeValueForKey:@"name"];
    _name = [NSString stringWithFormat:@"demo1 is at %d",i++];
    [self didChangeValueForKey:@"name"];
}

-(void)demo2:(NSNotification*)noti{
    static int i = 0;
    _label.text = [NSString stringWithFormat:@"demo2的第%d次通知，参数为%@",i++,noti.object[@"text"]];
}

-(void)demo3:(NSNotification*)noti{
    static int i = 0;
    NSLog(@"demo3:%@",noti);
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
