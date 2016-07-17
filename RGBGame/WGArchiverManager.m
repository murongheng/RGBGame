//
//  WGArchiverManager.m
//  王刚-OCTest
//
//  Created by 千锋 on 15/12/25.
//  Copyright (c) 2015年 abc. All rights reserved.
//

#import "WGArchiverManager.h"

@implementation WGArchiverManager
+ (void)archiverObject:(id)object forKey:(NSString *)key inPath:(NSString *)path {
    NSMutableData * data = [[NSMutableData alloc] init];
    NSKeyedArchiver * archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archiver encodeObject:object forKey:key];
    [archiver finishEncoding];
    
    [data writeToFile:path atomically:YES];
}

+ (id)unarchiverObjectforKey:(NSString *)key inPath:(NSString *)path {
    
    NSData * data = [[NSData alloc] initWithContentsOfFile:path];
    NSKeyedUnarchiver * unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
    id obj = [unarchiver decodeObjectForKey:key];
    [unarchiver finishDecoding];
    return obj;
}

@end
