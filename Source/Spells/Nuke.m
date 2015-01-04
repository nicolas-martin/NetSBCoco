//
// Created by Nicolas Martin on 2014-07-09.
// Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Nuke.h"
#import "Field.h"
#import "Board.h"
#import "SpellFactory.h"


@implementation Nuke {
    NSString *spellName;
}

- (id)init {
    self = [super init];
    if (self) {
        self.spellType = kNuke;
        self.spellName = [SpellFactory getNameFromEnum:self.spellType];
        self.spriteFrame = [CCSpriteFrame frameWithImageNamed:[SpellFactory getFileNameFromEnum:self.spellType]];
    }

    return self;
}

- (void)CastSpell:(Board *)targetBoard Sender:(Field *)senderField {

    NSMutableArray *blocks = [targetBoard getAllBlocksInBoard];
    [targetBoard DeleteBlocksFromBoardAndSprite:blocks];

    NSDictionary* dict = @{@"Blocks" : blocks, @"Target": @(((Field *) targetBoard.parent).Idx)};
    [[NSNotificationCenter defaultCenter] postNotificationName:BlocksToDelete object:nil userInfo:dict];

}

@end