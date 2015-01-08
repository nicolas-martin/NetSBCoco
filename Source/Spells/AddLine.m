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
    NSMutableDictionary* blockAndStep = [NSMutableDictionary dictionary];


    for (NSUInteger xx = 0; xx < Nbx; xx++){
        [targetBoard moveColumnUp:xx];
    }

    [blockAndStep setValue:@"-1" forKey:NSStringFromCGPoint(ccp(0, 0))];
    NSDictionary* dict2 = @{@"Blocks" : blockAndStep, @"Target": @(((Field *) targetBoard.parent).Idx)};
    [[NSNotificationCenter defaultCenter] postNotificationName:BlocksToMove object:nil userInfo:dict2];

    NSMutableArray *line = [self CreateBlockLine];
    [targetBoard addBlocks:line];

    NSDictionary* dict = @{@"Blocks" : line, @"Target": @(((Field *) targetBoard.parent).Idx)};
    [[NSNotificationCenter defaultCenter] postNotificationName:BlocksToAdd object:nil userInfo:dict];

}

- (NSMutableArray *)CreateBlockLine {
    NSMutableArray *bArray = [NSMutableArray array];

    for (NSUInteger x = 0; x < Nbx; x++) {
        NSUInteger random = arc4random();

        if ((random % 3) > 0) {
            Block *block = [Block CreateRandomBlockWithPosition:ccp(x, Nby-1)];
            [bArray addObject:block];
        }

    }
    return bArray;

}

@end