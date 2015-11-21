//
//  OPRecipeCell.m
//  Recipes
//
//  Created by Oleg Pochtovy on 30.10.15.
//  Copyright © 2015 Oleg Pochtovy. All rights reserved.
//

#import "OPRecipeCell.h"

#import "OPRecipe.h"

#import "OPUtils.h"

@implementation OPRecipeCell

- (id) init {
    
    self = [super init];
    
    if (self) {
        
        CGFloat width = PREVIEW_WIDTH;
        CGFloat height = PREVIEW_HEIGHT;
        
        CGFloat recipeCellOffset = retina() ? 2 * RECIPE_CELL_OFFSET : RECIPE_CELL_OFFSET;
        
        CGFloat nameLabelLeftOffset = retina() ? 2 * RECIPE_CELL_NAME_LEFT_OFFSET : RECIPE_CELL_NAME_LEFT_OFFSET;
        CGFloat nameLabelTopOffset = retina() ? (2 * RECIPE_CELL_OFFSET + height) : (RECIPE_CELL_OFFSET + height);
        
        CGRect imageViewFrame = CGRectMake(recipeCellOffset,
                                           recipeCellOffset,
                                           width,
                                           height);
        
        self.imageView.frame = imageViewFrame;
        
        CGRect nameLabelFrame = CGRectMake(nameLabelLeftOffset,
                                           nameLabelTopOffset,
                                           width - 2 * (nameLabelLeftOffset - recipeCellOffset),
                                           RECIPE_CELL_NAME_HEIGHT);
        
        self.nameLabel.frame = nameLabelFrame;
        
    }
    
    return self;
}

- (void) setRecipe:(OPRecipe *)recipe {
    
    if (_recipe != recipe) {
        
        _recipe = recipe;
    }
    
    self.activityIndicator.frame = CGRectMake(self.bounds.size.width / 2 - self.bounds.size.width / 20, self.bounds.size.height / 2 - self.bounds.size.width / 20, self.bounds.size.width / 10, self.bounds.size.width / 10);
    [self.activityIndicator startAnimating];
    
    self.nameLabel.text = _recipe.name;

    // loading previewImage

    NSString* imageName = [_recipe.ID stringByAppendingString:@"_preview.jpg"];
     
    NSString* retinaOrNon = retina() ? @"retina_previews/" : @"nonretina_previews/";
    NSString* startURL = [BASE_URL stringByAppendingString:retinaOrNon];
    
    self.imageView.image = nil;
    
    __weak OPRecipeCell* weakSelf = self;
    
    [_recipe setImage:self.imageView.image
             withName:imageName
             startURL:startURL
            onSuccess:^(UIImage *image) {
                
                weakSelf.imageView.image = image;
                
                [weakSelf.activityIndicator stopAnimating];
        
    }];

    // end of loading previewImage
    
}

@end
