//
// Created by Nicolas Martin on 2014-07-08.
// Copyright (c) 2014 Apportable. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Board;


@interface Field : CCNode

@property Board *board;
@property NSObject *Name;
@property NSMutableArray *spellArray;

- (BOOL)randomBoolWithPercentage:(NSUInteger)percentage;
- (void)addSpellToField;
- (BOOL)canMoveTetrominoByYTetromino:(Tetromino *)userTetromino offSetY:(NSUInteger)offSetY;
- (BOOL)canMoveTetrominoByXTetromino:(Tetromino *)userTetromino offSetX:(NSUInteger)offSetX;
- (BOOL)isTetrominoInBounds:(Tetromino *)tetromino noCollisionWith:(Tetromino *)with;
- (BOOL)boardRowEmpty:(NSUInteger)x;
- (void)addBlocks:(NSMutableArray *)blocksToAdd;
- (void)setPositionUsingFieldValue:(NSMutableArray *)arrayOfBlocks;


@end