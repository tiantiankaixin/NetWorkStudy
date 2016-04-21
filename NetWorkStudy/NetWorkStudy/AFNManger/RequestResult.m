//
//  RequestResult.m
//  YNDoctor
//
//  Created by wangtian on 15/7/6.
//  Copyright (c) 2015年 yinuo. All rights reserved.
//

#import "RequestResult.h"

@implementation RequestResult


+ (RequestResult *)requestWithError:(NSError *)error
{
    RequestResult *result = [[RequestResult alloc] init];
    result.isSuccess = NO;
    if (error == nil)
    {
        return result;
    }
    result.errorCode = error.code;
    NSString *errorDes;
    switch (error.code)
    {
        case -1001:
        {
            errorDes = @"请求超时，请检查你的网络连接";
            break;
        }
        case -1009:
        {
            errorDes = @"网络不给力";
            break;
        }
        default:
        {
            errorDes = nil;
            break;
        }
    }
    result.errorDes = errorDes;
    return result;
}

@end
