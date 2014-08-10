//
// Created by Nicolas Martin on 12/8/2013.
//


#import "SpellFactory.h"
#import "ICastable.h"
#import "AddLine.h"
#import "RandomRemove.h"
#import "Nuke.h"
#import "Gravity.h"


@implementation SpellFactory {

}

- (instancetype)initWithDropAddLine
{
    self = [super init];
    if (self) {

    }

    return self;
}

+ (id <ICastable>) getSpellUsingFrequency
{
    NSMutableDictionary *spells = [NSMutableDictionary dictionary];
    [spells setValue:@25 forKey:@"Nuke"];
    [spells setValue:@25 forKey:@"RandomRemove"];
    [spells setValue:@25 forKey:@"AddLine"];
    [spells setValue:@25 forKey:@"Gravity"];


    id <ICastable> spell = nil;

    NSUInteger random = arc4random() % 100;

    for (NSString *key in spells)
    {
        NSUInteger value = [[spells valueForKey:key] unsignedIntegerValue];
        if (random > value)
        {
            random = random - value;
        }
        else
        {
            spell = [self getSpellFromName:key];
            break;
        }


    }
    return spell;

}

+ (id <ICastable>) getSpellFromName:(NSString *) spellName
{
    id <ICastable> spell = nil;

    if ([spellName isEqualToString:@"AddLine"])
    {
        spell = [[AddLine alloc]init];
    }
    else if ([spellName isEqualToString:@"RandomRemove"])
    {
        spell = [[RandomRemove alloc]init];
    }
    else if ([spellName isEqualToString:@"Nuke"])
    {
        spell = [[Nuke alloc]init];
    }
    else if ([spellName isEqualToString:@"Gravity"])
    {
        spell = [[Gravity alloc]init];
    }

    return spell;
}


@end