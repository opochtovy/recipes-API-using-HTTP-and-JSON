//
//  OPRecipeStep.m
//  Recipes
//
//  Created by Oleg Pochtovy on 29.10.15.
//  Copyright © 2015 Oleg Pochtovy. All rights reserved.
//

#import "OPRecipeStep.h"

@implementation OPRecipeStep

- (id)initWithJSONResponse:(NSDictionary *) responseObject {
    
//    self = [super init];
    self = [super initWithJSONResponse:responseObject];
    
    if (self) {
        
        self.stepDescription = [responseObject objectForKey:@"description"];
        self.stepTime = [[responseObject objectForKey:@"step_time"] integerValue];
        
    }
    
    return self;
}

@end
