//
//  MenuTemplateVC.m
//  NetWorkStudy
//
//  Created by wangtian on 16/4/21.
//  Copyright © 2016年 wangtian. All rights reserved.
//

#import "MenuTemplateVC.h"

static NSString *menuCell_Identifier = @"menucell";

@interface MenuTemplateVC ()

@end

@implementation MenuTemplateVC

- (NSMutableArray *)dataSource
{
    if (_dataSource == nil)
    {
        _dataSource = [[NSMutableArray alloc] init];
    }
    return _dataSource;
}

- (void)addARowWithCellTitle:(NSString *)cellTitle vcClass:(Class)vcClass turnType:(MTurnType)turnType
{
    [self.dataSource addObject:[MenuTemplateModel modelWithCellTitle:cellTitle vcClass:vcClass turnType:turnType]];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setUpView];
}

- (void)setUpView
{
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:menuCell_Identifier];
    [self.tableView setTableFooterView:[UIView new]];
}


#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:menuCell_Identifier forIndexPath:indexPath];
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    MenuTemplateModel *model = [self.dataSource objectAtIndex:indexPath.row];
    cell.textLabel.text = model.cellTitle;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MenuTemplateModel *model = [self.dataSource objectAtIndex:indexPath.row];
    UIViewController *vc;
    vc = [[model.vcClass alloc] init];
    if (model.turnType == M_push)
    {
        [self.navigationController pushViewController:vc animated:YES];
    }
    else
    {
        [self presentViewController:vc animated:YES completion:nil];
    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
