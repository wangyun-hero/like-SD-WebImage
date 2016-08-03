//
//  WYDownloadManager.m
//  sd加载图片
//
//  Created by 王云 on 16/7/31.
//  Copyright © 2016年 王云. All rights reserved.
//

#import "WYDownloadManager.h"
#import "NSString+path.h"
#import "WYDownloadOperation.h"
@interface WYDownloadManager()

@property(nonatomic,strong)NSMutableDictionary *imageCanch;

@property(nonatomic,strong)NSMutableDictionary *operationCanch;

@property(nonatomic,strong)NSOperationQueue *queue;

@end

@implementation WYDownloadManager

//获取单利的方法
+(instancetype)sharedManager
{
    static WYDownloadManager *instance;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc]init];
    });
    return instance;
}

-(instancetype)init
{
    if (self = [super init]) {
        //初始化
        self.imageCanch = [NSMutableDictionary dictionary];
        self.operationCanch = [NSMutableDictionary dictionary];
        self.queue = [[NSOperationQueue alloc]init];
        
        //注册通知,监听内存警告,添加一个监听者
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(memoryWarnimg) name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
        
    }
    
    return self;
}

// 提供一个给外界调用的下载图片的方法
-(void)downloadImageWithUrlString:(NSString *)urlString  compeletion:(void(^)(UIImage *))compeletion
{
    //断言
    NSAssert(compeletion != nil, @"n=别闹了");
    
    //先判断内存里面有没有
    UIImage *image = self.imageCanch[urlString];
    if (image != nil) {
        NSLog(@"从内存取");
         //如果有直接通过block进行回调
        compeletion(image);
        return;
    }
    
    //再判断沙盒中有没有
    NSString *canchString = [urlString appendCachePath];
    image = [UIImage imageWithContentsOfFile:canchString];
    if (image != nil) {
        NSLog(@"从沙盒取");
        //如果有直接通过block进行返回
        compeletion(image);
        //并且保存到内存里一份
        [self.imageCanch setObject:image forKey:urlString];
        
        return;
    }
    
    
    //判断是否有操作,如果操作有,什么都不做
    if (self.operationCanch[urlString] != nil) {
        NSLog(@"操作正在进行,请稍安勿躁");
        return;
    }
    //如果没有,创建操作进行下载图片
    
    NSLog(@"创建线程下载图片");
    
    //创建一个操作
    WYDownloadOperation *op = [WYDownloadOperation operationWithUrlString:urlString];
    
    __weak WYDownloadOperation *weakSelf = op;
    
    [op setCompletionBlock:^{
        //取到图片
        UIImage *image = weakSelf.image;
        
        //回到主线程
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            //将图片存储到内存
            [self.imageCanch setObject:image forKey:urlString];
            
            //将操作移除
            [self.operationCanch removeObjectForKey:urlString];
            
            //回调
            compeletion(image);
        }];
}];
    
    
    
    
    
    
    
    
    //吧操作添加到队列
    [self.queue addOperation:op];
    
    //将操作添加到缓存
    [self.operationCanch setObject:op forKey:urlString];
    
}

-(void)memoryWarning
{
    //移除图片缓存
    [self.imageCanch removeAllObjects];
    //移除操作缓存
    [self.operationCanch removeAllObjects];
    //移除队列里的操作
    [self.queue cancelAllOperations];
    
}


@end
