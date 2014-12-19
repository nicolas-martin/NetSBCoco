#import "Board.h"//
// Created by Nicolas Martin on 2014-07-08.
// Copyright (c) 2014 Apportable. All rights reserved.
//

#import <MacTypes.h>
#import "Inventory.h"
#import "ICastable.h"
#import "FieldCollisionHelper.h"
#import "CCNode_Private.h"
#import "UITouch+CC.h"


@implementation Inventory {

    NSMutableArray *inventory;
    NSMutableArray *movableSprites;
    CCSprite *selSprite;
}
- (id)init {
    self = [super init];
    if (self) {
        _MaxNbSpells = 10;
        inventory = [[NSMutableArray alloc] init];
        movableSprites = [[NSMutableArray alloc] init];
        self.userInteractionEnabled = YES;

    }

    return self;
}

- (void)didLoadFromCCB {

}


- (void)addSpell:(<ICastable>)spell {

    if (inventory.count < _MaxNbSpells) {
        [inventory addObject:spell];

        //TODO: Could improve the way we add spells to the inventory (userObject)
        CCSprite *newSpellSprite = (id) (id <ICastable>) [[CCSprite alloc] init];
        newSpellSprite.spriteFrame = [spell spriteFrame];

        [newSpellSprite setPosition:ccp(newSpellSprite.contentSize.width * (inventory.count - 1), 0)];

        //do I really need this?
        [newSpellSprite setName:@"1"];
        newSpellSprite.userObject = spell;
        newSpellSprite.anchorPoint = ccp(0, 0);
        [movableSprites addObject:newSpellSprite];
        [self addChild:newSpellSprite];

        //hack so that the sprite is displayed on top of the fields which are parents.
        [self.parent reorderChild:self z:50];
        [self.parent.parent reorderChild:self.parent z:25];


    }
}

- (void)removeSpell:(<ICastable>)spell {

    [inventory removeObject:spell];

    [movableSprites removeObject:selSprite];

    [selSprite removeFromParentAndCleanup:YES];

    [self reorderInventory];
}

- (void)reorderInventory {
    NSUInteger count = 0;
    for (CCSprite *sprite in movableSprites) {
        [sprite setPosition:ccp(sprite.contentSize.width * count, 0)];
        count++;

    }
}

- (void)touchBegan:(CCTouch *)touch withEvent:(CCTouchEvent *)event {
    CGPoint touchLocation = [touch locationInNode:self];
    [self selectSpriteForTouch:touchLocation];
}


- (void)touchMoved:(CCTouch *)touch withEvent:(CCTouchEvent *)event {
    CGPoint touchLocation = [touch locationInNode:self];

    if (selSprite) {
        selSprite.position = touchLocation;

    }
}


- (void)touchEnded:(CCTouch *)touch withEvent:(CCTouchEvent *)event {
    CGPoint touchLocation = [[CCDirector sharedDirector] convertToGL:[touch locationInView:[touch view]]];

    FieldCollisionHelper *fch = [FieldCollisionHelper sharedMySingleton];

    Board *targetField = [fch GetFieldFromPosition:touchLocation];

    if (targetField != nil) {
        id <ICastable> obj = selSprite.userObject;

        [obj CastSpell:targetField Sender:(Field *) self.parent];

        CCLOG(@"%@ was casted on %@", obj.spellName, targetField.name);

        [self removeSpell:selSprite.userObject];

    } else if (selSprite != nil) {

        [self reorderInventory];
    }


}

- (void)selectSpriteForTouch:(CGPoint)touchLocation {
    CCSprite *newSprite = nil;
    for (CCSprite *sprite in movableSprites) {
        //why
        if (sprite.name == @"1") {

            if (CGRectContainsPoint(sprite.boundingBox, touchLocation)) {
                newSprite = sprite;
                break;
            }

        }
    }
    if (newSprite != selSprite) {

        selSprite = newSprite;
    }
}


@end