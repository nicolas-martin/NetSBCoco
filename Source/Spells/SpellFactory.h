#import <Foundation/Foundation.h>

@protocol ICastable;


@interface SpellFactory : NSObject{

}

+ (id <ICastable>)getSpellUsingFrequency;
@end