//
// Created by Nicolas Martin on 2014-07-19.
// Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Tetromino.h"
#import "Block.h"


@implementation Tetromino {

}

+ (Tetromino *) CreateRandomTetromino
{
    NSMutableDictionary *shapes = [NSMutableDictionary dictionary];
    [shapes setValue:@"T" forKey:@"0"];
    [shapes setValue:@"L" forKey:@"1"];
    [shapes setValue:@"J" forKey:@"2"];
    [shapes setValue:@"Z" forKey:@"3"];
    [shapes setValue:@"S" forKey:@"4"];
    [shapes setValue:@"O" forKey:@"5"];
    [shapes setValue:@"I" forKey:@"6"];

    Tetromino * tetromino = nil;

    //NSUInteger random = arc4random() % 7;
    NSUInteger random = 6;

    NSString *key = [shapes valueForKey:[NSString stringWithFormat:@"%d",random]];

    tetromino = (Tetromino *) [CCBReader load:[NSString stringWithFormat:@"Shapes/%@",key]];
    tetromino.type = (tetrominoType) random;

    for (int i = 0; i < 4; i++){
        [tetromino moveTetrominoInDirection:moveRight];
    }

    return tetromino;

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

- (BOOL)isBlockInTetromino:(Block *)block {
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