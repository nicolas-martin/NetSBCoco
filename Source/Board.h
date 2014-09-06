//
// Created by Nicolas Martin on 2014-07-08.
// Copyright (c) 2014 Apportable. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Tetromino;
@class Block;


@interface Board : CCNode// <NScoder>

@property int NbBlocks;
@property NSUInteger Nby;
@property NSUInteger Nbx;
@property NSString *Name;


- (id)init;

- (void)swipeDown:(UISwipeGestureRecognizer *)fallDown;

- (BOOL)isBlockAt:(CGPoint)point;

- (NSMutableArray *)getAllBlocksInBoard;

- (NSMutableArray *)getAllInvertedBlocksInBoard;

- (Block *)getBlockAt:(CGPoint)point;

- (void)DeleteBlockFromBoard:(NSMutableArray *)blocks;

- (void)DeleteBlockFromBoardAndSprite:(NSMutableArray *)blocks;

- (void)MoveTetromino:(Tetromino *)FromTetromino to:(Tetromino *)ToTetromino;

- (void)MoveBlock:(Block *)block to:(CGPoint)after;

- (BOOL)boardRowFull:(NSUInteger)y;

- (NSMutableArray *)DeleteRow:(NSUInteger)y;

- (NSMutableArray *)MoveBoardDown:(NSUInteger)y nbRowsToMoveDownTo:(NSUInteger)step;

- (void)addTetrominoToBoard:(NSMutableArray *)blocksToAdd;

- (void)printCurrentBoardStatus:(BOOL)withPosition;

- (void)addBlocks:(NSMutableArray *)blocksToAdd;

- (void)setPositionUsingFieldValue:(NSMutableArray *)arrayOfBlocks;

- (BOOL)moveDownOrCreate;

- (NSMutableArray *)checkForRowsToClear;

- (NSMutableArray *)deleteRowsAndReturnSpells:(NSMutableArray *)rowsToDelete;
@end