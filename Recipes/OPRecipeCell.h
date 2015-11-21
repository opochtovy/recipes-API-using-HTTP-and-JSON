//
//  OPRecipeCell.h
//  Recipes
//
//  Created by Oleg Pochtovy on 30.10.15.
//  Copyright © 2015 Oleg Pochtovy. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OPRecipe;

@interface OPRecipeCell : UICollectionViewCell

@property (strong, nonatomic) OPRecipe *recipe;

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end
