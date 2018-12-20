//
//  UserManager.m
//  XZYYCache
//
//  Created by kkxz on 2018/12/19.
//  Copyright © 2018 kkxz. All rights reserved.
//

#import "UserManager.h"

@implementation UserManager
-(void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:_account forKey:@"account"];
    [aCoder encodeInteger:_age forKey:@"age"];
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self  = [super init]) {
        //注意一定要给成员变量赋值保存起来
        _account = [aDecoder decodeObjectForKey:@"account"];
        _age =   [aDecoder decodeIntForKey:@"age"];
    }
        return self;
}

//自定义的归档保存数据的方法
+(void)saveUser:(UserManager *)user {
    NSString *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
    NSString *path=[docPath stringByAppendingPathComponent:@"UserInfo.plist"];
    [NSKeyedArchiver archiveRootObject:user toFile:path];
}

//自定义的读取沙盒中解档出的数据
+(UserManager *)getUser {
    NSString *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
    NSString *path=[docPath stringByAppendingPathComponent:@"UserInfo.plist"];
    UserManager *user = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    return user;
}

@end
