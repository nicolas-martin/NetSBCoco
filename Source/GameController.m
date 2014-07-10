//
// Created by Nicolas Martin on 2014-07-09.
// Copyright (c) 2014 Apportable. All rights reserved.
//

#import "GameController.h"
#import "IBlock.h"


@implementation GameController {

}

- (void)moveDownOrCreate {
    //Perhaps set all tetromino to stuck by default?
    //[userTetromino getLowestPosition];
    if(userTetromino.stuck || userTetromino == NULL)
    {
        [self createNewTetromino];
    }
    else if(userTetromino.lowestPosition.y != 19 && [self.field canMoveTetrominoByYTetromino:userTetromino offSetY:1])
    {
        [self moveTetrominoDown];
        userTetromino.stuck = NO;
    }
    else
    {
        userTetromino.stuck = YES;

        if([_field.Name isEqual:@"MainField"])
        {
            [_field.board printCurrentBoardStatus:YES];
        }

        NSUInteger nbLinesCleared = [self checkForRowsToClear:userTetromino.children];
        if(nbLinesCleared > 0)
        {
            self.numRowCleared + nbLinesCleared;
            [_hudLayer numRowClearedChanged:_numRowCleared];
            [_field addSpellToField];
        }
    }
}

- (void)VerifyNewBlockCollision:(Tetromino *)new{

    BOOL collision = NO;

    for (id<IBlock> block in new.children)
    {
        if ([self.field.board isBlockAt:ccp(block.boardX, block.boardY)])
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
    for (id<IBlock> block in blocksToCheck) {

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
                [self addSpellsToInventory:spellsToAdd];
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

-(void) addSpellsToInventory:(NSMutableArray *)spellsToAdd{
    for (id <ICastable> spell in spellsToAdd)
    {
        [_inventory addSpell:spell];
    }
}

- (void)gameOver:(BOOL)won{
    /*
    CCScene *gameOverScene = [GameOverLayer sceneWithWon:won];
    [[CCDirector sharedDirector] replaceScene:gameOverScene];
    */
}

- (void)createNewTetromino {

    Tetromino *tempTetromino = [Tetromino randomBlockUsingBlockFrequency:_isMain ];

    [self VerifyNewBlockCollision:tempTetromino];

    [self.field.board addTetrominoToBoard:tempTetromino.children];

    [self.field setPositionUsingFieldValue:tempTetromino.children];

    [self.field addChild:tempTetromino];

    [self newTetromino:tempTetromino];

    userTetromino = tempTetromino;

}

- (void)moveTetrominoDown{

    [self.field.board DeleteBlockFromBoard:userTetromino.children];

    [userTetromino moveTetrominoDown];

    [self UpdatesNewTetromino:userTetromino];
}

- (void)moveTetrominoLeft{

    if ([self.field canMoveTetrominoByXTetromino:userTetromino offSetX:-1])
    {

        [self.field.board DeleteBlockFromBoard:userTetromino.children];

        [userTetromino moveTetrominoInDirection:userTetromino inDirection:moveLeft];

        [self UpdatesNewTetromino:userTetromino];

    }
}

- (void)moveTetrominoRight{

    if ([self.field canMoveTetrominoByXTetromino:userTetromino offSetX:1])
    {
        [self.field.board DeleteBlockFromBoard:userTetromino.children];

        [userTetromino moveTetrominoInDirection:userTetromino inDirection:moveRight];

        [self UpdatesNewTetromino:userTetromino];

    }
}

- (void)rotateTetromino:(RotationDirection)direction {

    Tetromino *rotated = [Tetromino rotateTetromino:userTetromino in:direction];

    if([self.field isTetrominoInBounds:rotated noCollisionWith:userTetromino])
    {
        [self.field.board DeleteBlockFromBoard:userTetromino.children];

        [userTetromino MoveBoardPosition:rotated];
        [userTetromino setOrientation:rotated.orientation];

        [self UpdatesNewTetromino:userTetromino];


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