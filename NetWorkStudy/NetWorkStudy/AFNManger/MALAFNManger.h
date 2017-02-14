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

typedef void(^FinishBlock)(RequestResult *result);

@interface MALAFNManger : NSObject

+ (NSString *)getWithUrl:(NSString *)url parameters:(NSDictionary *)parameters finish:(FinishBlock)finish des:(NSString *)des lifeObj:(id)lifeObj;
+ (NSString *)postWithUrl:(NSString *)url parameters:(NSDictionary *)parameters finish:(FinishBlock)finish des:(NSString *)des lifeObj:(id)lifeObj;

+ (void)cancelRequestWithFlag:(NSString *)flag;

@end
