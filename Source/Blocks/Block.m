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

    //self.spriteFrame = [CCSpriteFrame frameWithImageNamed:@"gravity.png"];

}

- (void)moveUp
{
    _boardY -= 1;
    [self redrawPositionOnBoard];
}

- (void)moveDown
{
    _boardY += 1;
    [self redrawPositionOnBoard];
}

-(void)MoveTo:(Block *)block
{
    _boardX = block.boardX;
    _boardY = block.boardY;

    [self redrawPositionOnBoard];
}

- (void)moveByX:(NSUInteger)offsetX
{
    _boardX += offsetX;
    [self redrawPositionOnBoard];
}

- (void)moveRight
{
    _boardX += 1;
    [self redrawPositionOnBoard];
}

- (void)moveLeft
{
    _boardX -= 1;
    [self redrawPositionOnBoard];
}

- (void)redrawPositionOnBoard
{
    //compute
    //self.position = ccp(_boardX * self.contentSize.width, -_boardY * self.contentSize.height);
}


@end