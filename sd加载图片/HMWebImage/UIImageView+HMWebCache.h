//
//  UIImageView+HMWebCache.h
//  sd加载图片
//
//  Created by 王云 on 16/8/3.
//  Copyright © 2016年 王云. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (HMWebCache)

@property(nonatomic,strong)NSString *string;

-(void)wy_setImageWithURLstring:(NSString *)urlstring;

@end
