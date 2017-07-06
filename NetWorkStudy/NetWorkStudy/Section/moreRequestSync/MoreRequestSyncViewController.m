//
//  MoreRequestSyncViewController.m
//  NetWorkStudy
//
//  Created by wangtian on 16/4/21.
//  Copyright © 2016年 wangtian. All rights reserved.
//

#import "MoreRequestSyncViewController.h"
#import "KSDeferred.h"

#define Url1 @"http://mobile.ximalaya.com/mobile/discovery/v1/recommend/editor?device=iPhone&pageId=1&pageSize=20&position=&title=%E6%9B%B4%E5%A4%9A"
#define Url2 @"http://mobile.ximalaya.com/mobile/discovery/v2/category/recommends?categoryId=1&contentType=album&device=iPhone&position=&scale=2&title=%E6%9B%B4%E5%A4%9A&version=4.3.38"

@interface MoreRequestSyncViewController ()

@end

@implementation MoreRequestSyncViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setTitle:@"多个网络请求的同步问题"];
    //[self loadRequest1];
    // Do any additional setup after loading the view from its nib.
    NSMutableArray *dataSource = [NSMutableArray array];
    [[[self promise1] then:^id _Nullable(id  _Nullable value) {
        
        [dataSource addObject:value];
        return [self promise2];
        
    }] then:^id _Nullable(id  _Nullable value) {
        
        [dataSource addObject:value];
        return value;
        
    } error:^id _Nullable(NSError * _Nullable error) {
        
        NSLog(@"%@",error);
        return error;
    }];
}

#pragma mark - 直接使用dispatch_group
- (void)loadRequest
{
    //网络请求是异步的 发起后group就认为任务已经完成 所以直接使用group不能达到同步的效果
    dispatch_queue_t dispatchQueue = dispatch_queue_create("com.shidaiyinuo.NetWorkStudy2", DISPATCH_QUEUE_CONCURRENT);
    dispatch_group_t dispatchGroup = dispatch_group_create();
    dispatch_group_async(dispatchGroup, dispatchQueue, ^(){
        
        [MALAFNManger getWithUrl:Url1 parameters:nil finish:^(RequestResult *result) {
            
            if (result.isSuccess)
            {
                NSLog(@"第一个请求完成");
            }
            
        } des:@"第一个url" lifeObj:self];
    });
    dispatch_group_async(dispatchGroup, dispatchQueue, ^(){
        
        [MALAFNManger getWithUrl:Url1 parameters:nil finish:^(RequestResult *result) {
            
            if (result.isSuccess)
            {
                NSLog(@"第二个请求完成");
            }
            
        } des:@"第二个url" lifeObj:self];
    });
    
    dispatch_group_notify(dispatchGroup, dispatch_get_main_queue(), ^(){
        NSLog(@"dispatch_group_notify block执行");
    });
}

#pragma mark - dispatch_group_enter、dispatch_group_leave、dispatch_group_notify实现同步
- (void)loadRequest1
{
    dispatch_group_t dispatchGroup = dispatch_group_create();
    dispatch_group_enter(dispatchGroup);
    [MALAFNManger getWithUrl:Url1 parameters:nil finish:^(RequestResult *result) {
        
        if (result.isSuccess)
        {
            NSLog(@"第一个请求完成");
        }
        dispatch_group_leave(dispatchGroup);
        
    } des:@"第一个url" lifeObj:self];
    
    dispatch_group_enter(dispatchGroup);
    [MALAFNManger getWithUrl:Url1 parameters:nil finish:^(RequestResult *result) {
        
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            
            sleep(10);//网络请求结束后回调是在主线程如果sleep放在外面会阻塞主线程
            NSLog(@"第二个请求完成");
            dispatch_group_leave(dispatchGroup);
        });
        
    } des:@"第二个url" lifeObj:self];

    dispatch_group_notify(dispatchGroup, dispatch_get_main_queue(), ^(){
        
        NSLog(@"请求完成");
    });
}

#pragma mark - dispatch_group_enter、dispatch_group_leave、dispatch_group_wait实现同步
- (void)loadRequest2
{
    dispatch_group_t dispatchGroup = dispatch_group_create();//是由系统持有管理的  与self的生命周期无关
    dispatch_group_enter(dispatchGroup);
    [MALAFNManger getWithUrl:Url1 parameters:nil finish:^(RequestResult *result) {
        
        if (result.isSuccess)
        {
            NSLog(@"第一个请求完成");
        }
        dispatch_group_leave(dispatchGroup);
        
    } des:@"第一个url" lifeObj:self];
    
    dispatch_group_enter(dispatchGroup);
    [MALAFNManger getWithUrl:Url1 parameters:nil finish:^(RequestResult *result) {
        
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            
            sleep(10);//网络请求结束后回调是在主线程如果sleep放在外面会阻塞主线程
            NSLog(@"第二个请求完成");
            dispatch_group_leave(dispatchGroup);
        });
        
    } des:@"第二个url" lifeObj:self];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        dispatch_group_wait(dispatchGroup, dispatch_time(DISPATCH_TIME_NOW, 5 * NSEC_PER_SEC));//是同步的所以不要放在主线程
        NSLog(@"完成");
    });
}

- (KSPromise<NSNumber *> *)promiseTest
{
    KSDeferred *defer = [KSDeferred defer];
    [[self promise1] then:^id _Nullable(id  _Nullable value) {
        
        return value;
        
    } error:^id _Nullable(NSError * _Nullable error) {
        
        return error;
    }];
    return defer.promise;
}

- (KSPromise<id> *)promise1
{
    KSDeferred *defer = [KSDeferred defer];
    [MALAFNManger getWithUrl:Url1 parameters:nil finish:^(RequestResult *result) {
        
        if(result.isSuccess)
        {
            [defer resolveWithValue:result.requestData];
        }
        else
        {
            [defer rejectWithError:[NSError errorWithDomain:@"error1" code:001 userInfo:nil]];
        }
        
    } des:@"第一个url" lifeObj:self];
    return defer.promise;
}

- (KSPromise<id> *)promise2
{
    KSDeferred *defer = [KSDeferred defer];
    [MALAFNManger getWithUrl:Url2 parameters:nil finish:^(RequestResult *result) {
        
        if(result.isSuccess)
        {
            [defer resolveWithValue:result.requestData];
        }
        else
        {
            [defer rejectWithError:[NSError errorWithDomain:@"error2" code:002 userInfo:nil]];
        }
        
    } des:@"第二个url" lifeObj:self];
    return defer.promise;
}


- (void)dealloc
{
    NSLog(@"%@ dealloc",NSStringFromClass([self class]));
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    NSLog(@"页面可以被点击");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
