//
//  ViewController.m
//  CoreDataDemo
//
//  Created by 王恒求 on 2016/8/22.
//  Copyright © 2016年 王恒求. All rights reserved.
//

#import "ViewController.h"
#import "Teacher.h"
#import "NSManagedObject+Function.h"

@interface ViewController () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) NSMutableArray *dataArr;
@property (nonatomic,strong) UITableView *tableView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [Teacher insertNewObject:@"whq" age:22 course:@"语文"];
    
    _dataArr=[NSMutableArray array];
    _dataArr=(NSMutableArray*)[[Teacher getObjectList:nil orderby:nil offset:0 limit:0] mutableCopy];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addTeacher)];
    self.navigationItem.rightBarButtonItem=item;
    
    _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.rowHeight=50;
    [self.view addSubview:_tableView];
}

-(void)addTeacher
{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* cellIndifier = @"cell";
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIndifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIndifier];
    }
    
    TeacherInfo* tempTeacher=[_dataArr objectAtIndex:indexPath.row];
    cell.textLabel.text = tempTeacher.name;
    cell.detailTextLabel.text=[NSString stringWithFormat:@"年龄：%d  科目：%@",[tempTeacher.age intValue],tempTeacher.course];
    
    return cell;
}


@end
