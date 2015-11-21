//
//  OPRecipeStepCell.m
//  Recipes
//
//  Created by Oleg Pochtovy on 10.11.15.
//  Copyright © 2015 Oleg Pochtovy. All rights reserved.
//

#import "OPRecipeStepCell.h"

#import "OPRecipe.h"
#import "OPRecipeStep.h"

#import "OPUtils.h"

@interface OPRecipeStepCell ()

@property (strong, nonatomic) OPRecipe* recipe;

@property (strong, nonatomic) OPRecipeStep* recipeStep;

@property (assign, nonatomic) CGFloat cellWidth;

@property (strong, nonatomic) UIImageView* stepImageView;
@property (strong, nonatomic) UILabel* stepNumberLabel;
@property (strong, nonatomic) UIImageView* stepTimeImageView;

@property (strong, nonatomic) UILabel* descriptionLabel;

@property (strong, nonatomic) UIActivityIndicatorView *activityIndicatorForStepImage;

@end

@implementation OPRecipeStepCell

static CGFloat offset = 10.0;

static CGFloat sizeOfFont = 14.0;

static CGFloat sizeOfStepNumberFont = 30.0;

- (id)initWithStep:(OPRecipeStep* ) step
            recipe:(OPRecipe* ) recipe
             width:(CGFloat) width {
    
    self = [super init];
    
    if (self) {
        
        self.recipeStep = step;
        self.cellWidth = width;
        self.recipe = recipe;
        
        self.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.2f];
        
        [self countAllFrames];
        
    }
    
    return self;
}

#pragma mark - Private Methods

- (void) countAllFrames {
    
    UIFont *font = [UIFont systemFontOfSize:sizeOfFont];
    UIFont *stepNumberFont = [UIFont systemFontOfSize:sizeOfStepNumberFont];
    
    // stepImageView
    
    CGFloat stepImageViewWidth = (self.cellWidth - 2 * offset) * 3 / 5;
    
    CGFloat actualWidth = retina() ? RETINA_STEP_WIDTH : NONRETINA_STEP_WIDTH;
    CGFloat actualHeight = retina() ? RETINA_STEP_HEIGHT : NONRETINA_STEP_HEIGHT;
    
    CGFloat stepImageWidth = MIN(stepImageViewWidth, actualWidth);
    CGFloat stepImageHeight = (stepImageWidth * actualHeight) / actualWidth;
    
    CGRect stepImageViewFrame = CGRectMake(0,
                                            0,
                                            stepImageWidth,
                                            stepImageHeight);
    
    self.stepImageView = [[UIImageView alloc] initWithFrame:stepImageViewFrame];
    
    [self addSubview:self.stepImageView];
    
    CGRect activityIndicatorForStepImageFrame = CGRectMake(stepImageWidth / 2 - stepImageWidth / 10,
                                                             stepImageHeight / 2 - stepImageWidth / 10,
                                                             stepImageWidth / 5,
                                                             stepImageWidth / 5);

    self.activityIndicatorForStepImage = [[UIActivityIndicatorView alloc] initWithFrame:activityIndicatorForStepImageFrame];
    
    self.activityIndicatorForStepImage.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    self.activityIndicatorForStepImage.hidesWhenStopped = YES;
    
    self.activityIndicatorForStepImage.backgroundColor = [UIColor lightGrayColor];
    
    [self addSubview:self.activityIndicatorForStepImage];
    
    [self.activityIndicatorForStepImage startAnimating];
    
    // loading stepImage
    
    NSString* stepImageName = [self.recipe.ID stringByAppendingFormat:@"_step_%li.jpg", (long)self.recipeStep.stepIndex];
    
    NSString* retinaOrNon = retina() ? @"retina/" : @"nonretina/";
    
    NSString* startURL = [BASE_URL stringByAppendingString:retinaOrNon];
    
    __weak OPRecipeStepCell* weakSelf = self;
    
    [self.recipe setImage:self.stepImageView.image
                 withName:stepImageName
                 startURL:startURL
                onSuccess:^(UIImage *image) {
                    
                    weakSelf.stepImageView.image = image;
                    
                    [weakSelf.activityIndicatorForStepImage stopAnimating];
                    
                }];

    // end of loading stepImage
    
    // stepNumberLabel
    
    CGFloat stepNumberLabelWidth = sizeOfStepNumberFont;
    
    NSString* stepNumberString = [NSString stringWithFormat:@"%li", (long)self.recipeStep.stepIndex];
    
    CGRect stepNumberLabelRect = [OPRecipeStepCell countRectForText:stepNumberString
                                                            forWidth:stepNumberLabelWidth
                                                             forFont:stepNumberFont];
    
    stepNumberLabelWidth = MAX(sizeOfStepNumberFont, stepNumberLabelRect.size.width + 2 * offset);
    
    CGFloat stepNumberLabelLeftOffset = stepImageWidth - stepNumberLabelWidth;
    
    CGRect stepNumberLabelFrame = CGRectMake(stepNumberLabelLeftOffset,
                                              0,
                                              stepNumberLabelWidth,
                                              stepNumberLabelWidth);
    
    self.stepNumberLabel = [[UILabel alloc] initWithFrame:stepNumberLabelFrame];
    
    self.stepNumberLabel.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5];
    
    self.stepNumberLabel.font = stepNumberFont;
    self.stepNumberLabel.textAlignment = NSTextAlignmentCenter;
    
    self.stepNumberLabel.text = stepNumberString;
    
    [self.stepImageView addSubview:self.stepNumberLabel];
    
    // stepTimeImageView
    
    if (self.recipeStep.stepTime) {
        
        CGFloat stepTimeImageViewTopOffset = stepNumberLabelFrame.origin.y + stepNumberLabelFrame.size.height;
        
        CGRect stepTimeImageViewFrame = CGRectMake(stepNumberLabelLeftOffset,
                                                   stepTimeImageViewTopOffset,
                                                   stepNumberLabelWidth,
                                                   stepNumberLabelWidth);
        
        self.stepTimeImageView = [[UIImageView alloc] initWithFrame:stepTimeImageViewFrame];
        
        self.stepTimeImageView.image = [UIImage imageNamed:@"step_time"];
        self.stepTimeImageView.contentMode = UIViewContentModeCenter;
        
        [self.stepImageView addSubview:self.stepTimeImageView];
        
    }
    
    // self.descriptionLabel
    
    CGFloat descriptionLabelWidth = (self.cellWidth - 2 * offset) * 2 / 5;
    
    CGFloat descriptionLabelLeftOffset = stepImageWidth + offset;
    
    CGRect descriptionLabelRect = [OPRecipeStepCell countRectForText:self.recipeStep.stepDescription
                                                forWidth:descriptionLabelWidth
                                                 forFont:font];
    
    CGRect descriptionLabelFrame = CGRectMake(descriptionLabelLeftOffset,
                                              0,
                                              descriptionLabelWidth,
                                              descriptionLabelRect.size.height);
    
    self.descriptionLabel = [[UILabel alloc] initWithFrame:descriptionLabelFrame];
    
    self.descriptionLabel.numberOfLines = 0;
    self.descriptionLabel.font = font;
    
    self.descriptionLabel.text = self.recipeStep.stepDescription;
    
    [self addSubview:self.descriptionLabel];
    
}

