//
// Created by Nicolas Martin on 2014-08-31.
// Copyright (c) 2014 hero. All rights reserved.
//

#import <MacTypes.h>
#import "ClearSpecial.h"
#import "Board.h"
#import "Field.h"
#import "Block.h"


@implementation ClearSpecial {
    NSString *spellName;

}

- (id)init {
    self = [super init];
    if (self) {
        spellName = @"Clear special blocks";
        self.spriteFrame = [CCSpriteFrame frameWithImageNamed:@"Assets/ClearSpell.png"];

    }

    return self;
}
- (void)CastSpell:(Board *)targetBoard Sender:(Field *)senderField {

    NSMutableArray *allBlocksInBoard = [targetBoard getAllBlocksInBoard];

    for (Block *block in allBlocksInBoard){
        if (block.spell != nil){
            [block removeSpell];
        }
    }

}


- (NSString *)LogSpell:(Board *)targetBoard {
    return [NSString stringWithFormat:@"%@ was casted on %@", spellName, targetBoard.Name];
}


@end