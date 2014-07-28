//
// Created by Nicolas Martin on 2014-07-08.
// Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Board.h"
#import "Block.h"
#import "Tetromino.h"
#import "SpellFactory.h"


@implementation Board {
    NSMutableArray *_array;
    Tetromino *userTetromino;
}

- (id)init {
    self = [super init];
    if (self) {
        self.Nbx = 10;
        self.Nby = 20;
        _array = self.get20x10Array;
        self.userInteractionEnabled = YES;
    }

    return self;
}

- (void)addSpellToField {

    NSMutableArray *allBlocksInBoard = [self getAllBlocksInBoard];
    NSUInteger nbBlocksInBoard = allBlocksInBoard.count;
    NSUInteger nbSpellToAdd = 0;

    for (NSUInteger i = 0; i < nbBlocksInBoard; i++) {
        //55% of the blocks will have a spell
        if ([self randomBoolWithPercentage:55]) {
            nbSpellToAdd++;
        }
    }

    for (NSUInteger i = 0; i < nbSpellToAdd; i++) {
        NSUInteger posOfSpell = arc4random() % nbBlocksInBoard;
        Block *block = [allBlocksInBoard objectAtIndex:posOfSpell];
        if (block.spell == nil) {
            id <ICastable> spell = [SpellFactory getSpellUsingFrequency];
            [block addSpellToBlock:spell];
        }
    }
}

- (BOOL)randomBoolWithPercentage:(NSUInteger)percentage {
    return (arc4random() % 100) < percentage;
}

- (void)onEnter {
    //doesn't work?
}

- (void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    //this sucks!
    CGPoint pos = [touch locationInNode:self];

    CGPoint tileCoordForPosition = [self tileCoordForPosition:pos];
    CGFloat leftMostX = 0;
    CGFloat rightMostX = 0;
    CGFloat lowestY = 0;

    //compute
    leftMostX = [userTetromino leftMostPosition].x;
    rightMostX = [userTetromino rightMostPosition].x;
    lowestY = [userTetromino lowestPosition].y;

    if (tileCoordForPosition.x < leftMostX) {
        [self moveTetrominoLeft];
    }
    else if (tileCoordForPosition.x > rightMostX) {
        [self moveTetrominoRight];
    }
    else if (tileCoordForPosition.y > lowestY) {
        while (!userTetromino.stuck) {
            [self moveDownOrCreate];
        }

    }


}

- (CGPoint)tileCoordForPosition:(CGPoint)position {
    CGFloat tileWidth = [[userTetromino.children objectAtIndex:1] contentSize].width;
    NSUInteger x = (NSUInteger) (position.x / tileWidth);
    NSUInteger y = (NSUInteger) (((self.contentSize.height) - position.y) / tileWidth);
    return ccp(x, y);
}

- (void)didLoadFromCCB {

}

- (NSMutableArray *)get20x10Array {
    NSMutableArray *arr = [NSMutableArray array];
    for (int i = 0; i < self.Nbx; ++i) {
        NSMutableArray *subarr = [NSMutableArray array];
        for (int j = 0; j < self.Nby; ++j)
            //insert at index??
            [subarr addObject:[NSNumber numberWithInt:0]];
        [arr addObject:subarr];
    }
    return arr;
}

- (BOOL)isBlockAt:(CGPoint)point {

    if (point.x == 20) {
        point.x = 19;
    }
    NSMutableArray *inner = [_array objectAtIndex:(NSUInteger) point.x];

    return [inner objectAtIndex:(NSUInteger) point.y] != [NSNumber numberWithChar:0];
}

- (NSMutableArray *)getAllBlocksInBoard {
    NSMutableArray *blocksInBoard = [NSMutableArray array];
    for (NSUInteger x = 0; x < self.Nbx; x++) {
        for (NSUInteger y = 0; y < self.Nby; y++) {
            Block *block = [self getBlockAt:ccp(x, y)];
            if (block != nil && block.stuck) {
                [blocksInBoard addObject:block];
            }

        }
    }

    return blocksInBoard;
}

- (Block *)getBlockAt:(CGPoint)point {

    NSUInteger x = (NSUInteger) point.x;
    NSUInteger y = (NSUInteger) point.y;

    if ([self isBlockAt:point]) {
        return [[_array objectAtIndex:x] objectAtIndex:y];
    }
    else {
        return nil;
    }
}

