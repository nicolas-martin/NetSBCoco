//
// Created by Nicolas Martin on 2014-07-08.
// Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Inventory.h"
#import "ICastable.h"
#import "Gravity.h"
#import "FieldCollisionHelper.h"
#import "Field.h"


@implementation Inventory {

    NSMutableArray *inventory;
    NSMutableArray *movableSprites;
    CCSprite *selSprite;
}
- (id)init {
    self = [super init];
    if (self) {
        inventory = [[NSMutableArray alloc]init];
        movableSprites = [[NSMutableArray alloc]init];
        self.userInteractionEnabled = YES;
    }

    return self;
}

- (void)didLoadFromCCB {

}


- (void)addSpell:(<ICastable>)spell {

    if(inventory.count < 10)
    {
        [inventory addObject:spell];
        //Or use SpellFactory to get a spell back using the name.
        CCSprite *newSpellSprite = (id) (id <ICastable> )[[CCSprite alloc] init];
        newSpellSprite.spriteFrame = [spell spriteFrame];

        [newSpellSprite setPosition:ccp(newSpellSprite.contentSize.width * inventory.count, newSpellSprite.contentSize.height/2)];
        
        //do I really need this?
        [newSpellSprite setName:@"1"];
        newSpellSprite.userObject = spell;
        [movableSprites addObject:newSpellSprite];
        [self addChild:newSpellSprite];
    }
}

//- (void)removeSpell:(<ICastable>)spell {
//
//    [inventory removeObject:spell];
//
////    [movableSprites removeObject:selSprite];
////    [selSprite removeFromParentAndCleanup:YES];
//    [movableSprites removeObject:spell];
//    [spell removeFromParentAndCleanup:YES];
//
//    NSUInteger count = 1;
//    for (CCSprite *sprite in movableSprites)
//    {
//        [sprite setPosition:ccp(sprite.contentSize.width*count, sprite.contentSize.height/2)];
//        count++;
//
//    }
//}

-(void) touchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    CGPoint touchLocation = [touch locationInNode:self];
    [self selectSpriteForTouch:touchLocation];
}


- (void)touchMoved:(UITouch *)touch withEvent:(UIEvent *)event {
    CGPoint touchLocation = [touch locationInNode:self];

    if (selSprite) {
        selSprite.position = touchLocation;

    }
}



- (void)touchEnded:(UITouch *)touch withEvent:(UIEvent *)event {
    CGPoint touchLocation = [touch locationInNode:self];

    Board *targetField = [FieldCollisionHelper GetFieldFromPosition:touchLocation];

    id<ICastable> obj = selSprite.userObject;
    [obj CastSpell: targetField];



}

- (void)selectSpriteForTouch:(CGPoint)touchLocation {
    CCSprite * newSprite = nil;
    for (CCSprite *sprite in movableSprites)
    {
        //why
        if (sprite.name == @"1"){

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