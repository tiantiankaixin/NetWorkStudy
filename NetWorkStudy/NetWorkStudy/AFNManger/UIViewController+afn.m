//
//  UIViewController+afn.m
//  NetWorkStudy
//
//  Created by mal on 16/11/25.
//  Copyright © 2016年 wangtian. All rights reserved.
//

#import "UIViewController+afn.h"

@implementation UIViewController (afn)

- (void)getWithUrl:(NSString *)url pa:(NSDictionary *)pa finish:(FinishBlock)finish des:(NSString *)des
{
    //FIXME: 可以加点儿别的如hud的显示隐藏等
    [MALAFNManger getWithUrl:url parameters:nil finish:finish des:des lifeObj:self];
}

- (void)postWithUrl:(NSString *)url pa:(NSDictionary *)pa finish:(FinishBlock)finish des:(NSString *)des
{
     [MALAFNManger postWithUrl:url parameters:nil finish:finish des:des lifeObj:self];
}

@end
