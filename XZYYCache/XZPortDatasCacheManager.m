//
//  XZPortDatasCacheManager.m
//  XZYYCache
//
//  Created by kkxz on 2018/12/19.
//  Copyright © 2018 kkxz. All rights reserved.
//

#import "XZPortDatasCacheManager.h"

@interface XZPortDatasCacheManager()
@property(nonatomic,strong)YYCache * dataCache;
@end

@implementation XZPortDatasCacheManager
+(instancetype)sharedInstance {
    static XZPortDatasCacheManager * singleton = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        singleton = [[XZPortDatasCacheManager alloc] init];
    });
    return singleton;
}

-(instancetype)init {
    self = [super init];
    if(self){
        [self creatCache];
    }
    return self;
}

/**
 初始化cache
 */
-(void)creatCache {
    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    NSString * filePath = [path stringByAppendingPathComponent:@"cacheDatas"];
    self.dataCache = [[YYCache alloc] initWithPath:filePath];
}

/**
 获取cache
 */
-(YYCache*)cache {
    return self.dataCache;
}

@end
