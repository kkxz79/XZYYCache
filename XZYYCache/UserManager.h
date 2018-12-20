//
//  UserManager.h
//  XZYYCache
//
//  Created by kkxz on 2018/12/19.
//  Copyright © 2018 kkxz. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface UserManager : NSObject<NSCoding>
@property(nonatomic,copy)NSString *account;
@property(nonatomic,assign)int age;
//自定义的归档保存数据的方法
+(void)saveUser:(UserManager *)user;
//自定义的读取沙盒中解档出的数据
+(UserManager *)getUser;

@end

NS_ASSUME_NONNULL_END
