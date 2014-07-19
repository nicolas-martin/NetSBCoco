//
// Created by Nicolas Martin on 2014-07-08.
// Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Field.h"
#import "Inventory.h"
#import "Board.h"
#import "Tetromino.h"
#import "Block.h"


@implementation Field {
    Inventory *_inventory;
    Board *_board;
    Tetromino *userTetromino;

}

- (void)didLoadFromCCB {

}

- (void) addSpellToField
{
    /*
    NSMutableArray *allBlocksInBoard = [_board getAllBlocksInBoard];
    NSUInteger nbBlocksInBoard = allBlocksInBoard.count;
    NSUInteger nbSpellToAdd = 0;

    for (NSUInteger i = 0; i < nbBlocksInBoard; i++)
    {
        if([self randomBoolWithPercentage:55])
        {
            nbSpellToAdd++;
        }
    }

    for (NSUInteger i = 0; i < nbSpellToAdd; i++)
    {
        NSUInteger posOfSpell = arc4random() % nbBlocksInBoard;
        id<IBlock> block = [allBlocksInBoard objectAtIndex:posOfSpell];
        if (block.spell == nil)
        {
            [block addSpellToBlock:[SpellFactory getSpellUsingFrequency]];
        }
    }*/
}

- (BOOL)canMoveTetrominoByYTetromino:(Tetromino *)userTetromino offSetY:(NSUInteger)offSetY
{

    // Sort blocks by x value if moving left, reverse order if moving right
    NSMutableArray *reversedChildren = [[NSMutableArray alloc] initWithArray:userTetromino.children];
    NSEnumerator *enumerator;

    if (offSetY > 0) {
        enumerator = [reversedChildren reverseObjectEnumerator];
    }

    for (Block * currentBlock in enumerator) {
        //dont compare yourself
        if (!([userTetromino isBlockInTetromino:[_board getBlockAt:ccp(currentBlock.boardX, currentBlock.boardY + offSetY)]])) {
            //if there's another block at the position you're looking at, you can't move
            if ([_board isBlockAt:ccp(currentBlock.boardX, currentBlock.boardY + offSetY)]) {
                return NO;
            }
        }
    }
    return YES;

}


- (BOOL)canMoveTetrominoByXTetromino:(Tetromino *)userTetromino offSetX:(NSUInteger)offSetX
{

    // Sort blocks by x value if moving left, reverse order if moving right
    NSMutableArray *reversedChildren = [[NSMutableArray alloc] initWithArray:userTetromino.children];
    NSEnumerator *enumerator;

    if (offSetX > 0) {
        enumerator = [reversedChildren reverseObjectEnumerator];
    }

    for (Block * currentBlock in enumerator) {
        //dont compare yourself
        if (!([userTetromino isBlockInTetromino:[_board getBlockAt:ccp(currentBlock.boardX + offSetX, currentBlock.boardY)]])) {
            //if there's another block at the position you're looking at, you can't move
            if ([_board isBlockAt:ccp(currentBlock.boardX + offSetX, currentBlock.boardY)]) {
                return NO;
            }
        }
    }
    return YES;

}

- (BOOL)isTetrominoInBounds:(Tetromino *)tetromino noCollisionWith:(Tetromino *)with
{

    for (Block * currentBlock in tetromino.children) {
        //check if the new block is within the bounds and
        if (currentBlock.boardX < 0 || currentBlock.boardX >= [_board Nbx]
                || currentBlock.boardY < 0 || currentBlock.boardY >= [_board Nby]) {
            NSLog(@"DENIED - OUT OF BOUNDS");
            return NO;

        }

        for (Block * old in with.children) {
            if (!([old boardX] == [currentBlock boardX]) && ![old boardY] == [currentBlock boardY]) {
                if ([_board isBlockAt:ccp(currentBlock.boardX, currentBlock.boardY)]) {
                    NSLog(@"DENIED - COLLISION");
                    return NO;
                }
            }
        }


        //}
    }
    return YES;
}

- (BOOL)boardRowEmpty:(NSUInteger)y
{

    return [_board boardRowFull:y];

}

- (void)addBlocks:(NSMutableArray *)blocksToAdd
{

    [_board addTetrominoToBoard:blocksToAdd];

    [self setPositionUsingFieldValue:blocksToAdd];

    for (Block *blocks in blocksToAdd)
    {
        [self addChild:blocks];
    }

    //[self newTetromino:blocksToAdd];

}

