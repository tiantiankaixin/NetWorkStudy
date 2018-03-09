//
//  RequestConfigue.m
//  NetWorkStudy
//
//  Created by mal on 2018/3/9.
//  Copyright © 2018年 wangtian. All rights reserved.
//

#import "RequestConfigue.h"

static RequestConfigue *configue = nil;
// 内存缓存最大值:2M
static NSUInteger const SMCacheMemoryCapacityMaxSize = 2 * 1024 * 1024;
// 硬盘缓存最大值:100M
static NSUInteger const SMCacheDiskCapacityMaxSize = 100 * 1024 * 1024;

@implementation RequestConfigue

+ (RequestConfigue *)shareConfigue
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        configue = [[RequestConfigue alloc] init];
    });
    return configue;
}

- (void)configue
{
    [self configueCache];
}

- (void)configueCache
{
    NSURLCache *cache = [[NSURLCache alloc] initWithMemoryCapacity:SMCacheMemoryCapacityMaxSize
                                                      diskCapacity:SMCacheDiskCapacityMaxSize
                                                          diskPath:nil];
    [NSURLCache setSharedURLCache:cache];
}

@end
