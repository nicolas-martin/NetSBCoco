#import <Foundation/Foundation.h>

@protocol ICastable;


@interface SpellFactory : NSObject{

}

@property (readonly) NSUInteger * dropAddLine;
@property (readonly) NSUInteger * dropRandomRemove;
@property (readonly) NSUInteger * dropNuke;
@property (readonly) NSUInteger * dropSwap;
@property (readonly) NSUInteger * dropFillGap;


- (instancetype)initWithDropAddLine;

+ (instancetype)managerWithDropAddLine;

+ (id <ICastable>)getSpellUsingFrequency;
@end