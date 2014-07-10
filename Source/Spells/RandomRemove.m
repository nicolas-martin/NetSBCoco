//
// Created by Nicolas Martin on 2014-07-09.
// Copyright (c) 2014 Apportable. All rights reserved.
//

#import "RandomRemove.h"
#import "Field.h"
#import "Board.h"


@implementation RandomRemove {
    NSString *_spellName;

}

- (id)init {
    self = [super init];
    if (self) {
        _spellName = @"Random Remove";

    }

    return self;
}

/*
- (void)CastSpell:(Field *)targetField {
    Board *board = targetField.board;
    NSMutableArray *allBlockInBoard = [board getAllBlocksInBoard];
    NSMutableArray *blocksToDelete = [NSMutableArray array];

    NSUInteger nbBlockInBoard = allBlockInBoard.count;

    //Removes 20% of all the blocks

    NSUInteger nbBlocksToRemove = (NSUInteger )(nbBlockInBoard / 20);

    for (NSUInteger i = 0; i < nbBlocksToRemove; i++)
    {
        NSUInteger random = arc4random() % nbBlockInBoard;

        Block *block = [allBlockInBoard objectAtIndex:random];

        if (block)
        {
            [blocksToDelete addObject:block];
        }

    }


    [board DeleteBlockFromBoardAndSprite:blocksToDelete];

}

- (NSString *)LogSpell:(Field *)targetField {
    return [NSString stringWithFormat:@"%@ was casted on %@", _spellName, targetField.Name];
}
*/
@end