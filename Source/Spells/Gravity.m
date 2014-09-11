//
// Created by Nicolas Martin on 2014-07-09.
// Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Gravity.h"
#import "Field.h"
#import "Board.h"
#import "Block.h"
#import "SpellFactory.h"


@implementation Gravity {
    NSString *spellName;
}

- (id)init {
    self = [super init];
    if (self) {
        self.spellType = kGravity;
        self.spellName = [SpellFactory getNameFromEnum:self.spellType];
        self.spriteFrame = [CCSpriteFrame frameWithImageNamed:[SpellFactory getFileNameFromEnum:self.spellType]];
    }

    return self;
}

- (void)CastSpell:(Board *)targetBoard Sender:(Field *)senderField {
    NSEnumerator *enumerator;
    NSMutableArray *blocksToSetPosition = [NSMutableArray array];

    enumerator = [targetBoard.getAllBlocksInBoard reverseObjectEnumerator];

    for (Block *block in enumerator) {
        while (block.boardY + 1 < targetBoard.Nbx && ![targetBoard isBlockAt:ccp(block.boardX, block.boardY + 1)]) {

            [targetBoard MoveBlock:block to:ccp(block.boardX, block.boardY + 1)];

            [block moveDown];

        }

        [blocksToSetPosition addObject:block];
    }

    [targetBoard setPositionUsingFieldValue:blocksToSetPosition];

}


@end