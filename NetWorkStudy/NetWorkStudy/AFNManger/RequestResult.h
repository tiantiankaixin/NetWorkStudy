//
//  RequestResult.h
//  YNDoctor
//
//  Created by wangtian on 15/7/6.
//  Copyright (c) 2015年 yinuo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RequestResult : NSObject

@property (nonatomic, assign) NSInteger errorCode;
@property (nonatomic, copy) NSString *errorDes;
@property (nonatomic, assign) BOOL isSuccess;
@property (nonatomic, strong) id requestData;
@property (nonatomic, copy) NSString *requestStr;

+ (RequestResult *)requestWithError:(NSError *)error;

@end
