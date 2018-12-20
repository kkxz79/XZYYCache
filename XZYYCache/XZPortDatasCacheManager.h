//
//  XZPortDatasCacheManager.h
//  XZYYCache
//
//  Created by kkxz on 2018/12/19.
//  Copyright © 2018 kkxz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YYCache.h"

NS_ASSUME_NONNULL_BEGIN

@interface XZPortDatasCacheManager : NSObject
+(instancetype)sharedInstance;
-(YYCache*)cache;
@end

NS_ASSUME_NONNULL_END
