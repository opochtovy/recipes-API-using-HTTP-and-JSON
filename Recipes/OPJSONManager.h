//
//  OPJSONManager.h
//  Recipes
//
//  Created by Oleg Pochtovy on 29.10.15.
//  Copyright © 2015 Oleg Pochtovy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OPJSONManager : NSObject

// singleton
+ (OPJSONManager *)sharedManager;

- (void)getRecipesOnSuccess:(void(^)(NSArray* recipes))success
                  onFailure:(void(^)(NSError *error, NSInteger statusCode)) failure;

@end