- (void)insertBlockAt:(Block *)block at:(CGPoint)point {
    NSUInteger x = (NSUInteger) point.x;
    NSUInteger y = (NSUInteger) point.y;

    [[_array objectAtIndex:x] replaceObjectAtIndex:y withObject:block];
}

- (void)DeleteBlockFromBoard:(NSMutableArray *)blocks {

    for (Block *block in blocks) {
        [[_array objectAtIndex:(NSUInteger) block.boardX] replaceObjectAtIndex:(NSUInteger) block.boardY withObject:[NSNumber numberWithInt:0]];
    }

}

- (void)DeleteBlockFromBoardAndSprite:(NSMutableArray *)blocks {

    for (Block *block in blocks) {
        [[_array objectAtIndex:(NSUInteger) block.boardX] replaceObjectAtIndex:(NSUInteger) block.boardY withObject:[NSNumber numberWithInt:0]];
        [block removeFromParentAndCleanup:YES];
    }

}

- (void)MoveTetromino:(Tetromino *)FromTetromino to:(Tetromino *)ToTetromino {

    //delete
    for (Block *block in FromTetromino.children) {
        [[_array objectAtIndex:block.boardX] replaceObjectAtIndex:block.boardY withObject:[NSNumber numberWithInt:0]];
    }
    //insert
    [self addTetrominoToBoard:ToTetromino.children];

}

- (void)MoveBlock:(Block *)block to:(CGPoint)after {
    NSUInteger x = (NSUInteger) [block boardX];
    NSUInteger y = (NSUInteger) [block boardY];

    //delete
    [[_array objectAtIndex:x] replaceObjectAtIndex:y withObject:[NSNumber numberWithInt:0]];
    //insert
    [self insertBlockAt:block at:after];
}

- (BOOL)boardRowFull:(NSUInteger)y {
    BOOL occupied = NO;
    for (int x = 0; x < [self Nbx]; x++) {

        if (![self isBlockAt:ccp(x, y)]) {
            occupied = NO;
            //Since there's an empty block on this column there's no need to look at the others
            //Exits both loops and get the next row
            break;

        }
        else {
            occupied = YES;
        }
    }
    return occupied;
}

- (NSMutableArray *)DeleteRow:(NSUInteger)y {
    NSMutableArray *blocksWithSpell = [NSMutableArray array];

    for (NSUInteger x = 0; x < _Nbx; x++) {

        Block *block = [self getBlockAt:ccp(x, y)];

        if (block.spell != Nil) {
            [blocksWithSpell addObject:block.spell];
        }

        [block removeFromParentAndCleanup:YES];
        [[_array objectAtIndex:x] replaceObjectAtIndex:y withObject:[NSNumber numberWithInt:0]];

    }

    return blocksWithSpell;

}

- (NSMutableArray *)MoveBoardDown:(NSUInteger)y nbRowsToMoveDownTo:(NSUInteger)step {
    NSMutableArray *blocksToSetPosition = [NSMutableArray array];

    for (y; y > 0; y--) {
        for (NSUInteger x = 0; x < _Nbx; x++) {
            Block *current = [self getBlockAt:ccp(x, y)];
            if (current != nil) {

                [self MoveBlock:current to:ccp(x, y + step)];

                current.boardY = current.boardY + step;

                [blocksToSetPosition addObject:current];

            }
        }
    }
    return blocksToSetPosition;
}

- (void)addTetrominoToBoard:(NSMutableArray *)blocksToAdd {

    for (Block *block in blocksToAdd) {
        [self insertBlockAt:block at:ccp(block.boardX, block.boardY)];
    }

}

- (void)printCurrentBoardStatus:(BOOL)withPosition {
    NSLog(@"--------------------------------------------------------------------");
    for (int j = 0; j < 20; ++j) {
        NSMutableString *row = [NSMutableString string];
        for (int i = 0; i < 10; ++i) {

            if ([self isBlockAt:ccp(i, j)]) {
                if (withPosition) {
                    [row appendFormat:@"(%02d,%02d) ", i, j];
                }
                else {
                    [row appendFormat:@"X "];
                }
            }
            else {
                if (withPosition) {
                    [row appendFormat:@"(  ,  ) "];
                }
                else {
                    [row appendFormat:@"  "];
                }
            }

        }

        NSLog(@"%@", row);

    }
}

