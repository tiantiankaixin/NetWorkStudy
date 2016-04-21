//
//  MALAFNManger.h
//  MALCookingOC
//
//  Created by wangtian on 15/12/18.
//  Copyright © 2015年 wangtian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RequestResult.h"
#import <AFNetworking.h>

//序列化json data
#define YNDic(jsonData) [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil]
#define YNStr(data)  [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]

typedef void(^FinishBlock)(RequestResult *result);

@interface MALAFNManger : NSObject

//  单例对象
+ (MALAFNManger *)shareAFNManger;

+ (void)getDataWithUrl:(NSString *)url parameters:(NSDictionary *)parameters finish:(FinishBlock)finish des:(NSString *)des;

@end
