//
// Created by Nicolas Martin on 2014-08-31.
// Copyright (c) 2014 hero. All rights reserved.
//

#import <MacTypes.h>
#import "ClearSpecial.h"
#import "Board.h"
#import "Field.h"
#import "Block.h"
#import "SpellFactory.h"


@implementation ClearSpecial {
    NSString *spellName;

}

- (id)init {
    self = [super init];
    if (self) {
        self.spellType = kClearSpecial;
        self.spellName = [SpellFactory getNameFromEnum:self.spellType];
        self.spriteFrame = [CCSpriteFrame frameWithImageNamed:[SpellFactory getFileNameFromEnum:self.spellType]];
    }

    return self;
}
- (void)CastSpell:(Board *)targetBoard Sender:(Field *)senderField {
    NSMutableArray *newSpells = [NSMutableArray array];
    NSMutableArray *allBlocksInBoard = [targetBoard getAllBlocksInBoard];
    int nbSpells = 0;

    for (Block *block in allBlocksInBoard){
        if (block.spell != nil){
            [block removeSpell];
            [newSpells addObject:block];
            nbSpells++;
        }
    }


    NSDictionary* dict = @{@"Blocks" : newSpells, @"Target": @(((Field *) targetBoard.parent).Idx)};
    [[NSNotificationCenter defaultCenter] postNotificationName:SpellsToAdd object:nil userInfo:dict];

}

@end