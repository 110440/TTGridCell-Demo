//
//  ViewController.m
//  TTGridCell
//
//  Created by tanson on 2016/11/24.
//  Copyright © 2016年 chatchat. All rights reserved.
//

#import "ViewController.h"
#import "TTGridCell.h"


@interface ViewController ()
@property (nonatomic,strong) TTGridCell * menuCell;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableFooterView = [UIView new];
}

-(TTGridCell *)menuCell{
    
    NSMutableArray * models = @[].mutableCopy;
    for(int i=0;i<10;++i){
        TTGridCellModel * model = [[TTGridCellModel alloc] initWithTitle:@"这是一个菜单" iconName:@"1111111"];
        [models addObject:model];
    }
    
    if(!_menuCell){
        _menuCell = [[TTGridCell alloc] initWithModels:models colNum:4];
        _menuCell.itemTouchHandler = ^(NSInteger idx){
            //NSLog(@"select index %d",idx);
        };
    }
    return  _menuCell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    return self.menuCell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return self.menuCell.cellHeight;
}

@end
