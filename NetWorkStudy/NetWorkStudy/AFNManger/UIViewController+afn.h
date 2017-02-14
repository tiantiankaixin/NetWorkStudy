//
//  UIViewController+afn.h
//  NetWorkStudy
//
//  Created by mal on 16/11/25.
//  Copyright © 2016年 wangtian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MALAFNManger.h"

@interface UIViewController (afn)

- (void)getWithUrl:(NSString *)url pa:(NSDictionary *)pa finish:(FinishBlock)finish des:(NSString *)des;
- (void)postWithUrl:(NSString *)url pa:(NSDictionary *)pa finish:(FinishBlock)finish des:(NSString *)des;

@end
