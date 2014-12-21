//
// Created by Nicolas Martin on 2014-07-08.
// Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Board.h"
#import "Block.h"
#import "Tetromino.h"
#import "SpellFactory.h"
#import "UITouch+CC.h"


@implementation Board {
    NSMutableArray *_array;
    Tetromino *userTetromino;
    BOOL isDrag;
    CGPoint previousTouch;
}

- (id)init {
    self = [super init];
    if (self) {
        self.Nbx = 10;
        self.Nby = 20;
        _array = self.get20x10Array;
        self.userInteractionEnabled = YES;

    }

    return self;
}

//TODO: Reduce the %
- (void)addSpellToField {

    NSMutableArray *allBlocksInBoard = [self getAllBlocksInBoard];
    NSUInteger nbBlocksInBoard = allBlocksInBoard.count;
    NSUInteger nbSpellToAdd = 0;

    for (NSUInteger i = 0; i < nbBlocksInBoard; i++) {
        if ([self randomBoolWithPercentage:10]) {
            nbSpellToAdd++;
        }
    }

    for (NSUInteger i = 0; i < nbSpellToAdd; i++) {
        NSUInteger posOfSpell = arc4random() % nbBlocksInBoard;
        Block *block = allBlocksInBoard[posOfSpell];
        if (block.spell == nil) {
            id <ICastable> spell = [SpellFactory getSpellUsingFrequency];
            [block addSpellToBlock:spell];
        }
    }
}

- (BOOL)randomBoolWithPercentage:(NSUInteger)percentage {
    return (arc4random() % 100) < percentage;
}

- (void)onEnter {

}

- (void)touchMoved:(CCTouch *)touch withEvent:(CCTouchEvent *)event
{

    NSUInteger previousLocation = userTetromino.anchorX;
    CGPoint pos = [touch locationInNode:self];
    CGPoint tileCoordForPosition = [self tileCoordForPosition:pos];

    if(previousLocation > tileCoordForPosition.x){
        [self moveTetrominoLeft];
    }
    else if (previousLocation < tileCoordForPosition.x)
    {
        [self moveTetrominoRight];
    }

    isDrag = YES;

}

- (void)touchBegan:(CCTouch *)touch withEvent:(CCTouchEvent *)event {

    isDrag = NO;

    previousTouch = [touch locationInNode:self];

}

- (void)touchEnded:(CCTouch *)touch withEvent:(CCTouchEvent *)event
{
    if (!isDrag){

        CGPoint pos = [touch locationInNode:self];

        CGPoint tileCoordForPosition = [self tileCoordForPosition:pos];

        [self rotateTetromino:rotateClockwise];


    }else{
        CGPoint pos = [touch locationInNode:self];
        float swipeLength = ccpDistance(previousTouch, pos);

        if (previousTouch.y > pos.y && swipeLength > 40) {
            while(userTetromino.lowestPosition.y != _Nby - 1 && [self canMoveTetrominoByYTetrominoOffSetY:1]){
                [self moveTetrominoDown];
            }
            userTetromino.stuck = YES;
        }
    }

    isDrag = NO;
}
- (void)touchCancelled:(UITouch *)touch withEvent:(UIEvent *)event
{
}

- (CGPoint)tileCoordForPosition:(CGPoint)position {
    CGFloat tileWidth = [(userTetromino.children)[1] contentSize].width;
    NSUInteger x = (NSUInteger) (position.x / tileWidth);
    NSUInteger y = (NSUInteger) (((self.contentSize.height) - position.y) / tileWidth);
    return ccp(x, y);
}

- (void)didLoadFromCCB {
}

- (NSMutableArray *)get20x10Array {
    NSMutableArray *arr = [NSMutableArray array];
    for (int i = 0; i < _Nbx; ++i) {
        NSMutableArray *subarr = [NSMutableArray array];
        for (int j = 0; j < self.Nby; ++j)
            //insert at index??
            [subarr addObject:@0];
        [arr addObject:subarr];
    }
    return arr;
}

- (BOOL)isBlockAt:(CGPoint)point {

    if (point.x == _Nby) {
        point.x = _Nby-1;
    }
    NSMutableArray *inner = _array[(NSUInteger) point.x];

    return inner[(NSUInteger) point.y] != @0;
}

- (NSMutableArray *)getAllBlocksInBoard {
    NSMutableArray *blocksInBoard = [NSMutableArray array];
    for (NSUInteger x = 0; x < _Nbx; x++) {
        for (NSUInteger y = 0; y < _Nby; y++) {
            Block *block = [self getBlockAt:ccp(x, y)];
            if (block != nil && block.stuck) {
                [blocksInBoard addObject:block];
            }

        }
    }

    return blocksInBoard;
}

