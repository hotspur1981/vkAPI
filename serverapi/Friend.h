//
//  Friend.h
//  serverapi
//
//  Created by Vladimir Opanasenko on 10.04.2018.
//  Copyright © 2018 Vladimir Opanasenko. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Friend : NSObject

@property (strong,nonatomic) NSString* firstName;
@property (strong,nonatomic) NSString* lastName;
@property (strong,nonatomic) NSURL* imageURL;

- (instancetype) initWithDictionary:(NSDictionary*)dictionary;

@end
