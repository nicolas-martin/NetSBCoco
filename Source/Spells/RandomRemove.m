//
// Created by Nicolas Martin on 2014-07-09.
// Copyright (c) 2014 Apportable. All rights reserved.
//

#import "RandomRemove.h"
#import "Board.h"
#import "Field.h"
#import "SpellFactory.h"


@implementation RandomRemove {
    NSString *spellName;
}

- (id)init {
    self = [super init];
    if (self) {
        self.spellType = kRandomRemove;
        self.spellName = [SpellFactory getNameFromEnum:self.spellType];
        self.spriteFrame = [CCSpriteFrame frameWithImageNamed:[SpellFactory getFileNameFromEnum:self.spellType]];

    }

    return self;
}


- (void)CastSpell:(Board *)targetBoard Sender:(Field *)senderField {
    NSMutableArray *allBlockInBoard = [targetBoard getAllBlocksInBoard];
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


    [targetBoard DeleteBlockFromBoardAndSprite:blocksToDelete];

}


@end