//TODO: Use collision detection instead.
- (BOOL)canMoveTetrominoByYTetromino:(Tetromino *)userTetromino offSetY:(NSUInteger)offSetY {

    // Sort blocks by x value if moving left, reverse order if moving right
    NSMutableArray *reversedChildren = [[NSMutableArray alloc] initWithArray:userTetromino.children];
    NSEnumerator *enumerator;

    if (offSetY > 0) {
        enumerator = [reversedChildren reverseObjectEnumerator];
    }

    for (Block *currentBlock in enumerator) {
        //dont compare yourself
        if (!([userTetromino isBlockInTetromino:[self getBlockAt:ccp(currentBlock.boardX, currentBlock.boardY + offSetY)]])) {
            //if there's another block at the position you're looking at, you can't move
            if ([self isBlockAt:ccp(currentBlock.boardX, currentBlock.boardY + offSetY)]) {
                return NO;
            }
        }
    }
    return YES;

}

//TODO: Use collision detection instead.
- (BOOL)canMoveTetrominoByXTetromino:(Tetromino *)userTetromino offSetX:(NSUInteger)offSetX {

    // Sort blocks by x value if moving left, reverse order if moving right
    NSMutableArray *reversedChildren = [[NSMutableArray alloc] initWithArray:userTetromino.children];
    NSEnumerator *enumerator;

    if (offSetX > 0) {
        enumerator = [reversedChildren reverseObjectEnumerator];
    }

    for (Block *currentBlock in enumerator) {
        //dont compare yourself
        if (!([userTetromino isBlockInTetromino:[self getBlockAt:ccp(currentBlock.boardX + offSetX, currentBlock.boardY)]])) {
            //if there's another block at the position you're looking at, you can't move
            if ([self isBlockAt:ccp(currentBlock.boardX + offSetX, currentBlock.boardY)]) {
                return NO;
            }
        }
    }
    return YES;

}

- (BOOL)isTetrominoInBounds:(Tetromino *)tetromino noCollisionWith:(Tetromino *)with {

    for (Block *currentBlock in tetromino.children) {
        //check if the new block is within the bounds and
        if (currentBlock.boardX < 0 || currentBlock.boardX >= [self Nbx]
                || currentBlock.boardY < 0 || currentBlock.boardY >= [self Nby]) {
            NSLog(@"DENIED - OUT OF BOUNDS");
            return NO;

        }

        for (Block *old in with.children) {
            if ([old boardX] != [currentBlock boardX] && ![old boardY] == [currentBlock boardY]) {
                if ([self isBlockAt:ccp(currentBlock.boardX, currentBlock.boardY)]) {
                    NSLog(@"DENIED - COLLISION");
                    return NO;
                }
            }
        }


        //}
    }
    return YES;
}

- (BOOL)boardRowEmpty:(NSUInteger)y {

    return [self boardRowFull:y];

}

- (void)addBlocks:(NSMutableArray *)blocksToAdd {

    [self addTetrominoToBoard:blocksToAdd];

    [self setPositionUsingFieldValue:blocksToAdd];

    for (Block *blocks in blocksToAdd) {
        [self.parent addChild:blocks];
    }

    //[self newTetromino:blocksToAdd];

}

- (void)setPositionUsingFieldValue:(NSMutableArray *)arrayOfBlocks {

    for (Block *block in arrayOfBlocks) {
        NSInteger boardX = [block boardX];
        NSInteger boardY = [block boardY];

        NSInteger x = (NSInteger) (boardX * block.contentSize.width);// + fieldPositionInView.x);
        NSInteger y = (NSInteger) ((-boardY * block.contentSize.height) + self.contentSize.height);// + fieldPositionInView.y);
        [block setPosition:ccp(x, y)];
    }

}

- (void)moveDownOrCreate {
    //Perhaps set all tetromino to stuck by default?
    //[userTetromino getLowestPosition];
    NSUInteger nbLinesCleared = 0;
    if (userTetromino.stuck || userTetromino == NULL) {
        [self createNewTetromino];
    }
    else if (userTetromino.lowestPosition.y != 19 && [self canMoveTetrominoByYTetromino:userTetromino offSetY:1]) {
        [self moveTetrominoDown];
        userTetromino.stuck = NO;
    }
    else {
        userTetromino.stuck = YES;

    }
    //[self printCurrentBoardStatus:NO];

}

- (void)VerifyNewBlockCollision:(Tetromino *)new {

    BOOL collision = NO;

    for (Block *block in new.children) {
        if ([self isBlockAt:ccp(block.boardX, block.boardY)]) {
            collision = YES;
            continue;
        }
    }

    if (collision) {
        [self gameOver:NO];
    }


}

