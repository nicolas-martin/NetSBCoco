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

- (void) addSpellToField{
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

- (void)moveDownOrCreate {

    if(_board.moveDownOrCreate > 0)
    {
//            self.numRowCleared + nbLinesCleared;
//            [_hudLayer numRowClearedChanged:_numRowCleared];
        [self addSpellToField];
    }
}


@end