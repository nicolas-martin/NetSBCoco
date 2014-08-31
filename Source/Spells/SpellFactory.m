//
// Created by Nicolas Martin on 12/8/2013.
//


#import "SpellFactory.h"
#import "ICastable.h"
#import "AddLine.h"
#import "RandomRemove.h"
#import "Nuke.h"
#import "Gravity.h"
#import "ClearSpecial.h"
#import "SwitchBoard.h"


@implementation SpellFactory {

}


+ (id <ICastable>) getSpellUsingFrequency
{
    //TODO: Perhaps balance the game by changing the frequency of certain spells

    NSUInteger random = arc4random() % 6;

    return [self getSpellFromType:(spellsType)random];

}

+ (id <ICastable>)getSpellFromType:(spellsType)spellType
{
    id <ICastable> spell = nil;

    switch(spellType) {
        case kAddLine:
            spell = [[AddLine alloc]init];
            break;
        case kClearSpecial:
            spell = [[ClearSpecial alloc]init];
            break;
        case kGravity:
            spell = [[Gravity alloc]init];
            break;
        case kNuke:
            spell = [[Nuke alloc] init];
            break;
        case kRandomRemove:
            spell = [[RandomRemove alloc]init];
            break;
        case kSwitchBoard:
            spell = [[SwitchBoard alloc]init];
            break;

        default:
            spell = nil;
    }

    return spell;
}


@end