- (void)setPositionUsingFieldValue:(NSMutableArray *) arrayOfBlocks
{

    for (Block * block in arrayOfBlocks)
    {
        NSInteger boardX = [block boardX];
        NSInteger boardY = [block boardY];
//        NSInteger boardYTimeSize = (NSInteger) (boardY * block.contentSize.height);
//
//        NSInteger x = (boardX * (NSInteger) (boardY * block.contentSize.width));// + fieldPositionInView.x);
//        NSInteger y = (NSInteger) (-boardYTimeSize + self.contentSize.height);// + fieldPositionInView.y);
        NSInteger x = (NSInteger) (boardX * block.contentSize.width);// + fieldPositionInView.x);
        NSInteger y = (NSInteger) ((-boardY * block.contentSize.height)+ _board.contentSize.height);// + fieldPositionInView.y);
        [block setPosition:ccp(x, y)];
    }

}
- (void)moveDownOrCreate {
    //Perhaps set all tetromino to stuck by default?
    //[userTetromino getLowestPosition];
    if(userTetromino.stuck || userTetromino == NULL)
    {
        [self createNewTetromino];
    }
    else if(userTetromino.lowestPosition.y != 19 && [self canMoveTetrominoByYTetromino:userTetromino offSetY:1])
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
            [self addSpellToField];
        }
    }
    [_board printCurrentBoardStatus:NO];
}

- (void)VerifyNewBlockCollision:(Tetromino *)new{

    BOOL collision = NO;

    for (Block * block in new.children)
    {
        if ([_board isBlockAt:ccp(block.boardX, block.boardY)])
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

        for (int x = 0; x < [_board Nbx]; x++) {

            if (![_board isBlockAt:ccp(x, block.boardY)]) {
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

            NSMutableArray *spellsToAdd = [_board DeleteRow:(NSUInteger)deletedRow];
            if(spellsToAdd.count > 0)
            {
                //[self addSpellsToInventory:spellsToAdd];
            }

            [self setPositionUsingFieldValue:[_board MoveBoardDown:(NSUInteger) (deletedRow - 1)]];
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

    //Tetromino *tempTetromino = [Tetromino randomBlockUsingBlockFrequency:_isMain ];
    Tetromino *tempTetromino = (Tetromino *) [CCBReader load:@"Shapes/Square"];

    [self VerifyNewBlockCollision:tempTetromino];

    [_board addTetrominoToBoard:tempTetromino.children];

    [self setPositionUsingFieldValue:tempTetromino.children];

    [self addChild:tempTetromino];

    userTetromino = tempTetromino;

}

- (void)moveTetrominoDown{

    [_board DeleteBlockFromBoard:userTetromino.children];

    [userTetromino moveTetrominoDown];

    [self UpdatesNewTetromino:userTetromino];

}

-(void)UpdatesNewTetromino:(Tetromino*) ToTetromino
{
    [self setPositionUsingFieldValue:ToTetromino.children];

    [_board addTetrominoToBoard:ToTetromino.children];

}


- (void)moveTetrominoLeft{

    if ([self canMoveTetrominoByXTetromino:userTetromino offSetX:-1])
    {

        [_board DeleteBlockFromBoard:userTetromino.children];

        [userTetromino moveTetrominoInDirection:userTetromino inDirection:moveLeft];

        [self UpdatesNewTetromino:userTetromino];

    }


}

- (void)moveTetrominoRight{

    if ([self canMoveTetrominoByXTetromino:userTetromino offSetX:1])
    {
        [_board DeleteBlockFromBoard:userTetromino.children];

        [userTetromino moveTetrominoInDirection:userTetromino inDirection:moveRight];

        [self UpdatesNewTetromino:userTetromino];

    }
}

- (void)rotateTetromino:(RotationDirection)direction {

    Tetromino *rotated = [Tetromino rotateTetromino:userTetromino in:direction];

    if([self isTetrominoInBounds:rotated noCollisionWith:userTetromino])
    {
        [_board DeleteBlockFromBoard:userTetromino.children];

        [userTetromino MoveBoardPosition:rotated];
        [userTetromino setOrientation:rotated.orientation];

        [self UpdatesNewTetromino:userTetromino];

    }
}


@end