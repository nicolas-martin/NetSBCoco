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


+ (NSString *)getFileNameFromEnum:(spellsType)spellType{
    NSString *fileName = nil;

    switch(spellType) {
        case kAddLine:
            fileName = @"Assets/s-AddLine.png";
            break;
        case kClearSpecial:
            fileName = @"Assets/s-ClearSpell.png";
            break;
        case kGravity:
            fileName = @"Assets/s-Gravity.png";
            break;
        case kNuke:
            fileName = @"Assets/s-Nuke.png";
            break;
        case kRandomRemove:
            fileName = @"Assets/s-RandomRemove.png";
            break;
        case kSwitchBoard:
            fileName = @"Assets/s-SwitchField.png";
            break;

        default:
            fileName = @"";
    }

    return fileName;
}

+ (NSString *)getNameFromEnum:(spellsType)spellType{
    NSString *spellName = nil;

    switch(spellType) {
        case kAddLine:
            spellName = @"Add line";
            break;
        case kClearSpecial:
            spellName = @"Clear Special Blocks";
            break;
        case kGravity:
            spellName = @"Gravity";
            break;
        case kNuke:
            spellName = @"Nuke";
            break;
        case kRandomRemove:
            spellName = @"Random Remove";
            break;
        case kSwitchBoard:
            spellName = @"Switch Board";
            break;

        default:
            spellName = @"";
    }

    return spellName;
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