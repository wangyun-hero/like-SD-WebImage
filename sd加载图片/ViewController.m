//
//  ViewController.m
//  sd加载图片
//
//  Created by 王云 on 16/7/30.
//  Copyright © 2016年 王云. All rights reserved.
//

#import "AFNetworking.h"
#import "NSString+path.h"
#import "UIImageView+WebCache.h"
#import "ViewController.h"
#import "WYAppCell.h"
#import "WYInfo.h"
#import "WYDownloadManager.h"
@interface ViewController ()
@property(nonatomic, strong) NSMutableArray *array;
@property(nonatomic, strong) NSOperationQueue *queue;
//  缓存的图片   key是图片的地址,value是图片
@property(nonatomic, strong) NSMutableDictionary *imageCanch;
//缓存操作
@property(nonatomic, strong) NSMutableDictionary *imageQueue;
@end

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  //加载数据
  // self.view.backgroundColor = [UIColor redColor];
  [self loadData];
}

- (void)loadData {
  //字符串
  NSString *urlString = @"https://raw.githubusercontent.com/yinqiaoyin/"
                        @"SimpleDemo/master/apps.json";
  /**
   参数:
   1. 请求的地址
   2. 请求参数
   3. 加载的进度
   4. 成功的回调
   5. 失败的回调
   */

  //初始化网络请求管理器
  AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];

  [manager GET:urlString
      parameters:nil
      progress:nil
      success:^(NSURLSessionDataTask *_Nonnull task,
                id _Nullable responseObject) {
        //当前线程
        NSLog(@"德玛西亚%@", [NSThread currentThread]);
        NSLog(@"德玛西亚 %@ %@", responseObject, [responseObject class]);
        /**
         *  获取临时数组
         */
        NSArray *tempArray = responseObject;

        //遍历,字典转模型
        for (NSDictionary *dict in tempArray) {
          //初始化模型
          WYInfo *info = [[WYInfo alloc] init];
          // kvc赋值
          [info setValuesForKeysWithDictionary:dict];

          [self.array addObject:info];
        }

        NSLog(@"%@", self.array);

        //刷新数据
        [self.tableView reloadData];

      }
      failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {
        NSLog(@"%@", [NSThread currentThread]);
        NSLog(@"请求失败:%@", error);

      }];
}

#pragma mark -数据源
//多少行
- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
  return self.array.count;
}

//内容
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  //去缓存池找
  WYAppCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellid"
                                                    forIndexPath:indexPath];
  //把数据赋值给模型
  WYInfo *model = self.array[indexPath.row];
  cell.nameLable.text = model.name;
  cell.downLoadLable.text = model.download;
  cell.iconView.image = nil;
 

    [[WYDownloadManager sharedManager] downloadImageWithUrlString:model.icon compeletion:^(UIImage *image) {
        cell.iconView.image = image;
    }];
    
    return cell;
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];

  //删除模型里的 图片
  //    for (int i = 0; i < self.array.count; i++)
  //    {
  //        WYInfo *info = [[WYInfo alloc]init];
  //        info.image = nil;
  //    }

  //删除字典里的图片
  [self.imageCanch removeAllObjects];

  //删除队列里的下载任务
  [self.queue cancelAllOperations];

  //删除字典里所有的操作
  [self.imageQueue removeAllObjects];
}

- (NSString *)canchPathWithUrlString:(NSString *)urlString {
  //获取canch目录
  NSString *canchPath = NSSearchPathForDirectoriesInDomains(
                            NSCachesDirectory, NSUserDomainMask, YES)
                            .firstObject;

  //取到图片名字 t0125e8d438ae9d2fbb.png
  // http://p16.qhimg.com/dr/48_48_/t0125e8d438ae9d2fbb.png
  NSString *name = [urlString lastPathComponent];

  //拼接缓存的图片路径
  NSString *result = [canchPath stringByAppendingPathComponent:name];

  return result;
}

//懒加载,用到的时候才会加载
- (NSMutableArray *)array {
  if (_array == nil) {
    _array = [NSMutableArray array];
  }
  return _array;
}

//队列
- (NSOperationQueue *)queue {
  if (_queue == nil) {
    _queue = [[NSOperationQueue alloc] init];
  }
  return _queue;
}

//图片的缓存
- (NSMutableDictionary *)imageCanch {
  if (_imageCanch == nil) {
    _imageCanch = [NSMutableDictionary dictionary];
  }
  return _imageCanch;
}

- (NSMutableDictionary *)imageQueue {
  if (_imageQueue == nil) {
    _imageQueue = [NSMutableDictionary dictionary];
  }
  return _imageQueue;
}

@end




////方法一
////模型缓存的时候
////判断,当有值的时候,设置图片并且直接返回
////    if (model.image !=nil) {
////        cell.iconView.image = model.image;
////        return cell;
////    }
//
////字典缓存的 判断
////判断字典里有没有某张图片
//UIImage *canchImage = self.imageCanch[model.icon];
//if (canchImage != nil) {
//    //有的话就直接返回,不下载,如果没有继续向下走
//    cell.iconView.image = canchImage;
//    return cell;
//}
//
////确定canch目录的路径
//NSString *canchPath = [model.icon appendCachePath];
////看沙盒目录下是否有这个图片
//canchImage = [UIImage imageWithContentsOfFile:canchPath];
////再判断,有对应图片就返回,没有再下载
//if (canchImage != nil) {
//    
//    // 缓存取内存中一份
//    [self.imageCanch setObject:canchImage forKey:model.icon];
//    cell.iconView.image = canchImage;
//    return cell;
//}
//
////判断是否已经与操作,有就直接返回,没有才添加操作
//if (self.imageQueue[model.icon] != nil) {
//    return cell;
//}
//
////用sdwebimage框架设置图片
////    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:model.icon]];
//
////创建一个操作
//NSBlockOperation *op = [NSBlockOperation blockOperationWithBlock:^{
//    //将图片的url地址转化为二进制
//    NSLog(@"---%@---", [NSThread currentThread]);
//    
//    if (indexPath.row > 12) {
//        [NSThread sleepForTimeInterval:3];
//    }
//    
//    NSData *data =
//    [NSData dataWithContentsOfURL:[NSURL URLWithString:model.icon]];
//    
//    //将图片的二进制数据保存到沙盒
//    //[data writeToFile:[self canchPathWithUrlString:model.icon]
//    // atomically:YES];
//    
//    //----------------分类方法,存入沙盒------------------------
//    [data writeToFile:[model.icon appendCachePath] atomically:YES];
//    
//    //获取图片
//    UIImage *image = [UIImage imageWithData:data];
//    
//    //回到主线程更新UI
//    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
//        
//        // cell.iconView.image = image;
//        
//        //将image赋值给模型属性,模型存储
//        // model.image = image;
//        
//        //如果下载图片失败
//        if (image != nil) {
//            //字典缓存
//            [self.imageCanch setObject:image forKey:model.icon];
//        }
//        
//        //操作完成就需要删除
//        [self.imageQueue removeObjectForKey:model.icon];
//        
//        // 这个方法会调用 返回cell的方法,并且只会刷新对应 indexPath
//        // 的行,传对应的indexpath就会刷新(重新加载)对应的cell
//        [self.tableView reloadRowsAtIndexPaths:@[ indexPath ]
//                              withRowAnimation:UITableViewRowAnimationRight];
//        
//    }];
//    
//}];
//
////将操作添加到字典
//[self.imageQueue setObject:op forKey:model.icon];
//
////将操作添加到队列
//[self.queue addOperation:op];


