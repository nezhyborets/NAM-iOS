//
// Created by Alexei on 03.01.14.
//

#import "NSArray+NAMAdditions.h"

@implementation NSArray (NAMAdditions)
- (NSArray *)safelyAddObject:(id)object {
    NSMutableArray *mutableArray = [self mutableCopy];
    [mutableArray addObject:object];
    return [mutableArray copy];
}
@end