//
// Created by Nicolas Martin on 2014-07-08.
// Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Field.h"
#import "Inventory.h"
#import "Board.h"
#import "Block.h"
#import "Gravity.h"
#import "ClearSpecial.h"
#import "SpellFactory.h"
#import "GameKitHelper.h"


@implementation Field {
    Inventory *_inventory;
    CCLabelTTF *_nbRowCleared;
    CCLabelTTF *_gameOver;
    CCLabelTTF *_playerName;

}

-(void)setName:(NSString *)Name {
    _playerName.string = Name;
}


- (void)didLoadFromCCB {

    [self initSomeBlocks];

}

-(void)displayGameOver{
    _gameOver.string = @"GAME OVER";
}

- (void)addSpellsToInventory:(NSMutableArray *)spellsToAdd {
    for (id <ICastable> spell in spellsToAdd) {
        [_inventory addSpell:spell];
    }
}

- (BOOL)updateStatus {

    NSMutableArray *rows = self.board.checkForRowsToClear;
    if (rows.count > 0) {
        NSMutableArray *spellsToAdd = [self.board deleteRowsAndReturnSpells:rows];
        if (spellsToAdd.count > 0) {
            [self addSpellsToInventory:spellsToAdd];

        }
        _nbRowCleared.string = [NSString stringWithFormat:@"%d", (int) _nbRowCleared.string.integerValue + rows.count];

    }

    //TODO: Send the updated board to all players
    //[[GameCenterHelper sharedInstance] sendAction:_board];

    return self.board.moveDownOrCreate;
}


- (void)initSomeBlocks {
    NSMutableArray *bArray = [NSMutableArray array];
    for (int i = 0; i < _board.Nbx; i++) {
        if (i == 9) continue;
        for (int j = 0; j < 5; j++) {
            if (i % 4) {

                Block *block = [Block CreateRandomBlockWithPosition:ccp(i, ((_board.Nby - 1) - j))];
                [bArray addObject:block];
            }
            else {

                Block *block = [Block CreateRandomBlockWithPosition:ccp(i, ((_board.Nby - 1) - j))];

                //id spell = [SpellFactory getSpellFromType:kRandomRemove];
                id spell = [SpellFactory getSpellUsingFrequency];

                [block addSpellToBlock:spell];
                [bArray addObject:block];
            }
        }
    }


    [self.board addBlocks:bArray];


}

@end