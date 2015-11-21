//
//  OPRecipe.m
//  Recipes
//
//  Created by Oleg Pochtovy on 29.10.15.
//  Copyright © 2015 Oleg Pochtovy. All rights reserved.
//

#import "OPRecipe.h"

#import "OPRecipeStep.h"

#import "OPUtils.h"

#import "OPServerManager.h"

@interface  OPRecipe ()

@end

@implementation OPRecipe

// public method of parent class
- (id)initWithJSONResponse:(NSDictionary *) responseObject {
    
//    self = [super init];
    self = [super initWithJSONResponse:responseObject];
    
    if (self) {
        
        self.ID = [responseObject objectForKey:@"id"];
        self.name = [responseObject objectForKey:@"name"];
        self.recipeDescription = [responseObject objectForKey:@"description"];
        
        NSArray *dictsArray = [responseObject objectForKey:@"steps"];
        
        NSMutableArray *stepsArray = [NSMutableArray array];
        
        for (NSDictionary *dict in dictsArray) {
            
            NSInteger stepIndex = [dictsArray indexOfObject:dict];
            
            OPRecipeStep *step = [[OPRecipeStep alloc] initWithJSONResponse:dict];
            step.stepIndex = stepIndex + 1;
            
            [stepsArray addObject:step];
        }
        
        self.steps = [stepsArray copy];
        
        self.portionsNumber = [[responseObject objectForKey:@"portions_number"] integerValue];
        
        self.cookingTime = [responseObject objectForKey:@"cooking_time"];
        self.ingredients = [responseObject objectForKey:@"ingredients"];
        self.additionalInfo = [responseObject objectForKey:@"additional_info"];
        
        self.complexity = [[responseObject objectForKey:@"complexity"] integerValue];
        
        self.tags = [responseObject objectForKey:@"tags"];
        self.ingredientsList = [responseObject objectForKey:@"ingredients_list"];
        self.dietTags = [responseObject objectForKey:@"tags_diet"];
        
        self.cookingMinutes = [[responseObject objectForKey:@"cooking_minutes"] floatValue];
        
    }
    
    return self;
}

- (void) setImage:(UIImage* ) setedImage
         withName:(NSString *) imageName
         startURL:(NSString *)  url
        onSuccess:(void (^)(UIImage *image)) success {
    
    // 1 stage - just checking if setedImage is in cache
    if (setedImage != nil) {
        
        NSLog(@"image %@ is in cache", imageName);
        
        success(setedImage);
        
        return;
    }
    
    // 2 stage - if image was already saved locally just take it from file
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString* documentsDirectory = [paths objectAtIndex:0];
//    NSLog(@"documentsDirectory = %@", documentsDirectory);
    
    NSString* dataPath = [documentsDirectory stringByAppendingPathComponent: imageName];
    
    NSData* data = [NSData dataWithContentsOfFile:dataPath];
    
    if (data) {
        
        NSLog(@"image %@ was loaded from file", imageName);
        
        setedImage = [UIImage imageWithData:data];
        
        success(setedImage);
        
        return;
        
    }
    
    // 3 stage - download image from server, save it locally and transmit image
    
    // check for retina/nonretina
    NSString* imageURL = [NSString stringWithFormat:@"%@%@", url, imageName];
    
    __block __weak UIImage* weakSetedImage = setedImage;
    
    // 1 way - using first method from OPServerManager

    [[OPServerManager sharedManager]
     loadImageForURL:imageURL
     onSuccess:^(UIImage *image)
     {
         dispatch_sync(dispatch_get_main_queue(), ^{
             
             NSLog(@"image %@ was loaded from SERVER", imageName);
             
             weakSetedImage = image;
             
             NSData* data = UIImageJPEGRepresentation(image, 1.0);
             
             // need to write to documents folder
             [data writeToFile:dataPath atomically:YES];
             
             success(weakSetedImage);
             
         });
         
     }
     onFailure:^(NSError *error, NSInteger statusCode)
     {
         
     }];

    // end of 1 way
    
    // 2 way - using second method from OPServerManager
/*
    [[OPServerManager sharedManager]
     loadImageUsingSharedOperationQueueForURL:imageURL
     onSuccess:^(UIImage *image)
     {
         dispatch_sync(dispatch_get_main_queue(), ^{
             
             weakSetedImage = image;
             
             NSData* data = UIImageJPEGRepresentation(image, 1.0);
             
             // need to write to documents folder
             [data writeToFile:dataPath atomically:YES];
             
             success(weakSetedImage);
 
         });
         
     }
     onFailure:^(NSError *error, NSInteger statusCode)
     {
         
     }];
*/
    // end of 2 way
    
    // 3 way - using third method from OPServerManager
/*
    [[OPServerManager sharedManager]
     loadImageUsingSharedGCDQueueForURL:imageURL
     onSuccess:^(UIImage *image)
     {
         dispatch_sync(dispatch_get_main_queue(), ^{
             
             weakSetedImage = image;
             
             NSData* data = UIImageJPEGRepresentation(image, 1.0);
             
             // need to write to documents folder
             [data writeToFile:dataPath atomically:YES];
             
             success(weakSetedImage);
         });
         
     }
     onFailure:^(NSError *error, NSInteger statusCode)
     {
         
     }];
*/
    // end of 3 way
}

@end
