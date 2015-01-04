//
// Created by Nicolas Martin on 2014-07-27.
// Copyright (c) 2014 Apportable. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Board;
@class Field;


@interface FieldCollisionHelper : NSObject
+ (FieldCollisionHelper *)sharedMySingleton;

- (void)AddFieldBox:(Field *)board;

- (Field *)GetFieldFromPosition:(CGPoint)point;

@end