//
//  OPServerManager.h
//  Recipes
//
//  Created by Oleg Pochtovy on 29.10.15.
//  Copyright © 2015 Oleg Pochtovy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class OPRecipe;

@interface OPServerManager : NSObject

// singleton
+ (OPServerManager *)sharedManager;

// different ways how to load image asynchronously using GCD or NSOperationQueue

- (void)loadImageForURL:(NSString *) url
              onSuccess:(void(^)(UIImage *image))success
              onFailure:(void(^)(NSError *error, NSInteger statusCode)) failure;

- (void)loadImageUsingSharedOperationQueueForURL:(NSString *) url
              onSuccess:(void(^)(UIImage *image))success
              onFailure:(void(^)(NSError *error, NSInteger statusCode)) failure;

- (void)loadImageUsingSharedGCDQueueForURL:(NSString *) url
                                 onSuccess:(void(^)(UIImage *image))success
                                 onFailure:(void(^)(NSError *error, NSInteger statusCode)) failure;

@end
