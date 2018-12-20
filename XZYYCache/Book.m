//
//  Book.m
//  XZYYCache
//
//  Created by kkxz on 2018/12/19.
//  Copyright © 2018 kkxz. All rights reserved.
//

#import "Book.h"

@implementation Book

//归档（序列化）
-(void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.author forKey:@"author"];
    [aCoder encodeObject:self.publishHouse forKey:@"publishHouse"];
    [aCoder encodeInteger:self.pages forKey:@"pages"];
}

//反归档 （反序列化）
-(instancetype)initWithCoder:(NSCoder *)aDecoder {
    self.name = [aDecoder decodeObjectForKey:@"name"];
    self.author = [aDecoder decodeObjectForKey:@"author"];
    self.publishHouse = [aDecoder decodeObjectForKey:@"publishHouse"];
    self.pages = [aDecoder decodeIntegerForKey:@"pages"];
    
    return self;
}

@end
