//
//  PPNaviView.m
//  SDWebLearning
//
//  Created by 沛沛 on 2018/5/28.
//  Copyright © 2018年 沛沛. All rights reserved.
//

#import "PPNaviView.h"
//自定义导航栏

@interface PPNaviView()
@property(nonatomic,strong) UILabel *titleLabel;
@property(nonatomic,strong) UIButton *backBtn;
@end

@implementation PPNaviView

-(instancetype)initWithFrame:(CGRect)frame title:(NSString*)title{
    if (self=[super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithHex:0x666666 alpha:1];
        [self setupTitle:title];
        [self setupBack];
    }
    return self;
}

-(void)setupTitle:(NSString*)title{
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 30)];
    titleLabel.text = title;
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel = titleLabel;
    [self addSubview:titleLabel];
}

-(void)setupBack{
    UIButton *backBtn = [[UIButton alloc]initWithFrame:CGRectMake(20, kStatusBarHeight+10, 100, 30)];
    [backBtn setTitle:@"Back" forState:UIControlStateNormal];
    [backBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    backBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [backBtn addTarget:self action:@selector(getBack) forControlEvents:UIControlEventTouchUpInside];
    _backBtn = backBtn;
    [self addSubview:backBtn];
}

-(void)layoutSubviews{
    _titleLabel.center = CGPointMake(self.center.x, self.center.y+kStatusBarHeight/2);
    _backBtn.center = CGPointMake(20+50, self.center.y+kStatusBarHeight/2);;
}

-(void)getBack{
    UIViewController *vc = [self currentViewController];
    [vc.navigationController popViewControllerAnimated:true];
}

-(void)setTableView:(UITableView *)tableView{
    _tableView = tableView;
    [_tableView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if([keyPath isEqualToString:@"contentOffset"]){
        CGPoint newPoint = [change[@"new"] CGPointValue];
        //CGPoint oldPoint = [change[@"old"] CGPointValue];
        float alpha = (400-newPoint.y)/400;
        self.backgroundColor = [UIColor colorWithHex:0x666666 alpha:alpha];
        [_backBtn setTitleColor:[UIColor colorWithHex:0x000000 alpha:alpha] forState:UIControlStateNormal];
        _titleLabel.textColor = [UIColor colorWithHex:0x000000 alpha:alpha];
        _backBtn.hidden = alpha<=0?YES:NO;
    }
}


//获取Window当前显示的ViewController
- (UIViewController*)currentViewController{
    //获得当前活动窗口的根视图
    UIViewController* vc = [UIApplication sharedApplication].keyWindow.rootViewController;
    //NSLog(@"%@", vc);
    while (1)
    {
        //根据不同的页面切换方式，逐步取得最上层的viewController
        if ([vc isKindOfClass:[UITabBarController class]]) {
            vc = ((UITabBarController*)vc).selectedViewController;
            //NSLog(@"%@", vc);
        }
        if ([vc isKindOfClass:[UINavigationController class]]) {
            vc = ((UINavigationController*)vc).visibleViewController;
            //NSLog(@"%@", vc);
        }
        if (vc.presentedViewController) {
            vc = vc.presentedViewController;
            //NSLog(@"%@", vc);
        }else{
            break;
        }
    }
    return vc;
}



@end