- (Block *)getBlockAt:(CGPoint)point {

    NSUInteger x = (NSUInteger) point.x;
    NSUInteger y = (NSUInteger) point.y;

    if ([self isBlockAt:point]) {
        return [_array[x] objectAtIndex:y];
    }
    else {
        return nil;
    }
}

- (void)insertBlockAt:(Block *)block at:(CGPoint)point {
    NSUInteger x = (NSUInteger) point.x;
    NSUInteger y = (NSUInteger) point.y;

    [_array[x] replaceObjectAtIndex:y withObject:block];
}

- (void)DeleteBlockFromBoard:(NSMutableArray *)blocks {

    for (Block *block in blocks) {
        [_array[(NSUInteger) block.boardX] replaceObjectAtIndex:(NSUInteger) block.boardY withObject:@0];
    }

}

- (void)DeleteBlockFromBoardAndSprite:(NSMutableArray *)blocks {

    for (Block *block in blocks) {
        [_array[(NSUInteger) block.boardX] replaceObjectAtIndex:(NSUInteger) block.boardY withObject:@0];
        [block removeFromParentAndCleanup:YES];
    }

}

//Is this still needed?
- (void)MoveTetromino:(Tetromino *)FromTetromino to:(Tetromino *)ToTetromino {

    //delete
    for (Block *block in FromTetromino.children) {
        [_array[block.boardX] replaceObjectAtIndex:block.boardY withObject:@0];
    }
    //insert
    [self addTetrominoToBoard:(NSMutableArray *) ToTetromino.children];

}

- (void)MoveBlock:(Block *)block to:(CGPoint)after {
    NSUInteger x = (NSUInteger) [block boardX];
    NSUInteger y = (NSUInteger) [block boardY];

    //delete
    [_array[x] replaceObjectAtIndex:y withObject:@0];
    //insert
    [self insertBlockAt:block at:after];
}

- (BOOL)boardRowFull:(NSUInteger)y {
    BOOL occupied = NO;
    for (int x = 0; x < _Nbx; x++) {

        if (![self isBlockAt:ccp(x, y)]) {
            occupied = NO;
            //Since there's an empty block on this column there's no need to look at the others
            //Exits both loops and get the next row
            break;

        }
        else {
            occupied = YES;
        }
    }
    return occupied;
}

- (NSMutableArray *)DeleteRow:(NSUInteger)y {
    NSMutableArray *blocksWithSpell = [NSMutableArray array];

    for (NSUInteger x = 0; x < _Nbx; x++) {

        Block *block = [self getBlockAt:ccp(x, y)];

        if (block.spell != Nil) {
            [blocksWithSpell addObject:block.spell];
        }

        [block removeFromParentAndCleanup:YES];
        [_array[x] replaceObjectAtIndex:y withObject:@0];

    }

    return blocksWithSpell;

}

- (NSMutableArray *)MoveBoardDown:(NSUInteger)y nbRowsToMoveDownTo:(NSUInteger)step {
    NSMutableArray *blocksToSetPosition = [NSMutableArray array];

    for (y; y > 0; y--) {
        for (NSUInteger x = 0; x < _Nbx; x++) {
            Block *current = [self getBlockAt:ccp(x, y)];
            if (current != nil) {

                [self MoveBlock:current to:ccp(x, y + step)];

                current.boardY = current.boardY + step;

                [blocksToSetPosition addObject:current];

            }
        }
    }
    return blocksToSetPosition;
}

- (void)addTetrominoToBoard:(NSMutableArray *)blocksToAdd {

    for (Block *block in blocksToAdd) {
        [self insertBlockAt:block at:ccp(block.boardX, block.boardY)];
    }

}

- (void)printCurrentBoardStatus:(BOOL)withPosition {
    NSUInteger anchorx = userTetromino.anchorX;
    NSUInteger anchory = userTetromino.anchorY;
    NSLog(@"--------------------------------------------------------------------");
    for (NSUInteger j = 0; j < _Nby; ++j) {
        NSMutableString *row = [NSMutableString string];
        for (NSUInteger i = 0; i < _Nbx; ++i) {

            if ([self isBlockAt:ccp(i, j)]) {
                if (withPosition) {
                    [row appendFormat:@"(%02d,%02d) ", i, j];
                }
                else {
                    if(j == anchory && i == anchorx){
                        [row appendFormat:@"O "];
                    }else{
                        [row appendFormat:@"X "];
                    }

                }
            }
            else {
                if (withPosition) {
                    [row appendFormat:@"(  ,  ) "];
                }
                else {
                    [row appendFormat:@"  "];
                }
            }

        }

        NSLog(@"%@", row);

    }
}

