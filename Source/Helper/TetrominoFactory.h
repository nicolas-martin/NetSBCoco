//
// Created by Nicolas Martin on 2014-08-10.
// Copyright (c) 2014 hero. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Tetromino;


@interface TetrominoFactory : NSObject
+ (Tetromino *)getTetrominoUsingFrequency;
@end