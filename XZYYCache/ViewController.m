//
//  ViewController.m
//  XZYYCache
//
//  Created by kkxz on 2018/12/12.
//  Copyright © 2018 kkxz. All rights reserved.
//

#import "ViewController.h"
#import "YYCache.h"
#import "XZCacheViewController.h"
#import "UserManager.h"

#define kUserPath [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:@"latestQuery.plist"]

@interface ViewController ()
@property(nonatomic,assign)NSInteger cacheType;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"YYCache";
    self.view.backgroundColor = [UIColor whiteColor];
    UIBarButtonItem * barButton = [[UIBarButtonItem alloc] initWithTitle:@"action" style:UIBarButtonItemStylePlain target:self action:@selector(rightButtonAction)];
    self.navigationItem.rightBarButtonItem = barButton;
    
    //沙盒相关
    NSLog(@"获取沙盒目录路径：%@",NSHomeDirectory());
    //获取Documents目录路径
    NSString *document = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory , NSUserDomainMask, YES)[0];
    NSLog(@"获取Documents目录路径 %@",document);
    //获取tmp目录路径
    NSString *tmp = NSTemporaryDirectory();
    NSLog(@"获取tmp目录路径：%@",tmp);
    
    _cacheType = 11;
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
        case 6:
        {
            [self plistWriteData];//属性列表存储
        }
            break;
        case 7:
        {
            [self plistReadData];//读取属性列表数据
        }
            break;
        case 8:
        {
            [self userDefaultsWriteData];//写入偏好设置数据
        }
            break;
        case 9:
        {
            [self userDefaultsReadData];//读取偏好设置数据
        }
            break;
        case 10:
        {
            [self cleanDefaultsData];//清除数据
        }
            break;
        case 11:
        {
            [self keyedArchiveSave];//归档
        }
            break;
        case 12:
        {
            [self keyedArchiverRead];//解档
        }
            break;
       
        default:
            break;
    }
}

-(void)rightButtonAction {
    XZCacheViewController * cacheVC = [[XZCacheViewController alloc] init];
    [self.navigationController pushViewController:cacheVC animated:YES];
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

//TODO:数据存储-property list 属性列表
-(void)plistWriteData {
    NSArray *arr = @[@"小白",@"龙猫"];
    /**
     1、获取应用的文件夹（应用沙盒）
     NSSearchPathDirectory 搜索的目录
     NSSearchPathDomainMask 搜索范围 NSUserDomainMask：表示在用户的手机上查找
     expandTilde 是否展开全路径~ 如果没有展开,应用的沙盒路径就是~
     存储一定要展开路径 如果要存东西 必须要是YES
     */
    [arr writeToFile:kUserPath atomically:YES];
}

-(void)plistReadData {
    NSArray * arr = [NSArray arrayWithContentsOfFile:kUserPath];
    NSLog(@"读取属性列表中数据：%@ %@",arr[0],arr[1]);
}

//TODO:数据存储- Preference 偏好设置 NSUserdefaults
-(void)userDefaultsWriteData {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    //放到缓存里，并不会马上放到文件里
    [userDefaults setObject:@"xiaobai" forKey:@"account"];
    [userDefaults setObject:@"123456" forKey:@"pwd"];
    [userDefaults setObject:@YES forKey:@"status"];
    [userDefaults synchronize];
}

-(void)userDefaultsReadData {
    NSString *account = [[NSUserDefaults standardUserDefaults] objectForKey:@"account"];
    NSString *pwd = [[NSUserDefaults standardUserDefaults] objectForKey:@"pwd"];
    NSLog(@"偏好设置---账号：%@ 密码：%@",account,pwd);
}

-(void)cleanDefaultsData {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults removeObjectForKey:@"account"];
    [userDefaults removeObjectForKey:@"pwd"];
    [userDefaults synchronize];
    NSString *account = [[NSUserDefaults standardUserDefaults] objectForKey:@"account"];
    NSLog(@"账号---%@",account);
}

//TODO:NSKeyedArchiver 归档
-(void)keyedArchiveSave {
    UserManager * userInfo = [[UserManager alloc] init];
    userInfo.account = @"13879797979";
    userInfo.age = 17;
    [UserManager saveUser:userInfo];
}

-(void)keyedArchiverRead {
    UserManager * userInfo = [UserManager getUser];
    NSLog(@"NSKeyedArchiver归档-----账号:%@---年龄:%d",userInfo.account,userInfo.age);
}

@end
