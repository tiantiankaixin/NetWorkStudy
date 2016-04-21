//
//  MenuTemplateModel.m
//  NetWorkStudy
//
//  Created by wangtian on 16/4/21.
//  Copyright © 2016年 wangtian. All rights reserved.
//

#import "MenuTemplateModel.h"

@implementation MenuTemplateModel

+ (MenuTemplateModel *)modelWithCellTitle:(NSString *)cellTitle vcClass:(__unsafe_unretained Class)vcClass turnType:(MTurnType)turnType 
{
    MenuTemplateModel *model = [[MenuTemplateModel alloc] init];
    
    model.cellTitle = cellTitle;
    model.turnType  = turnType;
    model.vcClass = vcClass;
    
    return model;
}

@end
