//
// Created by Nicolas Martin on 2014-07-08.
// Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Field.h"
#import "Inventory.h"
#import "Board.h"
#import "Tetromino.h"
#import "Block.h"


@implementation Field {
    Inventory *_inventory;
    Board *_board;
    CCLabelTTF *_nbRowCleared;

}

- (void) didLoadFromCCB {
    [self initSomeBlocks];


}

-(void) addSpellsToInventory:(NSMutableArray *)spellsToAdd{
    for (id <ICastable> spell in spellsToAdd)
    {
        [_inventory addSpell:spell];
    }
}

- (void) moveDownOrCreate {

    NSMutableArray *rows = _board.checkForRowsToClear;
    if (rows.count > 0)
    {
        NSMutableArray *spellsToAdd = [_board deleteRowsAndReturnSpells:rows];
        if (spellsToAdd.count > 0)
        {
            [self addSpellsToInventory:spellsToAdd];

        }
        _nbRowCleared.string = [NSString stringWithFormat:@"%d", (int) _nbRowCleared.string.integerValue + rows.count];

    }
    _board.moveDownOrCreate;


}



- (void)initSomeBlocks{
    NSMutableArray *bArray = [NSMutableArray array];
    for(int i = 0; i < 10; i++)
    {
        if (i == 9) continue;
        for (int j = 0; j < 5; j++)
        {
            if(i%4)
            {
                //Tetromino *tempTetromino = (Tetromino *) [CCBReader load:@"Shapes/I"];
                Block *block = (Block *) [CCBReader load:@"Blocks/Green"];
                [block setBoardX:i];
                [block setBoardY:19-j];
                [block setStuck:YES];
                [bArray addObject:block];
            }
            else
            {
                Block *block = (Block *) [CCBReader load:@"Blocks/Cyan"];
                //block.spriteFrame = [CCSpriteFrame frameWithImageNamed: @"Assets/AddLine.png"];

                [block setBoardX:i];
                [block setBoardY:19-j];
                [block setStuck:YES];
                [bArray addObject:block];
            }
        }
    }



    [_board addBlocks:bArray];
    for (Block *blocks in bArray)
    {
        [self addChild:blocks];
    }

}

@end