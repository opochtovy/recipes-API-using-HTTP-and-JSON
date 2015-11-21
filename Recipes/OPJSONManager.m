//
//  OPJSONManager.m
//  Recipes
//
//  Created by Oleg Pochtovy on 29.10.15.
//  Copyright © 2015 Oleg Pochtovy. All rights reserved.
//

#import "OPJSONManager.h"

#import "OPRecipe.h"

#import "OPUtils.h"

@implementation OPJSONManager

+ (OPJSONManager *)sharedManager {
    
    static OPJSONManager *manager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        manager = [[OPJSONManager alloc] init];
        
    });
    
    return manager;
}

- (void)getRecipesOnSuccess:(void(^)(NSArray* recipes))success
                  onFailure:(void(^)(NSError *error, NSInteger statusCode)) failure {
    
    NSString* filePath = [[NSBundle mainBundle]
                           pathForResource:JSON_FILE_NAME
                           ofType:@"pack"];
    
    NSData* jsonData = [NSData dataWithContentsOfFile:filePath];
    
    NSError *error = nil;
    NSDictionary *resultDict = nil;
    
    if (jsonData) {
        
        resultDict = [NSJSONSerialization JSONObjectWithData:jsonData
                                                  options:kNilOptions
                                                    error:&error];
        
        if (error) {
            
            NSLog(@"[%@ %@] JSON error: %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), error.localizedDescription);
        }
        
        NSArray *dictsArray = [resultDict objectForKey:@"recipes"];
        
        NSMutableArray *recipesArray = [NSMutableArray array];
        
        for (NSDictionary *dict in dictsArray) {
            
            OPRecipe *recipe = [[OPRecipe alloc] initWithJSONResponse:dict];
            
            [recipesArray addObject:recipe];
        }
        
        if (success) {
            success([recipesArray copy]); // если все прошло удачно (без ошибок) то мы передаем полученный объект
        }
    }
    
}

@end