- (NSMutableArray *)checkForRowsToClear {

    NSMutableArray *rowToDelete = [[NSMutableArray alloc] init];
    BOOL occupied = NO;

    NSNumber *deletedRow = (NSNumber *) nil;
    for (NSUInteger y = 0; y < [self Nby]; y++) {

        //Skip row already processed

        if (y == (NSUInteger) deletedRow) {
            continue;
        }

        for (int x = 0; x < [self Nbx]; x++) {

            if (![self isBlockAt:ccp(x, y)]) {
                occupied = NO;
                //Since there's an empty block on this column there's no need to look at the others
                //Exits both loops and get the next row
                break;

            }
            else {
                occupied = YES;
            }
        }

        if (occupied) {

            deletedRow = [NSNumber numberWithUnsignedInteger:y];

            [rowToDelete addObject:deletedRow];

        }
        else {
            continue;
        }
    }

    return rowToDelete;

}

- (NSMutableArray *)deleteRowsAndReturnSpells:(NSMutableArray *)rowsToDelete {
    NSMutableArray *spellsToAdd = [[NSMutableArray alloc] init];

    NSNumber *highestRow = [NSNumber numberWithInt:99];
    for (NSNumber *row in rowsToDelete) {
        [spellsToAdd addObjectsFromArray:[self DeleteRow:[row unsignedIntegerValue]]];

        if (highestRow.integerValue > row.integerValue) {
            highestRow = row;
        }

    }

    [self setPositionUsingFieldValue:[self MoveBoardDown:([highestRow unsignedIntegerValue] - 1) nbRowsToMoveDownTo:rowsToDelete.count]];


    //put it here or else it gets the bocks not yet deleted.
    [self addSpellToField];

    return spellsToAdd;
}

- (void)gameOver:(BOOL)won {
    /*
    CCScene *gameOverScene = [GameOverLayer sceneWithWon:won];
    [[CCDirector sharedDirector] replaceScene:gameOverScene];
    */
}

- (void)createNewTetromino {

    //Tetromino *tempTetromino = [Tetromino randomBlockUsingBlockFrequency:_isMain ];
    Tetromino *tempTetromino = (Tetromino *) [CCBReader load:@"Shapes/I"];

    [self VerifyNewBlockCollision:tempTetromino];

    [self addTetrominoToBoard:tempTetromino.children];

    [self setPositionUsingFieldValue:tempTetromino.children];

    [self addChild:tempTetromino];

    userTetromino = tempTetromino;

}

- (void)moveTetrominoDown {

    [self DeleteBlockFromBoard:userTetromino.children];

    [userTetromino moveTetrominoDown];

    [self UpdatesNewTetromino:userTetromino];

}

- (void)UpdatesNewTetromino:(Tetromino *)ToTetromino {
    [self setPositionUsingFieldValue:ToTetromino.children];

    [self addTetrominoToBoard:ToTetromino.children];

}

- (void)moveTetrominoLeft {

    if (userTetromino.leftMostPosition.x > 0 && !userTetromino.stuck) {
        if ([self canMoveTetrominoByXTetromino:userTetromino offSetX:-1]) {

            [self DeleteBlockFromBoard:userTetromino.children];

            [userTetromino moveTetrominoInDirection:moveLeft];

            [self UpdatesNewTetromino:userTetromino];

        }
    }


}

- (void)moveTetrominoRight {
    if (userTetromino.rightMostPosition.x < kLastColumn && !userTetromino.stuck) {
        if ([self canMoveTetrominoByXTetromino:userTetromino offSetX:1]) {
            [self DeleteBlockFromBoard:userTetromino.children];

            [userTetromino moveTetrominoInDirection:moveRight];

            [self UpdatesNewTetromino:userTetromino];

        }
    }
}

- (void)rotateTetromino:(RotationDirection)direction {

    Tetromino *rotated = [Tetromino rotateTetromino:userTetromino in:direction];

    if ([self isTetrominoInBounds:rotated noCollisionWith:userTetromino]) {
        [self DeleteBlockFromBoard:userTetromino.children];

        [userTetromino MoveBoardPosition:rotated];
        [userTetromino setOrientation:rotated.orientation];

        [self UpdatesNewTetromino:userTetromino];

    }
}

@end