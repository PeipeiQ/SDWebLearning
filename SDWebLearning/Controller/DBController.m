//
//  DBController.m
//  SDWebLearning
//
//  Created by peipei on 2018/5/21.
//  Copyright © 2018年 沛沛. All rights reserved.
//

#import "DBController.h"
#import "TextView.h"
#import <sqlite3.h>

@interface DBController (){
    sqlite3 *_db;
}
@property(nonatomic,strong) TextView *ageText;
@property(nonatomic,strong) TextView *sexText;
@property(nonatomic,strong) TextView *cityText;
@property(nonatomic,strong) TextView *nameText;
@end

@implementation DBController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    _nameText = [[TextView alloc]initWithFrame:CGRectMake(50, 100, 200, 30) title:@"姓名"];
    _ageText = [[TextView alloc]initWithFrame:CGRectMake(50, 150, 200, 30) title:@"年龄"];
    _sexText = [[TextView alloc]initWithFrame:CGRectMake(50, 200, 200, 30) title:@"性别"];
    _cityText = [[TextView alloc]initWithFrame:CGRectMake(50, 250, 200, 30) title:@"城市"];

    [self.view addSubview:_nameText];
    [self.view addSubview:_ageText];
    [self.view addSubview:_sexText];
    [self.view addSubview:_cityText];
    
    [self createSqlitedb];
    [self searchDataFromDB];
}


-(void)createSqlitedb{
    NSString *fileName = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"student.db"];
    NSLog(@"%@",fileName);
    
    //创建或者打开一个数据库
    int result = sqlite3_open(fileName.UTF8String, &_db);
    if(result==SQLITE_OK){
        //成功创建数据库
        
        //建表
        const char *sql = "create table if not exists t_student (id INTEGER PRIMARY KEY AUTOINCREMENT,name text,age int,city text,sex int);";
        char *errorMsg = NULL;
        int result = sqlite3_exec(_db, sql, NULL, NULL, &errorMsg);
        NSLog(@"建表%d",result);
        NSLog(@"建表错误信息%s",errorMsg);
    }
}

//插入数据
-(void)insertData{
    
    for (int i = 0; i < 10; i++) {
        NSString *name = [NSString stringWithFormat:@"Jacl-%d",arc4random()%100];
        int age = arc4random()%100;
        int sex = (arc4random()%100)%2;
        NSString *city = [NSString stringWithFormat:@"CN-%d",arc4random()%100];

        //插入语句（insert into 表名（字段1，字段2，..）values (字段1值，字段2值，..);）
        NSString *sql = [NSString stringWithFormat:@"insert into t_student (id,name,age,sex,city) values (null,'%@',%d,%d,'%@');",name,age,sex,city];
        char *errorMesg = NULL;
        int result = sqlite3_exec(_db, sql.UTF8String, NULL, NULL, &errorMesg);
        
        if (result == SQLITE_OK) {
            NSLog(@"添加数据成功");
        }else {
            
            NSLog(@"添加数据失败");
        }
    }
}

//查询数据
-(void)searchDataFromDB{
    //1.定义sql语句（查询所有学生的数据）
    //const char *sql = "select id, name, age from t_student;";
    //也可用where条件查询语句，查询年龄大于60的学生年龄
    const char *sql = "select * from t_student where age > 60;";
    //2.定义一个stmt存放结果集
    sqlite3_stmt *stmt = NULL;
    //3.检测SQL语句的合法性
    int result = sqlite3_prepare_v2(_db, sql, -1, &stmt, NULL);
    if(result==SQLITE_OK){
        //4.执行SQL语句
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            NSLog(@"---------------------------------------------------------------");
            //获得第几条的id
            int ID = sqlite3_column_int(stmt, 0);

            const unsigned char *sname = sqlite3_column_text(stmt, 1);
            NSString *name = sname?[NSString stringWithUTF8String:(const char *)sname]:nil;
 
            //获得第几条的age
            int age = sqlite3_column_int(stmt, 2);
            
            const unsigned char *scity = sqlite3_column_text(stmt, 3);
            NSString *city = scity?[NSString stringWithUTF8String:(const char *)scity]:nil;
            
            int sex = sqlite3_column_int(stmt, 4);
            NSLog(@"id:%d\nname:%@\nage:%d\ncity:%@\nsex:%d",ID,name,age,city,sex);
            
        }
        
    }

}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}



@end
