//
//  MenuTemplateVC.h
//  NetWorkStudy
//
//  Created by wangtian on 16/4/21.
//  Copyright © 2016年 wangtian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MenuTemplateModel.h"

@interface MenuTemplateVC : UITableViewController

@property (nonatomic, strong) NSMutableArray *dataSource;

- (void)addARowWithCellTitle:(NSString *)cellTitle vcClass:(Class)vcClass turnType:(MTurnType)turnType;

@end
