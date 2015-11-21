//
//  OPRecipeProfileView.h
//  Recipes
//
//  Created by Oleg Pochtovy on 01.11.15.
//  Copyright © 2015 Oleg Pochtovy. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OPRecipe;

@interface OPRecipeProfileView : UIView

@property (strong, nonatomic) UITableView* stepsTableView; // that property should be public for class OPRecipeProfileViewController (to reload table in didRotateFromInterfaceOrientation: method)

- (OPRecipeProfileView* )initWithFrame:(CGRect) rect
                                recipe:(OPRecipe* ) recipe;

- (void) countAllFrames; // that method should be public for class OPRecipeProfileViewController (to reload table in didRotateFromInterfaceOrientation: method)

@end
