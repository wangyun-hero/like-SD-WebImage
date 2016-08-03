//
//  WYDownloadManager.h
//  sd加载图片
//
//  Created by 王云 on 16/7/31.
//  Copyright © 2016年 王云. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WYDownloadManager : NSObject
//全局访问点
+(instancetype)sharedManager;

-(void)downloadImageWithUrlString:(NSString *)urlString  compeletion:(void(^)(UIImage *))compeletion;

@end
