//
// Created by Nicolas Martin on 2014-07-19.
// Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Block.h"
#import "ICastable.h"


@implementation Block {


}

+ (Block *)CreateRandomBlock{
    NSMutableArray *blocks = [@[@"Blue", @"Cyan", @"Green", @"Magenta", @"Orange", @"Red", @"Yellow"] mutableCopy];

    NSUInteger random = arc4random() % (blocks.count - 1);
    NSString *key = blocks[random];

    Block *block = (Block *) [CCBReader load:[NSString stringWithFormat:@"Blocks/%@",key]];

    block.type = (blockType)random;

    return block;
}

+ (Block *)CreateRandomBlockWithPosition:(CGPoint) blockPosition{
    Block *block = [Block CreateRandomBlock];
    block.boardX = (NSUInteger) blockPosition.x;
    block.boardY = (NSUInteger) blockPosition.y;
    [block setStuck:YES];

    return block;

}


- (void)ReplaceBlockRandomImage{
    NSMutableArray *blocks = [@[@"Blue", @"Cyan", @"Green", @"Magenta", @"Orange", @"Red", @"Yellow"] mutableCopy];

    NSUInteger random = arc4random() % (blocks.count - 1);
    NSString *key = blocks[random];

    self.spriteFrame = [CCSpriteFrame frameWithImageNamed:[NSString stringWithFormat:@"Assets/%@.png",key]];
}

- (void)addSpellToBlock:(<ICastable>)spell {

    _spell = spell;
    self.spriteFrame = spell.spriteFrame;

}

- (void)removeSpell {
    _spell = nil;
    [self ReplaceBlockRandomImage];

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