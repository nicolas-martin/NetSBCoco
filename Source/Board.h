//
// Created by Nicolas Martin on 2014-07-08.
// Copyright (c) 2014 Apportable. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Tetromino;
@class Block;


@interface Board : CCNode

@property int NbBlocks;
@property NSUInteger Nby;
@property NSUInteger Nbx;

- (id)init;
+ (id)initBoard;
- (BOOL)isBlockAt:(CGPoint)point;

- (NSMutableArray *)getAllBlocksInBoard;

- (NSMutableArray *)getAllInvertedBlocksInBoard;

- (Block *) getBlockAt:(CGPoint)point ;
- (void)DeleteBlockFromBoard:(NSMutableArray *)blocks;
- (void)DeleteBlockFromBoardAndSprite:(NSMutableArray *)blocks;
- (void)MoveTetromino:(Tetromino *)FromTetromino to:(Tetromino *)ToTetromino;
- (void)MoveBlock:(Block *)block to:(CGPoint)after;
- (BOOL)boardRowFull:(NSUInteger)y;
- (NSMutableArray *)DeleteRow:(NSUInteger)y;
- (NSMutableArray *)MoveBoardDown:(NSUInteger)y;
- (void)addTetrominoToBoard:(NSMutableArray *)blocksToAdd;
- (void)printCurrentBoardStatus:(BOOL)withPosition;

- (NSUInteger)moveDownOrCreate;
@end