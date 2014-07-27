//
// Created by Nicolas Martin on 2014-07-09.
// Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Gravity.h"
#import "Field.h"
#import "Board.h"
#import "Block.h"


@implementation Gravity {
    NSString *spellName;
}

- (id)init {
    self = [super init];
    if (self) {
        spellName = @"Gravity";
        self.spriteFrame = [CCSpriteFrame frameWithImageNamed: @"Assets/Gravity.png"];
    }

    return self;
}

- (void)CastSpell:(Board *)targetBoard {
    NSEnumerator *enumerator;
    NSMutableArray *blocksToSetPosition = [NSMutableArray array];

    enumerator = [targetBoard.getAllBlocksInBoard reverseObjectEnumerator];

    for(Block *block in enumerator)
    {
        while(block.boardY+1 < 20 && ![targetBoard isBlockAt:ccp(block.boardX, block.boardY+1)]) {

//            NSLog(@"Moving block from (%d, %d) to (%d, %d)", block.boardX, block.boardY,block.boardX,block.boardY+1);
            [targetBoard MoveBlock:block to:ccp(block.boardX, block.boardY+1)];

            [block moveDown];

        }

        [blocksToSetPosition addObject:block];
    }

    [targetBoard setPositionUsingFieldValue:blocksToSetPosition];

    [self LogSpell:targetBoard];
}

- (NSString *)LogSpell:(Board *)targetBoard {
    //return [NSString stringWithFormat:@"%@ was casted on %@", _spellName, targetField.Name];
    return @"hegy";
}


@end