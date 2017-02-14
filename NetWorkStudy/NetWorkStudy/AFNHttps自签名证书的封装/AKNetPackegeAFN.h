//
//  AKNetPackegeAFN.h
//  AKPackageAFN
//
//  Created by 李亚坤 on 2016/10/20.
//  Copyright © 2016年 Kuture. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef void (^HttpSuccess)(id json);
typedef void (^HttpErro)(NSError* error);
@interface AKNetPackegeAFN : NSObject

+(instancetype)shareHttpManager;
- (void)postWith:(NSString *)api Parameters:(NSDictionary *)parameters Success:(HttpSuccess)sucess Fail:(HttpErro)fail;
- (void)getWith:(NSString *)api Parameters:(NSDictionary *)parameters Success:(HttpSuccess)sucess Fail:(HttpErro)fail;

@end
