//
// Created by Nicolas Martin on 2014-08-30.
// Copyright (c) 2014 hero. All rights reserved.
//

#import <MacTypes.h>
#import "SwitchBoard.h"
#import "ICastable.h"
#import "Board.h"
#import "Field.h"


@implementation SwitchBoard {
    NSString *spellName;
}

- (id)init {
    self = [super init];
    if (self) {
        spellName = @"SwitchBoard field";
        self.spriteFrame = [CCSpriteFrame frameWithImageNamed: @"Assets/SwitchField.png"];

    }

    return self;
}

- (NSString *)LogSpell:(Board *)targetBoard {
    return [NSString stringWithFormat:@"%@ was casted on %@", spellName, targetBoard.Name];
}

- (void)CastSpell:(Board *)targetBoard Sender:(Field *)senderField {
    NSMutableArray *targetBoardBlocks;
    NSMutableArray *playerBoardBlocks;

    playerBoardBlocks = senderField.board.getAllBlocksInBoard;
    targetBoardBlocks = targetBoard.getAllBlocksInBoard;

    [senderField.board DeleteBlockFromBoardAndSprite:playerBoardBlocks];
    [targetBoard DeleteBlockFromBoardAndSprite:targetBoardBlocks];

    [senderField.board addBlocks:targetBoardBlocks];
    [targetBoard addBlocks:playerBoardBlocks];


}


@end