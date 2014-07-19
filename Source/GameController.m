//
// Created by Nicolas Martin on 2014-07-09.
// Copyright (c) 2014 Apportable. All rights reserved.
//

#import "GameController.h"
#import "Tetromino.h"
#import "Block.h"
#import "Field.h"


@implementation GameController {
    Field *_field;
    Tetromino *userTetromino;
}
- (instancetype)initWithField:(Field *)field {
    self = [super init];
    if (self) {
        _field = field;
        Tetromino *square = (Tetromino *) [CCBReader load:@"Shapes/Square"];
        [_field addChild:square];
    }

    return self;
}

+ (instancetype)controllerWithField:(Field *)field {
    return [[self alloc] initWithField:field];
}

- (void)moveDownOrCreate {
    //Perhaps set all tetromino to stuck by default?
    //[userTetromino getLowestPosition];
    if(userTetromino.stuck || userTetromino == NULL)
    {
        [self createNewTetromino];
    }
    else if(userTetromino.lowestPosition.y != 19 && [_field canMoveTetrominoByYTetromino:userTetromino offSetY:1])
    {
        [self moveTetrominoDown];
        userTetromino.stuck = NO;
    }
    else
    {
        userTetromino.stuck = YES;

        NSUInteger nbLinesCleared = [self checkForRowsToClear:userTetromino.children];
        if(nbLinesCleared > 0)
        {
//            self.numRowCleared + nbLinesCleared;
//            [_hudLayer numRowClearedChanged:_numRowCleared];
            [_field addSpellToField];
        }
    }
}

- (void)VerifyNewBlockCollision:(Tetromino *)new{

    BOOL collision = NO;

    for (Block * block in new.children)
    {
        if ([_field.board isBlockAt:ccp(block.boardX, block.boardY)])
        {
            collision = YES;
            continue;
        }
    }

    if (collision)
    {
        [self gameOver:NO];
    }


}

- (NSUInteger)checkForRowsToClear:(NSMutableArray *)blocksToCheck {

    BOOL occupied = NO;
    NSUInteger nbLinesToDelete = 0;

    NSUInteger deletedRow = (NSUInteger) nil;
    for (Block *block in blocksToCheck) {

        //Skip row already processed
        if ([block boardY] == (NSUInteger) deletedRow) {
            continue;
        }

        for (int x = 0; x < [_field.board Nbx]; x++) {

            if (![_field.board isBlockAt:ccp(x, block.boardY)]) {
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

            deletedRow = [block boardY];

            NSMutableArray *spellsToAdd = [_field.board DeleteRow:(NSUInteger)deletedRow];
            if(spellsToAdd.count > 0)
            {
                //[self addSpellsToInventory:spellsToAdd];
            }

            [_field setPositionUsingFieldValue:[_field.board MoveBoardDown:(NSUInteger) (deletedRow - 1)]];
            nbLinesToDelete++;

        }
        else {
            continue;
        }
    }
    return nbLinesToDelete;

}

//-(void) addSpellsToInventory:(NSMutableArray *)spellsToAdd{
//    for (id <ICastable> spell in spellsToAdd)
//    {
//        [_inventory addSpell:spell];
//    }
//}

- (void)gameOver:(BOOL)won{
    /*
    CCScene *gameOverScene = [GameOverLayer sceneWithWon:won];
    [[CCDirector sharedDirector] replaceScene:gameOverScene];
    */
}

- (void)createNewTetromino {

    Tetromino *tempTetromino = [Tetromino randomBlockUsingBlockFrequency:_isMain ];

    [self VerifyNewBlockCollision:tempTetromino];

    [_field.board addTetrominoToBoard:tempTetromino.children];

    [_field setPositionUsingFieldValue:tempTetromino.children];

    [_field addChild:tempTetromino];

    userTetromino = tempTetromino;

}

- (void)moveTetrominoDown{

    [_field.board DeleteBlockFromBoard:userTetromino.children];

    [userTetromino moveTetrominoDown];

}

- (void)moveTetrominoLeft{

    if ([_field canMoveTetrominoByXTetromino:userTetromino offSetX:-1])
    {

        [_field.board DeleteBlockFromBoard:userTetromino.children];

        [userTetromino moveTetrominoInDirection:userTetromino inDirection:moveLeft];

    }
}

- (void)moveTetrominoRight{

    if ([_field canMoveTetrominoByXTetromino:userTetromino offSetX:1])
    {
        [_field.board DeleteBlockFromBoard:userTetromino.children];

        [userTetromino moveTetrominoInDirection:userTetromino inDirection:moveRight];

    }
}

- (void)rotateTetromino:(RotationDirection)direction {

    Tetromino *rotated = [Tetromino rotateTetromino:userTetromino in:direction];

    if([_field isTetrominoInBounds:rotated noCollisionWith:userTetromino])
    {
        [_field.board DeleteBlockFromBoard:userTetromino.children];

        [userTetromino MoveBoardPosition:rotated];
        [userTetromino setOrientation:rotated.orientation];

    }
}
/*
- (void)viewTap:(CGPoint)location {

    CGFloat leftMostX = 0;
    CGFloat rightMostX = 0;
    CGFloat lowestY = 0;
    CGFloat highestY = 0;

    //compute
    leftMostX = [userTetromino leftMostPosition].x;
    rightMostX = [userTetromino rightMostPosition].x;
    lowestY = [userTetromino lowestPosition].y;
    highestY = [userTetromino highestPosition].y;

    if (location.y > lowestY)
    {
        touchType = kDropBlocks;
    }

    else if (location.x < leftMostX)
    {
        touchType = kMoveLeft;
    }
    else if (location.x > rightMostX)
    {
        touchType = kMoveRight;
    }

    [self processTaps];
}

- (void)processTaps{
    if (touchType == kDropBlocks)
    {
        touchType = kNone;

        while (!userTetromino.stuck)
        {
            [self moveDownOrCreate];
        }
    }
    else if (touchType == kMoveLeft)
    {
        touchType = kNone;

        if (userTetromino.leftMostPosition.x > 0 && !userTetromino.stuck)
        {
            [self moveTetrominoLeft];
        }
    }
    else if (touchType == kMoveRight)
    {
        touchType = kNone;

        if (userTetromino.rightMostPosition.x < kLastColumn && !userTetromino.stuck)
        {
            [self moveTetrominoRight];
        }
    }

}
*/
@end