#import <Foundation/Foundation.h>
#import "ICastable.h"

@protocol ICastable;


@interface SpellFactory : NSObject{

}

+ (id <ICastable>)getSpellUsingFrequency;

+ (id <ICastable>)getSpellFromType:(spellsType)spellName;
@end