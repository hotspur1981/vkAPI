//
//  Friend.m
//  serverapi
//
//  Created by Vladimir Opanasenko on 10.04.2018.
//  Copyright © 2018 Vladimir Opanasenko. All rights reserved.
//

#import "Friend.h"

@implementation Friend

- (instancetype)initWithDictionary:(NSDictionary*)dictionary
{
    self = [super init];
    if (self) {
        self.firstName = [dictionary objectForKey:@"first_name"];
        self.lastName = [dictionary objectForKey:@"last_name"];
        
        NSString* stringURL = [dictionary objectForKey:@"photo_100"];
        if (stringURL) {
            self.imageURL = [NSURL URLWithString:stringURL];
        }

    }
    return self;
}


@end