- (BOOL)canMoveTetrominoByYTetrominoOffSetY:(NSUInteger)offSetY {

    // Sort blocks by x value if moving left, reverse order if moving right
    NSMutableArray *reversedChildren = [[NSMutableArray alloc] initWithArray:userTetromino.children];
    NSEnumerator *enumerator;

    if (offSetY > 0) {
        enumerator = [reversedChildren reverseObjectEnumerator];
    }

    for (Block *currentBlock in enumerator) {
        //dont compare yourself
        if (!([userTetromino isBlockInTetromino:[self getBlockAt:ccp(currentBlock.boardX, currentBlock.boardY + offSetY)]])) {
            //if there's another block at the position you're looking at, you can't move
            if ([self isBlockAt:ccp(currentBlock.boardX, currentBlock.boardY + offSetY)]) {
                return NO;
            }
        }
    }
    return YES;

}

- (BOOL)canMoveTetrominoByXTetrominoOffSetX:(NSInteger)offSetX {

    // Sort blocks by x value if moving left, reverse order if moving right
    NSMutableArray *reversedChildren = [[NSMutableArray alloc] initWithArray:userTetromino.children];
    NSEnumerator *enumerator;

    if (offSetX > 0) {
        enumerator = [reversedChildren reverseObjectEnumerator];
    }

    for (Block *currentBlock in enumerator) {
        //dont compare yourself
        if (!([userTetromino isBlockInTetromino:[self getBlockAt:ccp(currentBlock.boardX + offSetX, currentBlock.boardY)]])) {
            //if there's another block at the position you're looking at, you can't move
            if ([self isBlockAt:ccp(currentBlock.boardX + offSetX, currentBlock.boardY)]) {
                return NO;
            }
        }
    }
    return YES;

}

- (BOOL)isTetrominoInBounds:(CGPoint)point {


    if (point.x < 0 || point.x >= _Nbx|| point.y < 0 || point.y >= _Nby) {
        NSLog(@"DENIED - OUT OF BOUNDS");
        return NO;

    }

    BOOL found = NO;
    for (Block *currentBlock in userTetromino.children) {
        if ([currentBlock boardX] == point.x && [currentBlock boardY] == point.y) {
            found = YES;
            break;
        }
    }

    if (!found){

        if ([self isBlockAt:ccp(point.x, point.y)]) {
            NSLog(@"DENIED - COLLISION");
            return NO;
        }
    }

   return YES;
}

- (BOOL)boardRowEmpty:(NSUInteger)y {

    return [self boardRowFull:y];

}

- (void)addBlocks:(NSMutableArray *)blocksToAdd {

    [self addTetrominoToBoard:blocksToAdd];

    [self setPositionUsingFieldValue:blocksToAdd];

    for (Block *blocks in blocksToAdd) {
        [self.parent addChild:blocks];
    }

}

- (void)setPositionUsingFieldValue:(NSMutableArray *)arrayOfBlocks {

    for (Block *block in arrayOfBlocks) {
        NSInteger boardX = [block boardX];
        NSInteger boardY = [block boardY];

        NSInteger x = (NSInteger) (boardX * block.contentSize.width);
        NSInteger y = (NSInteger) ((-boardY * block.contentSize.height) + self.contentSize.height);
        [block setPosition:ccp(x, y)];
    }

}

- (BOOL)moveDownOrCreate {
    BOOL _gameOver;

    if (userTetromino.stuck || userTetromino == NULL) {
        _gameOver = [self createNewTetromino];
    }
    else if (userTetromino.lowestPosition.y != _Nby - 1 && [self canMoveTetrominoByYTetrominoOffSetY:1]) {
        [self moveTetrominoDown];
        userTetromino.stuck = NO;
        _gameOver = NO;
    }
    else {
        userTetromino.stuck = YES;
        _gameOver = [self createNewTetromino];
    }

    return _gameOver;

}

- (BOOL)VerifyNewBlockCollision:(Tetromino *)new {

    BOOL collision = NO;

    for (Block *block in new.children) {
        if ([self isBlockAt:ccp(block.boardX, block.boardY)]) {
            collision = YES;
            continue;
        }
    }

    return collision;


}

