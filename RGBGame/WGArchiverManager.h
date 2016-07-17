//
//  WGArchiverManager.h
//  王刚-OCTest
//
//  Created by 千锋 on 15/12/25.
//  Copyright (c) 2015年 abc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WGArchiverManager : NSObject

+ (void)archiverObject:(id)object forKey:(NSString *)key inPath:(NSString *)path;

+ (id)unarchiverObjectforKey:(NSString *)key inPath:(NSString *)path;
@end