+ (CGRect) countRectForText:(NSString *) text forWidth:(CGFloat) width forFont:(UIFont *) font {
    
    NSDictionary *attributes = [OPRecipeStepCell attributesForTextWithFont:font];
    
    CGRect rect = [text boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX)
                                     options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                  attributes:attributes
                                     context:nil];
    
    return rect;
}

+ (NSDictionary *) attributesForTextWithFont:(UIFont *) font {
    
    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowOffset = CGSizeMake(1, 1);
    shadow.shadowColor = [UIColor whiteColor];
    shadow.shadowBlurRadius = 0.5;
    
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    [paragraph setLineBreakMode:NSLineBreakByWordWrapping];
    [paragraph setAlignment:NSTextAlignmentJustified];
    
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                [UIColor grayColor], NSForegroundColorAttributeName,
                                font, NSFontAttributeName,
                                shadow, NSShadowAttributeName,
                                paragraph, NSParagraphStyleAttributeName, nil];
    return attributes;
}


+ (CGFloat) heightForStep:(OPRecipeStep *) step
                cellWidth:(CGFloat) cellWidth {
    
    UIFont *font = [UIFont systemFontOfSize:sizeOfFont];
    
    CGFloat heightForStep = offset;
    
    // self.imageView
    
    CGFloat stepImageViewWidth = (cellWidth - 2 * offset) * 3 / 5;
    
    CGFloat actualWidth = retina() ? RETINA_STEP_WIDTH : NONRETINA_STEP_WIDTH;
    CGFloat actualHeight = retina() ? RETINA_STEP_HEIGHT : NONRETINA_STEP_HEIGHT;
    
    CGFloat stepImageWidth = MIN(stepImageViewWidth, actualWidth);
    CGFloat stepImageHeight = (stepImageWidth * actualHeight) / actualWidth;
    
    // self.descriptionLabel
    
//    CGFloat descriptionLabelWidth = (cellWidth - 2 * offset) * 2 / 5;
    CGFloat descriptionLabelWidth = cellWidth - 2 * offset - stepImageWidth;
    
    CGRect descriptionLabelRect = [OPRecipeStepCell countRectForText:step.stepDescription
                                                            forWidth:descriptionLabelWidth
                                                             forFont:font];
    
    // what is more - stepImageHeight or CGRectGetHeight(descriptionLabelRect)
    CGFloat maxHeight = MAX(stepImageHeight, CGRectGetHeight(descriptionLabelRect));
    
    heightForStep += maxHeight + offset;
    
    return heightForStep;
}

@end
