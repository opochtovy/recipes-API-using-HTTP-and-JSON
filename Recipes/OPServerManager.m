//
//  OPServerManager.m
//  Recipes
//
//  Created by Oleg Pochtovy on 29.10.15.
//  Copyright © 2015 Oleg Pochtovy. All rights reserved.
//

#import "OPServerManager.h"

#import "OPRecipe.h"

@interface OPServerManager ()

@property (strong, nonatomic) NSOperationQueue* operationQueue;

@end

@implementation OPServerManager

+ (OPServerManager *)sharedManager {
    
    static OPServerManager *manager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        manager = [[OPServerManager alloc] init];
    
    });
    
    return manager;
}

// singleton for method -loadImageUsingSharedOperationQueueForURL:onSuccess:onFailure:
+ (NSOperationQueue *)sharedOperationQueue {
    
    static NSOperationQueue *operationQueue;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        operationQueue = [[NSOperationQueue alloc] init];
    });
    
    return operationQueue;
}

// singleton for method -loadImageUsingSharedGCDQueueForURL:onSuccess:onFailure:
+ (dispatch_queue_t)sharedGCDQueue {
    
    static dispatch_queue_t queue;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        queue = dispatch_queue_create("com.opochtovy.recipes.queue", DISPATCH_QUEUE_CONCURRENT);
    });
    
    return queue;
}

- (void)loadImageForURL:(NSString *) url
               onSuccess:(void(^)(UIImage *image))success
               onFailure:(void(^)(NSError *error, NSInteger statusCode)) failure {
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_async(queue, ^{
        
        NSError *error = nil;
        
        NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]
                                                  options:0
                                                    error:&error];
        
        if (error) {
            
            failure(error, error.code);
            
        } else {
            
            UIImage* image = [UIImage imageWithData:imageData];
            
            success(image);
        }
        
    });
}

- (void)loadImageUsingSharedOperationQueueForURL:(NSString *) url
                                   onSuccess:(void(^)(UIImage *image))success
                                   onFailure:(void(^)(NSError *error, NSInteger statusCode)) failure {
    
    [[OPServerManager sharedOperationQueue] addOperationWithBlock:^{
        
        NSError *error = nil;
        
        NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]
                                                  options:0
                                                    error:&error];
        
        if (error) {
            
            failure(error, error.code);
            
        } else {
            
            UIImage* image = [UIImage imageWithData:imageData];
            
            success(image);
        }
        
    }];
}

- (void)loadImageUsingSharedGCDQueueForURL:(NSString *) url
                                       onSuccess:(void(^)(UIImage *image))success
                                       onFailure:(void(^)(NSError *error, NSInteger statusCode)) failure {
    
    dispatch_async([OPServerManager sharedGCDQueue], ^{
        
        NSError *error = nil;
        
        NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]
                                                  options:0
                                                    error:&error];
        
        if (error) {
            
            failure(error, error.code);
            
        } else {
            
            UIImage* image = [UIImage imageWithData:imageData];
            
            success(image);
        }
        
    });
    
}

@end
