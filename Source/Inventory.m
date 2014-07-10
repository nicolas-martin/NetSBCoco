//
// Created by Nicolas Martin on 2014-07-08.
// Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Inventory.h"
#import "ICastable.h"


@implementation Inventory {

}

- (void)didLoadFromCCB {
    NSLog(@"Inventory loaded");
}

/*
- (void)addSpell:(<ICastable>)spell {

    if(_Inventory.count < 10)
    {
        [_Inventory addObject:spell];
        CCSprite *newSpellSprite = [CCSprite spriteWithFile:spell.spriteFileName];

        if(!_Main)
        {
            [newSpellSprite setScale:0.7];
        }

        [newSpellSprite setPosition:ccp(newSpellSprite.contentSize.width * _Inventory.count, newSpellSprite.contentSize.height/2)];
        [newSpellSprite setTag:1];
        newSpellSprite.userObject = spell;
        [movableSprites addObject:newSpellSprite];
        [self addChild:newSpellSprite];
    }
}

- (void)removeSpell:(<ICastable>)spell {
    [_Inventory removeObject:spell];
    [movableSprites removeObject:selSprite];
    [selSprite removeFromParentAndCleanup:YES];

    NSUInteger count = 1;
    for (CCSprite *sprite in movableSprites)
    {
        [sprite setPosition:ccp(sprite.contentSize.width*count, sprite.contentSize.height/2)];
        count++;

    }
}

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    CGPoint touchLocation = [self convertTouchToNodeSpace:touch];
    [self selectSpriteForTouch:touchLocation];
    return TRUE;
}

- (void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event {
    CGPoint touchLocation = [self convertTouchToNodeSpace:touch];

    if (selSprite) {
        id move = [CCEaseIn actionWithAction:[CCMoveTo actionWithDuration:0.1 position:touchLocation]];
        [selSprite runAction:move];

    }
}

- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event {
    CGPoint touchLocation = [self convertTouchToNodeSpace:touch];

    for (NSMutableDictionary *dictionary in _fieldBoundingBoxes)
    {
        for(NSString *key in dictionary)
        {
            CGRect boundingBox = [[dictionary objectForKey:key] CGRectValue];
            if (CGRectContainsPoint(boundingBox, touchLocation)) {
                NSLog(@"DROPPED ON %@", key);

                if (selSprite)
                {
                    id<ICastable> obj = selSprite.userObject;

                    //TODO: Be careful with LEAKS!
                    GameLogicLayer *myParentAsMainClass = (GameLogicLayer*)self.parent.parent;
                    [obj CastSpell:[myParentAsMainClass getFieldFromString:key]];
                    [self removeSpell:selSprite.userObject];


                }

            }

        }
    }

}

- (void)selectSpriteForTouch:(CGPoint)touchLocation {
    CCSprite * newSprite = nil;
    for (CCSprite *sprite in movableSprites)
    {
        if (sprite.tag == 1){

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
*/

@end