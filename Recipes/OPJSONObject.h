//
//  OPJSONObject.h
//  Recipes
//
//  Created by Oleg Pochtovy on 29.10.15.
//  Copyright © 2015 Oleg Pochtovy. All rights reserved.
//

// Parent class for all models

#import <Foundation/Foundation.h>

@interface OPJSONObject : NSObject

- (id)initWithJSONResponse:(NSDictionary *) responseObject;

@end
