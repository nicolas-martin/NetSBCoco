//
// Created by Nicolas Martin on 2014-07-19.
// Copyright (c) 2014 Apportable. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kLastColumn 9
#define kLastRow 19
#define rowoffset 3
typedef enum {
    I_block,
    O_block,
    J_block,
    L_block,
    Z_block,
    S_block,
    T_block
} tetrominoType;
typedef enum {
    rotateCounterclockwise = -1,
    rotateNone = 0,
    rotateClockwise = 1
} RotationDirection;

typedef enum {
    moveLeft = -1,
    moveNone = 0,
    moveRight = 1
} MoveDirection;

@interface Tetromino : CCNode {
    BOOL stuck;
    CGPoint leftMostPosition;
    CGPoint rightMostPosition;
    //NSUInteger orientation;
}
@property NSUInteger orientation;
@property NSMutableArray *blocksInTetromino;
@property BOOL stuck;
@property NSUInteger anchorX;
@property NSUInteger anchorY;
@property(nonatomic) CGPoint leftMostPosition;
@property(nonatomic) CGPoint rightMostPosition;
@property(nonatomic) CGPoint highestPosition;
@property(nonatomic) CGPoint lowestPosition;
@property tetrominoType type;

+ (id)randomBlockUsingBlockFrequency;

- (id)initWithRandomTypeAndOrientationUsingFrequency;

+ (id)blockWithType:(tetrominoType)blockType Direction:(RotationDirection)blockOrientation BoardX:(NSUInteger)positionX BoardY:(NSUInteger)positionY CurrentOrientation:(NSUInteger)CurrentOrientation;

- (BOOL)isBlockInTetromino:(id)block;

- (void)moveTetrominoInDirection:(MoveDirection)direction;

+ (Tetromino *)rotateTetromino:(Tetromino *)userTetromino in:(RotationDirection)direction;

- (void)moveTetrominoDown;

- (void)MoveBoardPosition:(Tetromino *)ToTetromino;

- (NSString *)description;


@end