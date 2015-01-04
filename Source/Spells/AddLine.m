//
// Created by Nicolas Martin on 2014-07-09.
// Copyright (c) 2014 Apportable. All rights reserved.
//

#import "AddLine.h"
#import "Board.h"
#import "Block.h"
#import "Field.h"
#import "SpellFactory.h"


@implementation AddLine {

    NSString *spellName;
}

- (id)init {
    self = [super init];
    if (self) {
        self.spellType = kAddLine;
        self.spellName = [SpellFactory getNameFromEnum:self.spellType];
        self.spriteFrame = [CCSpriteFrame frameWithImageNamed:[SpellFactory getFileNameFromEnum:self.spellType]];
        

    }

    return self;
}

- (void)CastSpell:(Board *)targetBoard Sender:(Field *)senderField {
    NSMutableArray *blocksToSetPosition = [NSMutableArray array];

    for (NSUInteger y = 0; y < Nby; y++) {
        for (NSUInteger x = 0; x < Nbx; x++) {

            Block *current = [targetBoard getBlockAt:ccp(x, y)];

            if (current != nil && current.stuck) {
                [targetBoard MoveBlock:current to:ccp(x, y - 1)];

                [current moveUp];

                [blocksToSetPosition addObject:current];
            }
        }
    }

    [targetBoard setPositionUsingFieldValue:blocksToSetPosition];

    NSMutableArray *line = [self CreateBlockLine:targetBoard];
    [targetBoard addBlocks:line];

    NSDictionary* dict = @{@"Blocks" : line, @"Target": @(((Field *) targetBoard.parent).Idx)};
    [[NSNotificationCenter defaultCenter] postNotificationName:BlocksToAdd object:nil userInfo:dict];

}

- (NSMutableArray *)CreateBlockLine:(Board *)targetBoard {
    NSMutableArray *bArray = [NSMutableArray array];

    for (NSUInteger x = 0; x < Nbx; x++) {
        NSUInteger random = arc4random();

        if ((random % 3) > 0) {
            Block *block = [Block CreateRandomBlock];
            block.stuck = YES;
            [block setBoardX:x];
            [block setBoardY:Nby-1];

            [bArray addObject:block];
        }

    }
    return bArray;



}

@end