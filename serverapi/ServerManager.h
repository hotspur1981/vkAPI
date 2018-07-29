//
//  ServerManager.h
//  serverapi
//
//  Created by Vladimir Opanasenko on 10.04.2018.
//  Copyright © 2018 Vladimir Opanasenko. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ServerManager : NSObject

+ (ServerManager *)sharedManager;

- (void) getFriendsWithOffset:(NSInteger)offset
                        count:(NSInteger)count
                    onSuccess:(void(^)(NSArray* friends))success
                    onFailure:(void(^)(NSError* error))failure;

@end