- (NSMutableArray *)checkForRowsToClear {

    NSMutableArray *rowToDelete = [[NSMutableArray alloc] init];
    BOOL occupied = NO;

    NSNumber *deletedRow = (NSNumber *) nil;
    for (NSUInteger y = 0; y < _Nby; y++) {

        //Skip row already processed

        if (y == (NSUInteger) deletedRow) {
            continue;
        }

        for (int x = 0; x < _Nbx; x++) {

            if (![self isBlockAt:ccp(x, y)]) {
                occupied = NO;
                //Since there's an empty block on this column there's no need to look at the others
                //Exits both loops and get the next row
                break;

            }
            else {
                occupied = YES;
            }
        }

        if (occupied) {

            deletedRow = @(y);

            [rowToDelete addObject:deletedRow];

        }
        else {
            continue;
        }
    }

    return rowToDelete;

}

- (NSMutableArray *)deleteRowsAndReturnSpells:(NSMutableArray *)rowsToDelete {
    NSMutableArray *spellsToAdd = [[NSMutableArray alloc] init];

    NSNumber *highestRow = @99;
    for (NSNumber *row in rowsToDelete) {
        [spellsToAdd addObjectsFromArray:[self DeleteRow:[row unsignedIntegerValue]]];

        if (highestRow.integerValue > row.integerValue) {
            highestRow = row;
        }

    }

    [self setPositionUsingFieldValue:[self MoveBoardDown:([highestRow unsignedIntegerValue] - 1) nbRowsToMoveDownTo:rowsToDelete.count]];

    //put it here or else it gets the bocks not yet deleted.
    [self addSpellToField];

    return spellsToAdd;
}

- (BOOL)createNewTetromino {

    BOOL _gameOver;
    Tetromino * tempTetromino = [Tetromino CreateRandomTetromino];

    if([self VerifyNewBlockCollision:tempTetromino]){
        _gameOver = YES;
    }
    else
    {
        [self UpdatesNewTetromino:tempTetromino];

        [self addChild:tempTetromino];

        userTetromino = tempTetromino;

        _gameOver = NO;
    }

    return _gameOver;

}

- (void)moveTetrominoDown {

    [self DeleteBlockFromBoard:(NSMutableArray *) userTetromino.children];

    [userTetromino moveTetrominoDown];

    [self UpdatesNewTetromino:userTetromino];

}

- (void)UpdatesNewTetromino:(Tetromino *)ToTetromino {

    [self setPositionUsingFieldValue:(NSMutableArray *) ToTetromino.children];

    [self addTetrominoToBoard:(NSMutableArray *) ToTetromino.children];

}

//TODO: Merge the move together
- (void)moveTetrominoLeft {

    if (userTetromino.leftMostPosition.x > 0 && !userTetromino.stuck) {
        if ([self canMoveTetrominoByXTetrominoOffSetX:-1]) {

            [self DeleteBlockFromBoard:(NSMutableArray *) userTetromino.children];

            [userTetromino moveTetrominoInDirection:moveLeft];

            [self UpdatesNewTetromino:userTetromino];

        }
    }

}

- (void)moveTetrominoRight {
    if (userTetromino.rightMostPosition.x < kLastColumn && !userTetromino.stuck) {
        if ([self canMoveTetrominoByXTetrominoOffSetX:1]) {
            [self DeleteBlockFromBoard:(NSMutableArray *) userTetromino.children];

            [userTetromino moveTetrominoInDirection:moveRight];

            [self UpdatesNewTetromino:userTetromino];

        }
    }
}

//TODO: Sometimes when rotating a tetromino it moves up for some reason.
- (void)rotateTetromino:(RotationDirection)direction {

    NSUInteger px = userTetromino.anchorX;
    NSUInteger py = userTetromino.anchorY;
    BOOL Valid = YES;


    //HACK: Skip the 'O' shape
    if(userTetromino.type ==  O_block)
    {
        return;
    }
//    else if(userTetromino.type == I_block)
//    {
//
//    }
    else
    {

        //Tries all the new position and check if they're valid
        for (Block *block in userTetromino.children){
            NSUInteger y1 = block.boardY;
            NSUInteger x1 = block.boardX;

            NSUInteger x2 = (px + py - y1);
            NSUInteger y2 = (x1 + py - px);


            if (![self isTetrominoInBounds:ccp(x2,y2)]){
                Valid = NO;
                break;
            }
        }

        if (Valid){
            [self DeleteBlockFromBoard:(NSMutableArray *) userTetromino.children];
            for (Block *block in userTetromino.children){
                NSUInteger y1 = block.boardY;
                NSUInteger x1 = block.boardX;

                NSUInteger x2 = (px + py - y1);
                NSUInteger y2 = (x1 + py - px);

                block.boardX = x2;
                block.boardY = y2;

            }

            [self UpdatesNewTetromino:userTetromino];

            //[self printCurrentBoardStatus:NO];

        }
    }


}

@end