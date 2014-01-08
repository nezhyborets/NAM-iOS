//
// Created by Alexei on 03.01.14.
//

#import "NSArray+NAMAdditions.h"

@implementation NSArray (NAMAdditions)
- (NSArray *)safelyAddObject:(id)object {
    NSMutableArray *mutableArray = [self mutableCopy];

    if (!mutableArray) {
        mutableArray = [[NSMutableArray alloc] init];
    }

    [mutableArray addObject:object];
    return [mutableArray copy];
}
@end