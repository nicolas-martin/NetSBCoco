//
// Created by Nicolas Martin on 2014-07-19.
// Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Block.h"
#import "ICastable.h"


@implementation Block {


}


- (void)addSpellToBlock:(<ICastable>)spell {

    _spell = spell;
    self.spriteFrame = spell.spriteFrame;

}

- (void)moveUp {
    _boardY -= 1;
}

- (void)moveDown {
    _boardY += 1;
}

- (void)MoveTo:(Block *)block {
    _boardX = block.boardX;
    _boardY = block.boardY;
}

- (void)moveByX:(NSUInteger)offsetX {
    _boardX += offsetX;
}

- (void)moveRight {
    _boardX += 1;
}

- (void)moveLeft {
    _boardX -= 1;
}


@end