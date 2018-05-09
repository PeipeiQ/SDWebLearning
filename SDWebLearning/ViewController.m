//
//  ViewController.m
//  SDWebLearning
//
//  Created by 沛沛 on 2018/5/9.
//  Copyright © 2018年 沛沛. All rights reserved.
//

#import "ViewController.h"
#import "MainTableViewCell.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong) UITableView *tableView;
@property(nonatomic,copy) NSArray *pages;
@end

@implementation ViewController

-(NSArray *)pages{
    if (!_pages) {
        _pages = @[];
    }
    return _pages;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initTableView];
}

-(void)initTableView{
    UITableView *tableView = [[UITableView alloc]initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStylePlain];
    _tableView = tableView;
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    [tableView registerClass:NSClassFromString(@"MainTableViewCell") forCellReuseIdentifier:@"main"];
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MainTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"main"];
    return cell;
}


@end
