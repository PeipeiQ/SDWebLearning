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
        _pages = @[@"OperationController",@"NetWorkController",@"NotificationController",@"RuntimeController"];
    }
    return _pages;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initTableView];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

-(void)initTableView{
    UITableView *tableView = [[UITableView alloc]initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStylePlain];
    _tableView = tableView;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    [self.view addSubview:tableView];
    [tableView registerClass:NSClassFromString(@"MainTableViewCell") forCellReuseIdentifier:@"main"];
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.pages.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MainTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"main"];
    cell.page = self.pages[indexPath.item];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    Class vcclass = NSClassFromString(self.pages[indexPath.item]);
    UIViewController *vc = [vcclass new];
    [self.navigationController pushViewController:vc animated:true];
}


@end
