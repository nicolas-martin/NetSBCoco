//
// Created by Nicolas Martin on 2014-07-08.
// Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Field.h"
#import "Inventory.h"
#import "Board.h"
#import "Block.h"
#import "SpellFactory.h"

NSString *const SpellsToAdd = @"SpellsToAdd";

@implementation Field {
    Inventory *_inventory;
    CCLabelTTF *_nbRowCleared;
    CCLabelTTF *_gameOver;
    CCLabelTTF *_playerName;

}

-(void)setName:(NSString *)Name andId:(NSUInteger)id{
    //Not sure why it sends a nil here sometimes
    if (Name == Nil){
        Name = @"";
    }
    _playerName.string = Name;
    _name = Name;
    _Idx = id;
}

- (void)didLoadFromCCB {

    [self initSomeBlocks];

}

- (void)displayGameOver{
    _gameOver.string = @"GAME OVER";
}

- (void)addSpellsToInventory:(NSMutableArray *)spellsToAdd {
    for (id <ICastable> spell in spellsToAdd) {
        [_inventory addSpell:spell];
    }

    //TODO: Send notification
    //NSDictionary* dict = @{@"Blocks" : spellsToAdd, @"Target": @(self.Idx)};
    //[[NSNotificationCenter defaultCenter] postNotificationName:BlocksToAdd object:nil userInfo:dict];
}

- (BOOL)updateStatus {

    if ([self deleteRowAddSpellAndUpdateScore] > 0){
        [self addSpellToField];
    }

    return self.board.moveDownOrCreate;
}

- (NSUInteger)deleteRowAddSpellAndUpdateScore {
    NSMutableArray *rows = self.board.checkForRowsToClear;
    if (rows.count > 0) {
        NSMutableArray *spellsToAdd = [self.board deleteRowsAndReturnSpells:rows];

        if (spellsToAdd.count > 0) {

            //TODO: Bonus AddLine to everybody.
//            if(spellsToAdd.count == 4){
//
//                //TODO: Get number of players another way.
//                for (int i = 0; i <4; i++){
//
//                    NSMutableDictionary* blockAndStep = [NSMutableDictionary dictionary];
//                    [blockAndStep setValue:@"-1" forKey:NSStringFromCGPoint(ccp(0, 0))];
//                    NSDictionary* dict2 = @{@"Blocks" : blockAndStep, @"Target": @(i)};
//                    [[NSNotificationCenter defaultCenter] postNotificationName:BlocksToMove object:nil userInfo:dict2];
//
//                    NSMutableArray *line = [self CreateBlockLine];
//                    [targetBoard addBlocks:line];
//
//                    NSDictionary* dict = @{@"Blocks" : line, @"Target": @(i)};
//                    [[NSNotificationCenter defaultCenter] postNotificationName:BlocksToAdd object:nil userInfo:dict];
//                }
//
//
//            }else{
                [self addSpellsToInventory:spellsToAdd];
            //}


        }



        _nbRowCleared.string = [NSString stringWithFormat:@"%d", (int) _nbRowCleared.string.integerValue + rows.count];

    }

    return rows.count;
}

//TODO: Reduce the %
- (void)addSpellToField {
    NSLog(@"Add spells to field for player %d", self.Idx);

    NSMutableArray *allBlocksInBoard = [self.board getAllBlocksInBoard];
    NSUInteger nbBlocksInBoard = allBlocksInBoard.count;
    NSUInteger nbSpellToAdd = 0;
    NSMutableArray *newSpells = [NSMutableArray array];

    for (NSUInteger i = 0; i < nbBlocksInBoard; i++) {
        //10%
        if ((arc4random() % 100) < 10) {
            nbSpellToAdd++;
        }
    }

    for (NSUInteger i = 0; i < nbSpellToAdd; i++) {

        NSUInteger posOfSpell = arc4random() % nbBlocksInBoard;
        Block *block = allBlocksInBoard[posOfSpell];

        if (block.spell == nil) {
            //id <ICastable> spell = [SpellFactory getSpellUsingFrequency];
            id <ICastable> spell = [SpellFactory getSpellFromType:kAddLine];
            [block addSpellToBlock:spell];
            [newSpells addObject:block];
        }

    }

    NSDictionary* dict = @{@"Blocks" : newSpells, @"Target": @(self.Idx)};
    [[NSNotificationCenter defaultCenter] postNotificationName:SpellsToAdd object:nil userInfo:dict];

}


- (void)initSomeBlocks {
    NSMutableArray *bArray = [NSMutableArray array];
    for (int i = 0; i < Nbx; i++) {
        if (i == 9) continue;
        for (int j = 0; j < 5; j++) {
            if (i % 4) {

                Block *block = [Block CreateRandomBlockWithPosition:ccp(i, ((Nby - 1) - j))];
                [bArray addObject:block];
            }
            else {

                Block *block = [Block CreateRandomBlockWithPosition:ccp(i, ((Nby - 1) - j))];

                id spell = [SpellFactory getSpellFromType:kClearSpecial];

                [block addSpellToBlock:spell];
                [bArray addObject:block];
            }
        }
    }


    [self.board addBlocks:bArray];


}

@end