//
//  OPRecipeStepCell.h
//  Recipes
//
//  Created by Oleg Pochtovy on 10.11.15.
//  Copyright © 2015 Oleg Pochtovy. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OPRecipeStep;
@class OPRecipe;

@interface OPRecipeStepCell : UITableViewCell

- (id)initWithStep:(OPRecipeStep* ) step
            recipe:(OPRecipe* ) recipe
             width:(CGFloat) width;

+ (CGFloat) heightForStep:(OPRecipeStep *) step
                cellWidth:(CGFloat) cellWidth;

@end
