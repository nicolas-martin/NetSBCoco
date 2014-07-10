//
// Created by Nicolas Martin on 2014-07-08.
// Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Field.h"
#import "Inventory.h"
#import "Board.h"
#import "IBlock.h"


@implementation Field {
    Inventory *_inventory;
    Board *_board;

}

- (void)didLoadFromCCB {
    NSLog(@"Field loaded");
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
    CCArray *reversedChildren = [[CCArray alloc] initWithArray:userTetromino.children];

    if (offSetY > 0) {
        [reversedChildren reverseObjects];
    }

    for (id<IBlock> currentBlock in reversedChildren) {
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
    CCArray *reversedChildren = [[CCArray alloc] initWithArray:userTetromino.children];

    if (offSetX > 0) {
        [reversedChildren reverseObjects];
    }

    for (id<IBlock> currentBlock in reversedChildren) {
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

    for (id<IBlock> currentBlock in tetromino.children) {
        //check if the new block is within the bounds and
        if (currentBlock.boardX < 0 || currentBlock.boardX >= [self.board Nbx]
                || currentBlock.boardY < 0 || currentBlock.boardY >= [self.board Nby]) {
            NSLog(@"DENIED - OUT OF BOUNDS");
            return NO;

        }

        for (id<IBlock> old in with.children) {
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

    [self.board addTetrominoToBoard:blocksToAdd];

    [self setPositionUsingFieldValue:blocksToAdd];

    for (id<IBlock> blocks in blocksToAdd)
    {
        [self addChild:blocks];
    }

    //[self newTetromino:blocksToAdd];

}

- (void)setPositionUsingFieldValue:(NSMutableArray *) arrayOfBlocks
{
    //CGPoint fieldPositionInView = [self position];

    for (id<IBlock> block in arrayOfBlocks)
    {
        NSInteger boardX = [block boardX];
        NSInteger boardY = [block boardY];
        NSInteger boardYTimeSize = boardY * _TileSize;

        NSInteger x = (boardX * _TileSize);// + fieldPositionInView.x);
        NSInteger y = (-boardYTimeSize + _Height);// + fieldPositionInView.y);
        [block setPosition:ccp(x, y)];
    }

}



@end