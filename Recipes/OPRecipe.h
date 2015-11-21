//
//  OPRecipe.h
//  Recipes
//
//  Created by Oleg Pochtovy on 29.10.15.
//  Copyright © 2015 Oleg Pochtovy. All rights reserved.
//

#import "OPJSONObject.h"
#import <UIKit/UIKit.h>

@interface OPRecipe : OPJSONObject

@property (assign, nonatomic) NSInteger recipeIndex;

@property (strong, nonatomic) NSString* ID;
@property (strong, nonatomic) NSString* name;
@property (strong, nonatomic) NSString* recipeDescription;

@property (strong, nonatomic) NSArray* steps;

@property (assign, nonatomic) NSInteger portionsNumber;

@property (strong, nonatomic) NSString* cookingTime;
@property (strong, nonatomic) NSString* ingredients;
@property (strong, nonatomic) NSString* additionalInfo;

@property (assign, nonatomic) NSInteger complexity;

@property (strong, nonatomic) NSArray* tags;
@property (strong, nonatomic) NSArray* ingredientsList;
@property (strong, nonatomic) NSArray* dietTags;

@property (assign, nonatomic) float cookingMinutes;

//@property (strong, nonatomic) UIImage* previewImage;
//@property (strong, nonatomic) UIImage* finalImage;
//@property (strong, nonatomic) UIImage* startImage;

//@property (assign, nonatomic) float previewImageWidth;
//@property (assign, nonatomic) float previewImageHeight;

- (void) setImage:(UIImage* ) setedImage
         withName:(NSString* ) imageName
         startURL:(NSString* )  url
        onSuccess:(void (^)(UIImage* image)) success;

@end
