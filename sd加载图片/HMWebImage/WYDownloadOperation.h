//
//  WYDownloadOperation.h
//  sd加载图片
//
//  Created by 王云 on 16/7/31.
//  Copyright © 2016年 王云. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WYDownloadOperation : NSOperation


@property(nonatomic,strong) UIImage *image;

+(instancetype)operationWithUrlString:(NSString *)urlString;
@end
