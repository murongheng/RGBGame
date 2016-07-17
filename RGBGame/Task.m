//
//  Task.m
//  RGBGame
//
//  Created by 千锋 on 16/2/28.
//  Copyright © 2016年 mobiletrain. All rights reserved.
//

#import "Task.h"

@implementation Task

//归档
- (void) encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.taskColor forKey:@"taskColor"];
    [aCoder encodeInteger:self.number forKey:@"number"];
    [aCoder encodeInteger:self.speed forKey:@"speed"];
    [aCoder encodeInteger:self.checkPoint forKey:@"checkPoint"];
    [aCoder encodeObject:self.colorStr forKey:@"colorStr"];
    [aCoder encodeObject:self.myLayer forKey:@"layer"];
    [aCoder encodeInteger:self.hightScore forKey:@"hightScore"];
    
}

//解归档
- (instancetype) initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        _taskColor = [aDecoder decodeObjectForKey:@"taskColor"];
        _number = [aDecoder decodeIntegerForKey:@"number"];
        _speed = [aDecoder decodeIntegerForKey:@"speed"];
        _checkPoint = [aDecoder decodeIntegerForKey:@"checkPoint"];
        _colorStr = [aDecoder decodeObjectForKey:@"colorStr"];
        _myLayer = [aDecoder decodeObjectForKey:@"layer"];
        _hightScore = [aDecoder decodeIntegerForKey:@"hightScore"];
    }
   return self;
}

@end
