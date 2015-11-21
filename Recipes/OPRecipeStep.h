//
//  OPRecipeStep.h
//  Recipes
//
//  Created by Oleg Pochtovy on 29.10.15.
//  Copyright © 2015 Oleg Pochtovy. All rights reserved.
//

#import "OPJSONObject.h"

#import <UIKit/UIKit.h>

@interface OPRecipeStep : OPJSONObject

@property (strong, nonatomic) NSString* stepDescription;

@property (assign, nonatomic) NSInteger stepTime;

@property (assign, nonatomic) NSInteger stepIndex;

@end
