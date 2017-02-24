//
//  MALAFNManger.m
//  MALCookingOC
//
//  Created by wangtian on 15/12/18.
//  Copyright © 2015年 wangtian. All rights reserved.
//

#import "MALAFNManger.h"

#define AFNRequestTimeout  5
#define AFNSessionManager  [self afnSessionManager]
#define AFNTaskDic         [self taskDic]

static NSMutableDictionary *taskDic = nil;
static AFHTTPSessionManager *afnManager = nil;

@interface MALAFNManger()

@end

@implementation MALAFNManger

+ (AFHTTPSessionManager *)afnSessionManager
{
    if (afnManager == nil)
    {
        afnManager = [self sessionManagerWithTimeOut:AFNRequestTimeout isJson:NO];
    }
    return afnManager;
}

+ (AFHTTPSessionManager *)sessionManagerWithTimeOut:(NSTimeInterval)timeOut isJson:(BOOL)isJson
{
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    if (isJson)
    {
        session.responseSerializer = [AFJSONResponseSerializer serializer];
    }
    else
    {
        session.responseSerializer = [AFHTTPResponseSerializer serializer];
    }
    [session.requestSerializer setTimeoutInterval:timeOut];
    return session;
}

#pragma mark - get request
+ (NSString *)getWithUrl:(NSString *)url parameters:(NSDictionary *)parameters finish:(FinishBlock)finish des:(NSString *)des lifeObj:(id)lifeObj
{
    NSMutableDictionary *pa = [self addPublicParameters:parameters];
    __weak typeof(lifeObj) wsObj = lifeObj;
    BOOL uselifeObj = (lifeObj != nil);
    NSURLSessionTask *task = [AFNSessionManager GET:url parameters:pa progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [self requestSuccessWithData:responseObject Url:url parameters:parameters finish:finish des:des lifeObj:wsObj uselifeObj:uselifeObj];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [self requestErrorWithUrl:url parameters:parameters finish:finish des:des error:error lifeObj:wsObj uselifeObj:uselifeObj];
    }];
    return [self saveTaskWithUrl:url pa:parameters task:task];
}

+ (NSString *)postWithUrl:(NSString *)url parameters:(NSDictionary *)parameters finish:(FinishBlock)finish des:(NSString *)des lifeObj:(id)lifeObj
{
    NSMutableDictionary *pa = [self addPublicParameters:parameters];
    __weak typeof(lifeObj) wsObj = lifeObj;
    BOOL uselifeObj = (lifeObj != nil);
    NSURLSessionTask *task = [AFNSessionManager POST:url parameters:pa progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [self requestSuccessWithData:responseObject Url:url parameters:parameters finish:finish des:des lifeObj:wsObj uselifeObj:uselifeObj];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [self requestErrorWithUrl:url parameters:parameters finish:finish des:des error:error lifeObj:wsObj uselifeObj:uselifeObj];
    }];
    return [self saveTaskWithUrl:url pa:parameters task:task];
}

#pragma mark - 请求移除
+ (void)cancelRequestWithFlag:(NSString *)flag
{
    if (flag.length > 0)
    {
        NSURLSessionTask *task = [AFNTaskDic objectForKey:flag];
        if (task)
        {
            NSURLSessionTaskState state = task.state;
            if (state != NSURLSessionTaskStateCanceling && state != NSURLSessionTaskStateCompleted)
            {
                [task cancel];//cancel后 task会直接完成并抛出一个NSURl的error  NSURLErrorCancelled
            }
            [AFNTaskDic removeObjectForKey:flag];
        }
    }
}

+ (NSString *)saveTaskWithUrl:(NSString *)url pa:(NSDictionary *)pa task:(NSURLSessionTask *)task
{
    NSString *requestFlag = [self fullUrlWithHost:url pa:pa];
    //[self cancelRequestWithFlag:requestFlag];
    if (task)
    {
        [AFNTaskDic setObject:task forKey:requestFlag];
    }
    return requestFlag;
}

+ (NSMutableDictionary *)taskDic
{
    if(taskDic == nil)
    {
        taskDic = [NSMutableDictionary dictionary];
    }
    return taskDic;
}

#pragma mark - 请求结果处理
//访问服务器成功处理
+ (void)requestSuccessWithData:(NSData *)responseObject Url:(NSString *)url parameters:(NSDictionary *)parameters finish:(FinishBlock)finish des:(NSString *)des lifeObj:(id)lifeObj uselifeObj:(BOOL)uselifeObj
{
    NSString *requestFlag = [self fullUrlWithHost:url pa:parameters];
    [self cancelRequestWithFlag:requestFlag];
    if (uselifeObj && !lifeObj)
    {
        return;
    }
    RequestResult *result = [RequestResult resultWithData:responseObject];
    if (finish)
    {
        finish(result);
    }
    [MALAFNManger logFullUrl:url andParameters:parameters outPut:@"" des:des];
}
//访问服务器失败处理
+ (void)requestErrorWithUrl:(NSString *)url parameters:(NSDictionary *)parameters finish:(FinishBlock)finish des:(NSString *)des error:(NSError *)error lifeObj:(id)lifeObj uselifeObj:(BOOL)uselifeObj
{
    NSString *requestFlag = [self fullUrlWithHost:url pa:parameters];
    [self cancelRequestWithFlag:requestFlag];
    if (uselifeObj && !lifeObj)
    {
        return;
    }
    if (error.code == NSURLErrorCancelled)
    {
        return;
    }
    [MALAFNManger logFullUrl:url andParameters:parameters outPut:[RequestResult errorDesWithError:error] des:des];
    if(finish)
    {
        finish([RequestResult requestWithError:error]);
    }
}

#pragma mark - help
//添加公共参数
+ (NSMutableDictionary *)addPublicParameters:(NSDictionary *)pa
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:pa];
    
    return dic;
}
//打印full url
+ (void)logFullUrl:(NSString *)urlString andParameters:(NSDictionary *)pa outPut:(id)outPut des:(NSString *)des
{
    NSString *fullUrl = [self fullUrlWithHost:urlString pa:pa];
    if ([outPut isKindOfClass:[RequestResult class]])
    {
        RequestResult *result = (RequestResult *)outPut;
        outPut = result.requestData;
        if (result.requestData == nil)
        {
            outPut = result.requestStr;
        }
    }
    NSLog(@"\n{\n\n 请求url : %@\n\n 接口描述 : %@\n\n}\n",fullUrl,des);
}
//得到full url
+ (NSString *)fullUrlWithHost:(NSString *)host pa:(NSDictionary *)pa
{
    NSMutableString *fullUrl = [[NSMutableString alloc] init];
    [fullUrl appendString:[NSString stringWithFormat:@"%@",host]];
    if (pa != nil)
    {
        [fullUrl appendString:@"?"];
    }
    NSInteger paCount = pa.count;
    __block NSInteger index = 0;
    [pa enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop)
     {
         [fullUrl appendFormat:@"%@=%@",key,obj];
         index++;
         if (index != paCount) {
             
             [fullUrl appendString:@"&"];
         }
     }];
    return fullUrl;
}

@end
