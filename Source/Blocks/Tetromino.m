//
// Created by Nicolas Martin on 2014-07-19.
// Copyright (c) 2014 Apportable. All rights reserved.
//

#import <MacTypes.h>
#import "Tetromino.h"
#import "Block.h"


@implementation Tetromino {

}

- (id)copyWithZone {
    Tetromino *copy = [[[self class] alloc] init];

    if (copy != nil) {
        copy->stuck = stuck;
        copy->leftMostPosition = leftMostPosition;
        copy->rightMostPosition = rightMostPosition;
        copy.orientation = self.orientation;
        copy.blocksInTetromino = self.blocksInTetromino;
        copy.anchorX = self.anchorX;
        copy.anchorY = self.anchorY;
        copy.leftMostPosition = self.leftMostPosition;
        copy.rightMostPosition = self.rightMostPosition;
        copy.highestPosition = self.highestPosition;
        copy.lowestPosition = self.lowestPosition;
        copy.type = self.type;
    }

    return copy;
}


- (BOOL)stuck {
    for (Block *block in self.children) {
        stuck = block.stuck;
    }
    return stuck;
}

- (void)setStuck:(BOOL)stuckValue {
    stuck = stuckValue;
    for (Block *block in self.children) {
        block.stuck = stuckValue;
    }
}

- (BOOL)isBlockInTetromino:(id)block {
    if (block != nil) {
        for (Block *currentBlock in self.children) {
            if ([currentBlock isEqual:block]) {
                return YES;
            }
        }
    }
    return NO;
}

- (void)moveTetrominoInDirection:(MoveDirection)direction {
    for (Block *currentBlock in self.children) {
        [currentBlock moveByX:direction];
    }

    self.anchorX += direction;
}


- (void)rotateTetromino:(RotationDirection)direction {

    NSUInteger px = self.anchorX;
    NSUInteger py = self.anchorY;

    for (Block *block in self.children){
        NSUInteger y1 = block.boardY;
        NSUInteger x1 = block.boardX;

        NSUInteger x2 = y1 + px - py;
        NSUInteger y2 = (px + py - x1); //-1 maybe?


        block.boardX = x2;
        block.boardY = y2;
    }


}

+ (Tetromino *)rotateTetromino:(Tetromino *)userTetromino in:(RotationDirection)direction {

    NSUInteger px = userTetromino.anchorX;
    NSUInteger py = userTetromino.anchorY;

    for (Block *block in userTetromino.children){
        NSUInteger y1 = block.boardY;
        NSUInteger x1 = block.boardX;

        NSUInteger x2 = y1 + px - py;
        NSUInteger y2 = (px + py - x1); //-1 maybe?


        block.boardX = x2;
        block.boardY = y2;
    }


    return userTetromino;

}

- (void)moveTetrominoDown {

    NSMutableArray *reversedChildren = [[NSMutableArray alloc] initWithArray:self.children];  // make copy


    for (Block *currentBlock in [reversedChildren reverseObjectEnumerator]) {
        //move each block down
        [currentBlock moveDown];
    }

    self.anchorY += 1;
}

- (CGPoint)leftMostPosition {

    CGPoint myLeftPosition = ccp(999, 999);
    for (Block *currentBlock in self.children) {
        if (myLeftPosition.x > currentBlock.boardX) {
            myLeftPosition = ccp(currentBlock.boardX, currentBlock.boardY);
        }
    }
    [self setLeftMostPosition:myLeftPosition];
    return myLeftPosition;

}

- (CGPoint)rightMostPosition {
    CGPoint myRightPosition = ccp(-1, -1);
    for (Block *currentBlock in self.children) {
        if (myRightPosition.x < currentBlock.boardX) {
            myRightPosition = ccp(currentBlock.boardX, currentBlock.boardY);
        }
    }
    [self setRightMostPosition:myRightPosition];
    return myRightPosition;
}

- (CGPoint)highestPosition {

    CGPoint myLeftPosition = ccp(999, 999);
    for (Block *currentBlock in self.children) {
        if (myLeftPosition.y > currentBlock.boardY) {
            myLeftPosition = ccp(currentBlock.boardX, currentBlock.boardY);

        }
    }
    [self setHighestPosition:myLeftPosition];
    return myLeftPosition;

}

- (CGPoint)lowestPosition {
    CGPoint myRightPosition = ccp(-1, -1);
    for (Block *currentBlock in self.children) {
        if (myRightPosition.y < currentBlock.boardY) {
            myRightPosition = ccp(currentBlock.boardX, currentBlock.boardY);
        }
    }
    [self setLowestPosition:myRightPosition];
    return myRightPosition;
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