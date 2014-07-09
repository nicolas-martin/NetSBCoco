//
// Created by Nicolas Martin on 2014-07-09.
// Copyright (c) 2014 Apportable. All rights reserved.
//

#import "AddLine.h"
#import "Field.h"
#import "Board.h"


@implementation AddLine {

    NSString *_spellName;
}

- (id)init {
    self = [super init];
    if (self) {
        _spellName = @"Add line";

    }

    return self;
}


- (void)CreateBlockLine:(Field *)targetField {
    NSMutableArray *bArray = [NSMutableArray array];

    for (NSUInteger x = 0; x < targetField.board.Nbx; x++) {
        NSUInteger random = arc4random();

        if ((random % 3) > 0)
        {
            Block *block = [Block blockWithBlockType:random % 7 displayOnMainField:NO ];
            block.stuck = YES;
            [block setBoardX:x];
            [block setBoardY:19];

            [bArray addObject:block];
        }

    }

    [targetField addBlocks:bArray];
}

//TODO: Bug when adding a line and it collides with a falling block
- (void)CastSpell:(Field *)targetField {
    Board *board = targetField.board;

    NSMutableArray *blocksToSetPosition = [NSMutableArray array];

    for (NSUInteger y = 0; y < board.Nby; y++) {
        for (NSUInteger x = 0; x < board.Nbx; x++) {

            Block *current = [board getBlockAt:ccp(x, y)];

            if (current != nil && current.stuck) {
                [board MoveBlock:current to:ccp(x, y - 1)];

                [current moveUp];

                [blocksToSetPosition addObject:current];
            }
        }
    }

    [targetField setPositionUsingFieldValue:blocksToSetPosition];

    [self CreateBlockLine:targetField ];

    [self LogSpell:targetField];

}

- (NSString *)LogSpell:(Field *)targetField {
    return [NSString stringWithFormat:@"%@ was casted on %@", _spellName, targetField.Name];
}

@end