//
// Created by Nicolas Martin on 2014-07-19.
// Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Tetromino.h"
#import "Block.h"


@implementation Tetromino {

}
- (BOOL)stuck
{
    for (Block *block in self.children) {
        stuck = block.stuck;
    }
    return stuck;
}

- (void)setStuck:(BOOL)stuckValue
{
    stuck = stuckValue;
    for (Block *block in self.children) {
        block.stuck = stuckValue;
    }
}
- (BOOL)isBlockInTetromino:(id)block
{
    if (block != nil)
    {
        for (Block *currentBlock in self.children) {
            if ([currentBlock isEqual:block]) {
                return YES;
            }
        }
    }
    return NO;
}
- (void)moveTetrominoInDirection:(Tetromino *)tetromino inDirection:(MoveDirection)direction
{
    for (Block* currentBlock in tetromino.children)
    {
        [currentBlock moveByX:direction];
    }

    tetromino.anchorX += direction;
}

+ (Tetromino *)rotateTetromino:(Tetromino *)userTetromino in:(RotationDirection)direction {

    return [Tetromino blockWithType:userTetromino.type Direction:direction BoardX:userTetromino.anchorX BoardY:userTetromino.anchorY CurrentOrientation:userTetromino.orientation];
}

- (void)moveTetrominoDown {

    NSMutableArray *reversedChildren = [[NSMutableArray alloc] initWithArray:self.children];  // make copy


    for (Block *currentBlock in [reversedChildren reverseObjectEnumerator] )
    {
        //move each block down
        [currentBlock moveDown];
    }

    self.anchorY += 1;
}
- (NSString *)description {
    NSMutableString *description = [NSMutableString string];
    [description appendFormat:@"self.type=%d", self.type];
    [description appendFormat:@", self.orientation=%i", self.orientation];
    [description appendFormat:@", self.lowestPosition.x=%f", self.lowestPosition.x];
    [description appendFormat:@", self.lowestPosition.y=%f", self.lowestPosition.y];
    [description appendFormat:@", self.anchorX=%i", self.anchorX];
    [description appendFormat:@", self.anchorY=%i", self.anchorY];

    return [NSString stringWithFormat:@"<%@: %@>", NSStringFromClass([self class]), description];

}
@end