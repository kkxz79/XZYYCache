//
//  Book.h
//  XZYYCache
//
//  Created by kkxz on 2018/12/19.
//  Copyright © 2018 kkxz. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Book : NSObject<NSCoding>
@property(nonatomic,copy)NSString *name;
@property(nonatomic,copy)NSString *author;
@property(nonatomic,copy)NSString *publishHouse;
@property(nonatomic,assign)NSInteger pages;
@end

NS_ASSUME_NONNULL_END
