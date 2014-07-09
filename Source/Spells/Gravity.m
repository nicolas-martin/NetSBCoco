//
// Created by Nicolas Martin on 2014-07-09.
// Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Gravity.h"
#import "Field.h"
#import "Board.h"


@implementation Gravity {
    NSString *_spellName;

}

- (id)init {
    self = [super init];
    if (self) {
        _spellName = @"Gravity";
    }

    return self;
}


- (void)CastSpell:(Field *)targetField {
    NSEnumerator *enumerator;
    NSMutableArray *blocksToSetPosition = [NSMutableArray array];

    Board *board = targetField.board;

    enumerator = [board.getAllBlocksInBoard reverseObjectEnumerator];

    for(Block *block in enumerator)
    {
        while(block.boardY+1 < 20 && ![board isBlockAt:ccp(block.boardX, block.boardY+1)]) {

//            NSLog(@"Moving block from (%d, %d) to (%d, %d)", block.boardX, block.boardY,block.boardX,block.boardY+1);
            [board MoveBlock:block to:ccp(block.boardX, block.boardY+1)];

            [block moveDown];

        }

        [blocksToSetPosition addObject:block];
    }

    [targetField setPositionUsingFieldValue:blocksToSetPosition];

    [self LogSpell:targetField];


}


- (NSString *)LogSpell:(Field *)targetField {
    return [NSString stringWithFormat:@"%@ was casted on %@", _spellName, targetField.Name];
}

@end