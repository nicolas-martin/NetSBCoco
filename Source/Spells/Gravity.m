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
    NSMutableDictionary* blockAndStep = [NSMutableDictionary dictionary];

    enumerator = [targetBoard.getAllBlocksInBoard reverseObjectEnumerator];

    for (Block *block in enumerator) {
        int ySteps = 0;
        while (block.boardY + ySteps < Nby - 1 && ![targetBoard isBlockAt:ccp(block.boardX, block.boardY + ySteps+1)]) {

            ySteps++;

        }

        if(ySteps > 0){
            [blockAndStep setValue:@(ySteps) forKey:NSStringFromCGPoint(ccp(block.boardX, block.boardY))];
            [targetBoard MoveBlock:block to:ccp(0, ySteps)];
            [blocksToSetPosition addObject:block];
        }

    }

    NSDictionary* dict = @{@"Blocks" : blockAndStep, @"Target": @(((Field *) targetBoard.parent).Idx)};
    [[NSNotificationCenter defaultCenter] postNotificationName:BlocksToMove object:nil userInfo:dict];

    [targetBoard setPositionUsingFieldValue:blocksToSetPosition];

}


@end