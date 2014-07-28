//
// Created by Nicolas Martin on 2014-07-27.
// Copyright (c) 2014 Apportable. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Board;


@interface FieldCollisionHelper : NSObject
+ (FieldCollisionHelper*)sharedMySingleton;
- (void)AddFieldBox:(Board *)board;
- (Board *) GetFieldFromPosition:(CGPoint) point;

@end