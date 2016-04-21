//
//  MenuTemplateModel.h
//  NetWorkStudy
//
//  Created by wangtian on 16/4/21.
//  Copyright © 2016年 wangtian. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, MTurnType) {

    M_push,
    M_present
};

@interface MenuTemplateModel : NSObject

@property (nonatomic, copy) NSString *cellTitle;
@property (nonatomic, assign) MTurnType turnType;
@property (nonatomic, strong) Class vcClass;

+ (MenuTemplateModel *)modelWithCellTitle:(NSString *)cellTitle vcClass:(__unsafe_unretained Class)vcClass turnType:(MTurnType)turnType;


@end
