//
// Created by Nicolas Martin on 2014-08-30.
// Copyright (c) 2014 hero. All rights reserved.
//

#import <MacTypes.h>
#import "SwitchBoard.h"
#import "ICastable.h"
#import "Board.h"
#import "Field.h"
#import "SpellFactory.h"


@implementation SwitchBoard {
    NSString *spellName;
}

- (id)init {
    self = [super init];
    if (self) {
        self.spellType = kSwitchBoard;
        self.spellName = [SpellFactory getNameFromEnum:self.spellType];
        self.spriteFrame = [CCSpriteFrame frameWithImageNamed:[SpellFactory getFileNameFromEnum:self.spellType]];

    }

    return self;
}


- (void)CastSpell:(Board *)targetBoard Sender:(Field *)senderField {
    NSMutableArray *targetBoardBlocks;
    NSMutableArray *playerBoardBlocks;

    if (targetBoard == senderField.board)
        return;
    playerBoardBlocks = senderField.board.getAllBlocksInBoard;
    targetBoardBlocks = targetBoard.getAllBlocksInBoard;

    [senderField.board DeleteBlocksFromBoardAndSprite:playerBoardBlocks];
    [targetBoard DeleteBlocksFromBoardAndSprite:targetBoardBlocks];

    [senderField.board addBlocks:targetBoardBlocks];
    [targetBoard addBlocks:playerBoardBlocks];

    NSDictionary* dict = @{@"Blocks" : targetBoardBlocks, @"Target": @(((Field *) targetBoard.parent).Idx)};
    [[NSNotificationCenter defaultCenter] postNotificationName:BlocksToDelete object:nil userInfo:dict];

    NSDictionary* dict2 = @{@"Blocks" : playerBoardBlocks, @"Target": @(senderField.Idx)};
    [[NSNotificationCenter defaultCenter] postNotificationName:BlocksToDelete object:nil userInfo:dict2];

    NSDictionary* dict3 = @{@"Blocks" : playerBoardBlocks, @"Target": @(((Field *) targetBoard.parent).Idx)};
    [[NSNotificationCenter defaultCenter] postNotificationName:BlocksToAdd object:nil userInfo:dict3];

    NSDictionary* dict4 = @{@"Blocks" : targetBoardBlocks, @"Target": @(senderField.Idx)};
    [[NSNotificationCenter defaultCenter] postNotificationName:BlocksToAdd object:nil userInfo:dict4];



}


@end