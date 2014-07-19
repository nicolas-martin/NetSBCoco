//
// Created by Nicolas Martin on 2014-07-09.
// Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Nuke.h"
#import "Field.h"
#import "Board.h"


@implementation Nuke {
    NSString *_spellName;
}

- (id)init {
    self = [super init];
    if (self) {
        _spellName = @"Nuke";

    }

    return self;
}


//- (void)CastSpell:(Field *)targetField {
//    Board *board = targetField.board;
//
//    [board DeleteBlockFromBoardAndSprite:[board getAllBlocksInBoard]];
//
//}
//
//- (NSString *)LogSpell:(Field *)targetField {
//    return [NSString stringWithFormat:@"%@ was casted on %@", _spellName, targetField.Name];
//}
@end