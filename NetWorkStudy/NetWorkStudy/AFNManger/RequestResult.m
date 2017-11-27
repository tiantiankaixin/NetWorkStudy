//
//  RequestResult.m
//  YNDoctor
//
//  Created by wangtian on 15/7/6.
//  Copyright (c) 2015年 yinuo. All rights reserved.
//

#import "RequestResult.h"
//序列化json data
#define YNDic(jsonData) [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil]
#define YNStr(data)  [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]

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
    result.errorDes = [self errorDesWithError:error];
    return result;
}

+ (RequestResult *)resultWithResponse:(id)response
{
    RequestResult *result = [[RequestResult alloc] init];
    if (response)
    {
        result.isSuccess = YES;
        if ([response isKindOfClass:[NSData class]])
        {
            NSData *data = (NSData *)response;
            result.requestData = YNDic(data);
            result.requestStr = YNStr(data);
        }
        else if ([response isKindOfClass:[NSDictionary class]] || [response isKindOfClass:[NSArray class]])
        {
            result.requestData = response;
        }
        else
        {
            result.isSuccess = NO;
        }
    }
    return result;
}

+ (NSString *)errorDesWithError:(NSError *)error
{
    NSString *errorDes = @"未知错误";
    switch (error.code)
    {
        case NSURLErrorTimedOut:
        {
            errorDes = @"请求超时，请检查你的网络连接";
            break;
        }
        case NSURLErrorNotConnectedToInternet:
        {
            errorDes = @"网络不给力";
            break;
        }
        default:
        {
            break;
        }
    }
    return errorDes;
}

@end
