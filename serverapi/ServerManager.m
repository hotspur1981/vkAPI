//
//  ServerManager.m
//  serverapi
//
//  Created by Vladimir Opanasenko on 10.04.2018.
//  Copyright © 2018 Vladimir Opanasenko. All rights reserved.
//

#import "ServerManager.h"
#import "AFNetworking.h"
#import "Friend.h"
#import "CoreDataManager.h"
#import "FriendEntity+CoreDataClass.h"

@interface ServerManager ()

@property (strong, nonatomic) AFHTTPSessionManager *sessionManager;

@end

@implementation ServerManager

+ (ServerManager *)sharedManager {
    static ServerManager* manager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[ServerManager alloc] init];
    });
   
    return manager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.sessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:@"https://api.vk.com/method/"]];
    }
    return self;
}

- (void) getFriendsWithOffset:(NSInteger)offset count:(NSInteger)count onSuccess:(void(^)(NSArray* friends))success onFailure:(void(^)(NSError* error))failure {
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            @"8665111", @"user_id",
                            @"name", @"order",
                            @(count), @"count",
                            @(offset), @"offset",
                            @"photo_100", @"fields",
                            @"nom", @"name_case",
                            @"5.74", @"version", nil];
    
    [self.sessionManager GET:@"friends.get" parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *responseObject) {
        NSArray *friends = [responseObject objectForKey:@"response"];
        
        NSManagedObjectContext *context = [[CoreDataManager sharedManager] context];
        
        for (NSDictionary *friendDict in friends) {
            FriendEntity *friend = [NSEntityDescription insertNewObjectForEntityForName:@"FriendEntity" inManagedObjectContext:context];
            [friend setValue:[friendDict objectForKey:@"first_name"] forKey:@"firstName"];
            [friend setValue:[friendDict objectForKey:@"last_name"] forKey:@"lastName"];
            [friend setValue:[friendDict objectForKey:@"photo_100"] forKey:@"imageURL"];
        }
        
        [context save:nil];

        if (success) {
            success(nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}


@end
