//
//  UIImageView+HMWebCache.m
//  sd加载图片
//
//  Created by 王云 on 16/8/3.
//  Copyright © 2016年 王云. All rights reserved.
//

#import "UIImageView+HMWebCache.h"
#import "WYDownloadManager.h"

@implementation UIImageView (HMWebCache)

-(void)wy_setImageWithURLstring:(NSString *)urlstring;
{
    
    [[WYDownloadManager sharedManager] downloadImageWithUrlString:urlstring compeletion:^(UIImage *image) {
        self.image = image;
    }];
    
  }

@end
