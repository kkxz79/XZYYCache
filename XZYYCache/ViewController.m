//
//  ViewController.m
//  XZYYCache
//
//  Created by kkxz on 2018/12/12.
//  Copyright © 2018 kkxz. All rights reserved.
//

#import "ViewController.h"
#import "YYCache.h"

@interface ViewController ()
@property(nonatomic,assign)NSInteger cacheType;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _cacheType = 4;
    switch (_cacheType) {
        case 1:
        {
            [self syncTypeUseYYCache];//同步调用
        }
            break;
        case 2:
        {
            [self asyncTypeUseYYCache];//异步调用
        }
            break;
        case 3:
        {
            [self useLRUWithYYCache];//缓存清理
        }
            break;
        case 4:
        {
            [self performanceWithWrite];//写入性能
        }
            break;
        case 5:
        {
            [self performanceWithRead];//读取性能
        }
            break;
        default:
            break;
    }
}

//TODO:同步调用
-(void)syncTypeUseYYCache {
    //同步
    NSString *value = @"I want to know who is kkxz ?";
    //同步方式，模拟一个key
    NSString * key = @"key";
    YYCache * yyCache = [YYCache cacheWithName:@"XZCache"];
    
    //根据key写入缓存value
    [yyCache setObject:value forKey:key];
    
    //判断缓存是否存在
    BOOL isContains = [yyCache containsObjectForKey:key];
    NSLog(@"containsObject：%@",isContains ? @"YES" : @"NO");
    
    //根据keyd读取数据
    id vl = [yyCache objectForKey:key];
    NSLog(@"value：%@",vl);
    
    //根据key移除缓存
    [yyCache removeObjectForKey:key];
    
    //移除所有缓存
    [yyCache removeAllObjects];
    
    vl = [yyCache objectForKey:key];
    NSLog(@"remove-value：%@",vl);
    
}

//TODO:异步调用
-(void)asyncTypeUseYYCache {
    //异步
    NSString *value = @"I want to know who is kkxz ?";
    NSString * key = @"key";
    YYCache * yyCache = [YYCache cacheWithName:@"XZCache"];
    
    //根据key写入缓存value
    [yyCache setObject:value forKey:key withBlock:^{
        NSLog(@"setObject success");
    }];
    
    //判断缓存是否存在
    [yyCache containsObjectForKey:key withBlock:^(NSString * _Nonnull key, BOOL contains) {
        NSLog(@"containsObject : %@", contains?@"YES":@"NO");
    }];
    
    //根据key读取数据
    [yyCache objectForKey:key withBlock:^(NSString * _Nonnull key, id<NSCoding>  _Nonnull object) {
        NSLog(@"objectForKey：%@",object);
    }];
    
    //根据key移除缓存
    [yyCache removeObjectForKey:key withBlock:^(NSString * _Nonnull key) {
        NSLog(@"removeObjectForKey：%@",key);
    }];
    
    //移除所有缓存带进度
    [yyCache removeAllObjectsWithProgressBlock:^(int removedCount, int totalCount) {
        NSLog(@"removeAllObjects removedCount :%d  totalCount : %d",removedCount,totalCount);
    } endBlock:^(BOOL error) {
        if(!error){
            NSLog(@"progress-removeAllObjects success");
        }else {
            NSLog(@"removeAllObjects error");
        }
    }];
    
    //移除所有缓存
    [yyCache removeAllObjectsWithBlock:^{
        NSLog(@"removeAllObjects success");
    }];
    
}

//TODO:缓存清理LRU
-(void)useLRUWithYYCache {
    YYCache * yyCache = [YYCache cacheWithName:@"XZCache"];
    yyCache.memoryCache.countLimit = 50;//内存最大缓存数据个数
    yyCache.memoryCache.costLimit = 1*1024;//内存最大缓存开销 目前这个毫无用处
    yyCache.diskCache.costLimit = 10*1024;//磁盘最大缓存开销
    yyCache.diskCache.countLimit = 50;//磁盘最大缓存数据个数
    yyCache.diskCache.autoTrimInterval = 60;//设置磁盘LRU动态清理频率 默认是60秒

    for(int i=0 ;i<100;i++) {
        //模拟数据
        NSString *value=@"I want to know who is kkxz ?";
        //模拟一个key
        NSString *key=[NSString stringWithFormat:@"key%d",i];
        [yyCache setObject:value forKey:key];
    }
    
    NSLog(@"yyCache.memoryCache.totalCost:%lu",(unsigned long)yyCache.memoryCache.totalCost);
    NSLog(@"yyCache.memoryCache.costLimit:%lu",(unsigned long)yyCache.memoryCache.costLimit);
    
    NSLog(@"yyCache.memoryCache.totalCount:%lu",(unsigned long)yyCache.memoryCache.totalCount);
    NSLog(@"yyCache.memoryCache.countLimit:%lu",(unsigned long)yyCache.memoryCache.countLimit);

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(120 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        NSLog(@"yyCache.diskCache.totalCost:%lu",(unsigned long)yyCache.diskCache.totalCost);
        NSLog(@"yyCache.diskCache.costLimit:%lu",(unsigned long)yyCache.diskCache.costLimit);
        
        NSLog(@"yyCache.diskCache.totalCount:%lu",(unsigned long)yyCache.diskCache.totalCount);
        NSLog(@"yyCache.diskCache.countLimit:%lu",(unsigned long)yyCache.diskCache.countLimit);
        
        for(int i=0 ;i<100;i++){
            //模拟一个key
            NSString *key=[NSString stringWithFormat:@"who is kkxz %d",i];
            id vuale=[yyCache objectForKey:key];
            NSLog(@"key ：%@ value : %@",key ,vuale);
        }
    });
    
}

//TODO:写入性能分析
-(void)performanceWithWrite {
    NSString *value = @"I want to know who is kkxz ?";
    NSString * key = @"key";
    YYCache * yyCache = [YYCache cacheWithName:@"XZCache"];
    
    //写入数据
    CFAbsoluteTime start = CFAbsoluteTimeGetCurrent();
    [yyCache setObject:value forKey:key withBlock:^{
        CFAbsoluteTime end = CFAbsoluteTimeGetCurrent();
        NSLog(@"yyCache async setObject time cost：%0.5f",end - start);
    }];
    
    CFAbsoluteTime start1 = CFAbsoluteTimeGetCurrent();
    [yyCache setObject:value forKey:key];
    CFAbsoluteTime end1 = CFAbsoluteTimeGetCurrent();
    NSLog(@"yyCache sync setObject time cost: %0.5f", end1 - start1);
}

//TODO:读取性能分析
-(void)performanceWithRead {
    YYCache *yyCache=[YYCache cacheWithName:@"XZCache"];
    //模拟一个key
    NSString *key=@"key";
    CFAbsoluteTime start = CFAbsoluteTimeGetCurrent();
    //读取数据
    [yyCache objectForKey:key withBlock:^(NSString * _Nonnull key, id<NSCoding>  _Nonnull object) {
        CFAbsoluteTime end = CFAbsoluteTimeGetCurrent();
        NSLog(@"yyCache async objectForKey time cost: %0.5f", end - start);
    }];
    
    CFAbsoluteTime start1 = CFAbsoluteTimeGetCurrent();
    [yyCache objectForKey:key];
    CFAbsoluteTime  end1 = CFAbsoluteTimeGetCurrent();
    NSLog(@"yyCache sync objectForKey time cost: %0.5f", end1 - start1);
}

@end
