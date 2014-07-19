//
// Created by Nicolas Martin on 2014-07-08.
// Copyright (c) 2014 Apportable. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Board;
@class Tetromino;


@interface Field : CCNode

@property NSMutableArray *spellArray;

- (BOOL)randomBoolWithPercentage:(NSUInteger)percentage;
- (void)addSpellToField;
- (BOOL)canMoveTetrominoByYTetromino:(Tetromino *)userTetromino offSetY:(NSUInteger)offSetY;
- (BOOL)canMoveTetrominoByXTetromino:(Tetromino *)userTetromino offSetX:(NSUInteger)offSetX;
- (BOOL)isTetrominoInBounds:(Tetromino *)tetromino noCollisionWith:(Tetromino *)with;
- (BOOL)boardRowEmpty:(NSUInteger)x;
- (void)addBlocks:(NSMutableArray *)blocksToAdd;
- (void)setPositionUsingFieldValue:(NSMutableArray *)arrayOfBlocks;


- (void)moveDownOrCreate;

- (void)createNewTetromino;
@end