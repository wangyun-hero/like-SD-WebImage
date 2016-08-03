//
//  WYInfo.h
//  sd加载图片
//
//  Created by 王云 on 16/7/30.
//  Copyright © 2016年 王云. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WYInfo : NSObject

/**
 *  下载数量
 */
@property (nonatomic, copy) NSString *download;
/**
 *  图标地址
 */
@property (nonatomic, copy) NSString *icon;
/**
 *  app名字
 */
@property (nonatomic, copy) NSString *name;


@property(nonatomic,strong)UIImage *image;

@end
