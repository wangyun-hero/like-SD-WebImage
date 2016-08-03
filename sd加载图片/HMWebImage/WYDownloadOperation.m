//
//  WYDownloadOperation.m
//  sd加载图片
//
//  Created by 王云 on 16/7/31.
//  Copyright © 2016年 王云. All rights reserved.
//

#import "WYDownloadOperation.h"
#import "NSString+path.h"
@interface WYDownloadOperation()
@property(nonatomic,copy)NSString *urlString;
@end
@implementation WYDownloadOperation

//根据传入的urlstring创建一个操作,并且记录这个string
+(instancetype)operationWithUrlString:(NSString *)urlString
{
    WYDownloadOperation *op = [WYDownloadOperation new];
    op.urlString = urlString;
    return op;
    
}

//将操作添加到队列就会调用
-(void)main
{
    [NSThread sleepForTimeInterval:arc4random_uniform(5)];
    NSURL *url = [NSURL URLWithString:self.urlString];
    
    NSData *data = [NSData dataWithContentsOfURL:url];
    
    UIImage *image = [UIImage imageWithData:data];
    
    [data writeToFile:[self.urlString appendCachePath] atomically:true];
    
    self.image = image;
}


@end
