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
//原理是这样,当每次调用这个方法的时候,我们都记录下url地址,当我们再次下载的时候我们就判断记录的URL地址是不是和传进来的地址一样,如果一样我就取消之前的下载,并且把这个传进来的url地址记录
-(void)wy_setImageWithURLstring:(NSString *)urlstring;
{
    NSLog(@"取消之前操作");
    if (self.string != nil && [self.string isEqualToString:urlstring]) {
        
        // 取消掉之前的下载操作
        // 如何才能取到之前的下载地址 --> 在每一次下载的时候,将下载地址保存一下
        /**
         1. 下载`爸爸去哪儿`的时候,将该图片地址保存起来
         2. 当用户滑动到最上面的时候,又会去下载植物,在这个时候就可以取到上一次的下载地址
         3. 再通过地址去取消`爸爸去哪儿`的下载操作
         
         */

        [[WYDownloadManager sharedManager] cancleOperationWithurlString:self.string];
    }
    
    //记录当前下载的图片的url地址
    self.string = urlstring;
    
    
    [[WYDownloadManager sharedManager] downloadImageWithUrlString:urlstring compeletion:^(UIImage *image) {
        self.image = image;
        // 当前图片已下载成功 : 当前图片已经下载成功了,所以不需要再保存图片地址,因为下次再进来的时候就重新去下载另外一张图片
        self.string = nil;

    }];
    
  }

@end
