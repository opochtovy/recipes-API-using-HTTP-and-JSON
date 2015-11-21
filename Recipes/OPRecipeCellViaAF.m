//
//  OPRecipeCellViaAF.m
//  Recipes
//
//  Created by Oleg Pochtovy on 14.11.15.
//  Copyright © 2015 Oleg Pochtovy. All rights reserved.
//

#import "OPRecipeCellViaAF.h"
#import "OPRecipe.h"
#import "OPUtils.h"

// using AFNetworking
#import "UIImageView+AFNetworking.h"

@implementation OPRecipeCellViaAF

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
        
        self.activityIndicator.frame = CGRectMake(self.bounds.size.width / 2,
                                                           self.bounds.size.height / 2,
                                                           self.bounds.size.width / 10,
                                                           self.bounds.size.width / 10);
        
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
    
    // loading previewImage - using AFNetworking
    
    NSString* startImageName = [recipe.ID stringByAppendingString:@"_preview.jpg"];
    NSString* retinaOrNon = retina() ? @"retina_previews/" : @"nonretina_previews/";
    NSString* startURL = [BASE_URL stringByAppendingString:retinaOrNon];
    NSString* imageURLString = [NSString stringWithFormat:@"%@%@", startURL, startImageName];
    
    NSURL* imageURL;
    
    if (imageURLString) {
        
        imageURL = [NSURL URLWithString:imageURLString];
    }
    
    NSURLRequest *request = [NSURLRequest requestWithURL:imageURL];
    
    self.imageView.image = nil;
    
    __weak OPRecipeCellViaAF* weakSelf = self;
    
    [self.imageView setImageWithURLRequest:request
                          placeholderImage:nil
                                   success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image)
    {
        weakSelf.imageView.image = image;
        
        [weakSelf.activityIndicator stopAnimating];
        
    }
                                   failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error)
    {
    }];
    
    // end of loading previewImage - using AFNetworking
}

@end
