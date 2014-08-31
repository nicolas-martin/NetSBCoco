#import <Foundation/Foundation.h>
#import "ICastable.h"

@protocol ICastable;


@interface SpellFactory : NSObject{

}

+ (id <ICastable>)getSpellUsingFrequency;

+ (NSString *)getFileNameFromEnum:(spellsType)spellType;

+ (NSString *)getNameFromEnum:(spellsType)spellType;

+ (id <ICastable>)getSpellFromType:(spellsType)spellName;
@end