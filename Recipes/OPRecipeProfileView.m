//
//  OPRecipeProfileView.m
//  Recipes
//
//  Created by Oleg Pochtovy on 01.11.15.
//  Copyright © 2015 Oleg Pochtovy. All rights reserved.
//

// Custom view

#import "OPRecipeProfileView.h"

#import "OPRecipe.h"
#import "OPRecipeStep.h"

#import "OPUtils.h"

#import "OPRecipeStepCell.h"

@interface OPRecipeProfileView () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) OPRecipe* recipe;

@property (strong, nonatomic) UIScrollView* scrollView;

@property (strong, nonatomic) UIView* leftView;

@property (strong, nonatomic) UIImageView* cookingTimeImageView;
@property (strong, nonatomic) UILabel* cookingTimeLabel;
@property (strong, nonatomic) UIImageView* portionsNumberImageView;
@property (strong, nonatomic) UILabel* portionsNumberLabel;
@property (strong, nonatomic) UIView* cookingTimeView;
@property (strong, nonatomic) UIImageView* startImageView;
@property (strong, nonatomic) UIActivityIndicatorView *activityIndicatorForStartImage;
@property (strong, nonatomic) UILabel* ingredientsLabel;
@property (strong, nonatomic) UIView* ingredientsView;

@property (strong, nonatomic) UIView* rightView;

@property (strong, nonatomic) UIImageView* finalImageView;
@property (strong, nonatomic) UIActivityIndicatorView *activityIndicatorForFinalImage;
@property (strong, nonatomic) UILabel* nameLabel;
@property (strong, nonatomic) UIView* nameView;
@property (strong, nonatomic) UIImageView* howToCookImageView;
@property (strong, nonatomic) UIButton *howToCookButton;
@property (strong, nonatomic) UIView* howToCookView;

@property (strong, nonatomic) UIView* disablingButtonView;

@property (assign, nonatomic) BOOL wasPressed;

@property (assign, nonatomic) CGFloat stepsTableWidth;

@property (strong, nonatomic) NSArray *heightsOfCellsForStepsTableView;

@property (strong, nonatomic) NSArray *stepsArray;
@property (strong, nonatomic) NSDictionary *stepImagesDict;

@end

@implementation OPRecipeProfileView

static CGFloat fontOfSize = 14.0;
static CGFloat sizeOfHeaderFont = 28.0;

static CGFloat offset = 10.0;
//static CGFloat topBarHeight = 20.0;
//static CGFloat navBarHeight = 44.0;
//static CGFloat tabBarHeight = 44.0;
static CGFloat allBarsHeight = 108.0;

static CGFloat cookingTimeImageWidth = 50.0;
static CGFloat cookingTimeImageHeight = 32.0;

static CGFloat howToCookImageSize = 41.0;

- (OPRecipeProfileView* )initWithFrame:(CGRect)rect recipe:(OPRecipe* ) recipe {
    
    self = [super initWithFrame:rect];
    
    if (self) {
        
        self.recipe = recipe;
        
        self.stepsArray = recipe.steps;
        
        self.heightsOfCellsForStepsTableView = [NSArray array];
        
        self.stepImagesDict = [NSDictionary dictionary];
        
        // ======== subViews for leftView ========
        
        self.leftView = [[UIView alloc] init];
        [self addSubview:self.leftView];
        
        self.cookingTimeView = [[UIView alloc] init];
        [self.leftView addSubview:self.cookingTimeView];
        
        self.cookingTimeImageView = [[UIImageView alloc] init];
        [self.cookingTimeView addSubview:self.cookingTimeImageView];
        
        self.cookingTimeLabel = [[UILabel alloc] init];
        [self.cookingTimeView addSubview:self.cookingTimeLabel];
        
        self.portionsNumberImageView = [[UIImageView alloc] init];
        [self.cookingTimeView addSubview:self.portionsNumberImageView];
        
        self.portionsNumberLabel = [[UILabel alloc] init];
        [self.cookingTimeView addSubview:self.portionsNumberLabel];
        
        self.startImageView = [[UIImageView alloc] init];
        [self.leftView addSubview:self.startImageView];
        
        self.ingredientsView = [[UIView alloc] init];
        [self.leftView addSubview:self.ingredientsView];
        
        self.ingredientsLabel = [[UILabel alloc] init];
        [self.ingredientsView addSubview:self.ingredientsLabel];
        
        self.activityIndicatorForStartImage = [[UIActivityIndicatorView alloc] init];
        [self.startImageView addSubview:self.activityIndicatorForStartImage];
        
        // ======== subViews for rightView ========
        
        self.rightView = [[UIView alloc] init];
        [self addSubview:self.rightView];
        
        self.finalImageView = [[UIImageView alloc] init];
        [self.rightView addSubview:self.finalImageView];
        
        self.nameView = [[UIView alloc] init];
        [self.rightView addSubview:self.nameView];
        
        self.nameLabel = [[UILabel alloc] init];
        [self.nameView addSubview:self.nameLabel];
        
        self.howToCookView = [[UIView alloc] init];
        [self.rightView addSubview:self.howToCookView];
        
        self.howToCookImageView = [[UIImageView alloc] init];
        [self.howToCookView addSubview:self.howToCookImageView];
        
        self.howToCookButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.howToCookView addSubview:self.howToCookButton];
        
        [self.howToCookButton addTarget:self action:@selector(actionShowStepsOfCooking:) forControlEvents:UIControlEventTouchUpInside];
        
        self.activityIndicatorForFinalImage = [[UIActivityIndicatorView alloc] init];
        [self.finalImageView addSubview:self.activityIndicatorForFinalImage];
        
        self.stepsTableView = [[UITableView alloc] init];
        [self.rightView addSubview:self.stepsTableView];
        
        self.stepsTableView.dataSource = self;
        self.stepsTableView.delegate = self;
        
        self.disablingButtonView = [[UIView alloc] init];
        [self.howToCookView addSubview:self.disablingButtonView];
        
        // ========
        
        [self countAllFrames];
    }
    
    return self;
}

#pragma mark - Private Methods

- (void) countAllFrames {
    
    UIFont *font = [UIFont systemFontOfSize:fontOfSize];
    UIFont *boldFont = [UIFont boldSystemFontOfSize:fontOfSize];
    UIFont *headerFont = [UIFont boldSystemFontOfSize:sizeOfHeaderFont];
    
    CGFloat leftViewWidth = (self.frame.size.width - 3 * offset) * 2 / 5;
    CGFloat rightViewWidth = (self.frame.size.width - 3 * offset) * 3 / 5;
    
    self.stepsTableWidth = rightViewWidth;
    
    // all subViews of leftView
    
    // cookingTimeImageView in cookingTimeView
    
    CGFloat cookingTimeImageViewTopOffset = offset;
    
    CGRect cookingTimeImageViewFrame = CGRectMake(offset,
                                            cookingTimeImageViewTopOffset,
                                            cookingTimeImageWidth,
                                            cookingTimeImageHeight);
    
    self.cookingTimeImageView.frame = cookingTimeImageViewFrame;
    
    self.cookingTimeImageView.image = [UIImage imageNamed:@"cooking_time"];
    self.cookingTimeImageView.contentMode = UIViewContentModeCenter;
    
    // cookingTimeLabel in cookingTimeView
    
    CGFloat cookingTimeLabelTopOffset = offset; // the same as cookingTimeImageViewTopOffset
    
    CGFloat cookingTimeRectWidth = leftViewWidth - 2 * offset - cookingTimeImageWidth - offset;
    
    CGRect cookingTimeRect = [self countRectForText:self.recipe.cookingTime
                                           forWidth:cookingTimeRectWidth
                                            forFont:font];
    
    if (cookingTimeRect.size.height < cookingTimeImageHeight) {
        
        cookingTimeLabelTopOffset += (cookingTimeImageHeight - cookingTimeRect.size.height) / 2;
    }
    
    CGRect cookingTimeLabelFrame = CGRectMake(offset + cookingTimeImageWidth + offset,
                                              cookingTimeLabelTopOffset,
                                              cookingTimeRectWidth,
                                              cookingTimeRect.size.height);
    
    self.cookingTimeLabel.frame = cookingTimeLabelFrame;
    
    self.cookingTimeLabel.numberOfLines = 0;
    self.cookingTimeLabel.text = self.recipe.cookingTime;
    self.cookingTimeLabel.font = boldFont;
    
    CGFloat maxHeightForCookingTime = MAX(cookingTimeImageHeight, cookingTimeRect.size.height);
    
    // portionsNumberImageView in cookingTimeView
    
    CGFloat portionsNumberImageViewTopOffset = cookingTimeLabelTopOffset + maxHeightForCookingTime + offset;
    
    CGRect portionsNumberImageViewFrame = CGRectMake(offset,
                                                  portionsNumberImageViewTopOffset,
                                                  cookingTimeImageWidth,
                                                  cookingTimeImageHeight);
    
    self.portionsNumberImageView.frame = portionsNumberImageViewFrame;
    
    self.portionsNumberImageView.image = [UIImage imageNamed:@"portions_number"];
    self.portionsNumberImageView.contentMode = UIViewContentModeCenter;
    
    // portionsNumberLabel in cookingTimeView
    
    CGFloat portionsNumberLabelTopOffset = portionsNumberImageViewTopOffset;
    
    CGFloat portionsNumberRectWidth = cookingTimeRectWidth;
    
    NSString* portionsNumberText;
    NSString *endString;
    
    switch (self.recipe.portionsNumber) {
        case 1:
            endString = @"порция";
            break;
            
        case 2:
            endString = @"порции";
            break;
            
        case 3:
            endString = @"порции";
            break;
            
        case 4:
            endString = @"порции";
            break;
            
        default:
            endString = @"порций";
            break;
    }
    
    portionsNumberText = [NSString stringWithFormat:@"%li %@", (long)self.recipe.portionsNumber, endString];
    
    CGRect portionsNumberRect = [self countRectForText:portionsNumberText
                                              forWidth:portionsNumberRectWidth
                                               forFont:font];
    
    if (portionsNumberRect.size.height < cookingTimeImageHeight) {
        
        portionsNumberLabelTopOffset += (cookingTimeImageHeight - portionsNumberRect.size.height) / 2;
    }
    
    CGRect portionsNumberLabelFrame = CGRectMake(offset + cookingTimeImageWidth + offset,
                                              portionsNumberLabelTopOffset,
                                              portionsNumberRectWidth,
                                              portionsNumberRect.size.height);
    
    self.portionsNumberLabel.frame = portionsNumberLabelFrame;
    
    self.portionsNumberLabel.numberOfLines = 0;
    self.portionsNumberLabel.text = portionsNumberText;
    self.portionsNumberLabel.font = boldFont;
    
    CGFloat maxHeightForPortionsNumber = MAX(cookingTimeImageHeight, portionsNumberRect.size.height);
    
    // cookingTimeView in leftView
    
    CGFloat cookingTimeViewFrameHeight = portionsNumberImageViewTopOffset + maxHeightForPortionsNumber + offset;
    
    CGRect cookingTimeViewFrame = CGRectMake(0,
                                             0,
                                             leftViewWidth,
                                             cookingTimeViewFrameHeight);
    
    self.cookingTimeView.frame = cookingTimeViewFrame;
    
    self.cookingTimeView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5f];
    
    // startImageView
    
    CGFloat startImageViewTopOffset = cookingTimeViewFrame.size.height + offset / 2;
    
    CGFloat startImageWidth = leftViewWidth - 2 * offset;
    
    CGFloat defaultStartWidth = retina() ? RETINA_START_WIDTH : NONRETINA_START_WIDTH;
    startImageWidth = MIN(startImageWidth, defaultStartWidth);
    
    CGFloat defaultStartHeight = retina() ? RETINA_START_HEIGHT : NONRETINA_START_HEIGHT;
    CGFloat startImageHeight = (startImageWidth * defaultStartHeight) / defaultStartWidth;
    
    CGRect startImageViewFrame = CGRectMake(offset,
                                           startImageViewTopOffset,
                                           startImageWidth,
                                           startImageHeight);
    
    self.startImageView.frame = startImageViewFrame;
    
    // ingredientsLabel in ingredientsView
    
    CGFloat ingredientsLabelTopOffset = offset;
    
    CGFloat ingredientsRectWidth = leftViewWidth - 2 * offset;
    
    // first set "-"
    NSString* ingredientsText = self.recipe.ingredients;
    
    ingredientsText = [ingredientsText stringByReplacingOccurrencesOfString:@"\n" withString:@"\n- "];
    
    NSMutableString* mutableIngredientsText = [ingredientsText mutableCopy];
    [mutableIngredientsText insertString:@"ИНГРЕДИЕНТЫ:\n- " atIndex:0];
    
    ingredientsText = [mutableIngredientsText copy];
    
    CGRect ingredientsRect = [self countRectForText:ingredientsText
                                           forWidth:ingredientsRectWidth
                                            forFont:font];
    
    CGRect ingredientsLabelFrame = CGRectMake(offset,
                                              ingredientsLabelTopOffset,
                                              ingredientsRectWidth,
                                              ingredientsRect.size.height);
    
    self.ingredientsLabel.frame = ingredientsLabelFrame;
    
    self.ingredientsLabel.numberOfLines = 0;
    self.ingredientsLabel.text = ingredientsText;
    self.ingredientsLabel.font = font;
    
    // ingredientsView in leftView
    
    CGFloat ingredientsViewTopOffset = startImageViewTopOffset + startImageViewFrame.size.height;
    
    CGFloat ingredientsViewFrameHeight = offset + ingredientsRect.size.height + offset;
    
    CGRect ingredientsViewFrame = CGRectMake(0,
                                             ingredientsViewTopOffset,
                                             leftViewWidth,
                                             ingredientsViewFrameHeight);
    
    self.ingredientsView.frame = ingredientsViewFrame;
    
    self.ingredientsView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5f];
    
    // leftView and adding all subViews to it
    
    self.leftView.frame = CGRectMake(0,
                                     offset,
                                     leftViewWidth,
                                     ingredientsViewTopOffset + ingredientsViewFrame.size.height);
    
    self.leftView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.2f];
    
    self.activityIndicatorForStartImage.frame = CGRectMake(startImageWidth / 2 - startImageWidth / 20,
                                                      startImageHeight / 2 - startImageWidth / 20,
                                                      startImageWidth / 10,
                                                      startImageWidth / 10);
    self.activityIndicatorForStartImage.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    self.activityIndicatorForStartImage.hidesWhenStopped = YES;
    
    [self.activityIndicatorForStartImage startAnimating];
    
    // loading startImage

    NSString* startImageName = [self.recipe.ID stringByAppendingString:@"_start.jpg"];
    
    NSString* retinaOrNon = retina() ? @"retina/" : @"nonretina/";
    
    NSString* startURL = [BASE_URL stringByAppendingString:retinaOrNon];
    
    __weak OPRecipeProfileView* weakSelf = self;
    
    [self.recipe setImage:self.startImageView.image
                 withName:startImageName
                 startURL:startURL
                onSuccess:^(UIImage *image) {
                    
                    weakSelf.startImageView.image = image;
                    
                    [weakSelf.activityIndicatorForStartImage stopAnimating];
                    
                }];

    // end of loading startImage
    
    // all subViews of rightView
    
    // finalImageView in rightView
    
    CGFloat finalImageViewTopOffset = 0;
    
    CGFloat defaultFinalWidth = retina() ? RETINA_FINAL_WIDTH : NONRETINA_FINAL_WIDTH;
    CGFloat finalImageWidth = MIN(rightViewWidth, defaultFinalWidth);
    
    CGFloat defaultFinalHeight = retina() ? RETINA_FINAL_HEIGHT : NONRETINA_FINAL_HEIGHT;
    CGFloat finalImageHeight = (finalImageWidth * defaultFinalHeight) / defaultFinalWidth;
    
    CGRect finalImageViewFrame = CGRectMake(0,
                                            finalImageViewTopOffset,
                                            finalImageWidth,
                                            finalImageHeight);
    
    self.finalImageView.frame = finalImageViewFrame;
    
    // nameLabel in nameView
    
    CGFloat nameLabelTopOffset = offset;
    
    CGFloat nameRectWidth = rightViewWidth - 2 * offset;
    
    NSString* nameText = [self.recipe.name uppercaseString];
    
    CGRect nameRect = [self countRectForText:nameText
                                           forWidth:nameRectWidth
                                            forFont:headerFont];
    
    CGRect nameLabelFrame = CGRectMake(offset,
                                       nameLabelTopOffset,
                                       nameRectWidth,
                                       nameRect.size.height);
    
    self.nameLabel.frame = nameLabelFrame;
    
    self.nameLabel.numberOfLines = 0;
    self.nameLabel.text = nameText;
    self.nameLabel.font = headerFont;
    
    // nameView in rightView
    
    CGFloat nameViewTopOffset = finalImageViewTopOffset;
    
    CGFloat nameViewFrameHeight = offset + nameRect.size.height + offset;
    
    CGRect nameViewFrame = CGRectMake(0,
                                      nameViewTopOffset,
                                      finalImageWidth,
                                      nameViewFrameHeight);
    
    self.nameView.frame = nameViewFrame;
    
    self.nameView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5f];
    
    // howToCookImageView in howToCookView
    
    CGRect howToCookImageViewFrame = CGRectMake(offset,
                                                offset,
                                                howToCookImageSize,
                                                howToCookImageSize);
    
    self.howToCookImageView.frame = howToCookImageViewFrame;
    
    self.howToCookImageView.image = [UIImage imageNamed:@"how_to_cook"];
    
    // howToCookButton in howToCookView
    
    NSString *howToCookButtonTitle = @"КАК ГОТОВИТЬ";
    
    [self.howToCookButton setTitle:howToCookButtonTitle forState:UIControlStateNormal];
    
    [self.howToCookButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    self.howToCookButton.titleLabel.font = boldFont;
    
    CGRect howToCookButtonRect = [self countRectForText:howToCookButtonTitle
                                               forWidth:finalImageWidth
                                                forFont:boldFont];
    
    self.howToCookButton.frame = CGRectMake(offset + howToCookImageSize + offset,
                                       offset,
                                       howToCookButtonRect.size.width + 2 * offset,
                                       howToCookImageSize);
    
    // howToCookView in rightView
    
    CGFloat howToCookViewWidth = offset + howToCookImageViewFrame.size.width + offset + self.howToCookButton.frame.size.width + offset;
    CGFloat howToCookViewHeight = offset + howToCookImageViewFrame.size.height + offset ;
    
    CGFloat howToCookViewLeftOffset = finalImageWidth - howToCookViewWidth - 2 * offset;
    CGFloat howToCookViewTopOffset = finalImageHeight - howToCookViewHeight - 2 * offset; // 50 - button height
    
    CGRect howToCookViewFrame = CGRectMake(howToCookViewLeftOffset,
                                           howToCookViewTopOffset,
                                           howToCookViewWidth,
                                           howToCookViewHeight);
    
    self.howToCookView.frame = howToCookViewFrame;
    
    self.howToCookView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5f];
    
    // stepsTableView in rightView

    CGFloat stepsTableViewTopOffset = finalImageViewTopOffset + finalImageHeight;
    
    CGFloat stepsTableViewHeight = 0;
    
    if ( (self.wasPressed) && ([self.recipe.steps count]) ) {
        
        stepsTableViewHeight = [self heightForStepsTableView];
        
        stepsTableViewTopOffset += offset;
        
        CGRect stepsTableViewFrame = CGRectMake(0,
                                                stepsTableViewTopOffset,
                                                rightViewWidth,
                                                stepsTableViewHeight);
        
        self.stepsTableView.frame = stepsTableViewFrame;
        
        self.stepsTableView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5f];
        
        self.stepsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
    }
    
    self.rightView.frame = CGRectMake(leftViewWidth + 2 * offset,
                                                              offset,
                                                              rightViewWidth,
                                                              stepsTableViewTopOffset + stepsTableViewHeight);
    
    self.rightView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5f];
    
    self.activityIndicatorForFinalImage.frame = CGRectMake(finalImageWidth / 2 - finalImageWidth / 20,
                                                      finalImageHeight / 2 - finalImageWidth / 20,
                                                      finalImageWidth / 10,
                                                      finalImageWidth / 10);
    
    self.activityIndicatorForFinalImage.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    self.activityIndicatorForFinalImage.hidesWhenStopped = YES;
    
    [self.activityIndicatorForFinalImage startAnimating];
    
    // disablingButtonView in howToCookView
    
    self.disablingButtonView.backgroundColor = [UIColor clearColor];
    
    if (self.wasPressed) {
        
        self.howToCookButton.backgroundColor = [[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_cork"]] colorWithAlphaComponent:0.5f];
        
        self.disablingButtonView.frame = self.howToCookButton.frame;

    } else {
        
        self.howToCookButton.backgroundColor = [[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_cork"]] colorWithAlphaComponent:0.8f];
        
        self.disablingButtonView.frame = CGRectMake(0, 0, 0, 0);
    }
    
    // contentSize for scrollView
    
    UIView* view = [self superview];
    
    self.scrollView = (UIScrollView* )view;
    
    CGFloat visibleScreenHeight = self.frame.size.height - allBarsHeight;
    CGFloat heightOfView = MAX(self.leftView.frame.size.height, self.rightView.frame.size.height) + 2 * offset;
    
    CGFloat scrollViewHeight = MAX(visibleScreenHeight, heightOfView);
    
    CGSize scrollViewSize = CGSizeMake(self.frame.size.width,
                                       scrollViewHeight);
    
    self.scrollView.contentSize = scrollViewSize;
    
    self.frame = CGRectMake(self.frame.origin.x,
                            self.frame.origin.y,
                            self.frame.size.width,
                            scrollViewSize.height);
    
    // loading finalImage

    NSString* finalImageName = [self.recipe.ID stringByAppendingString:@"_final.jpg"];
    
    __weak UIImageView* weakFinalImageView = self.finalImageView;
    
    [self.recipe setImage:self.finalImageView.image
                 withName:finalImageName
                 startURL:startURL
                onSuccess:^(UIImage *image) {
                    
                    weakFinalImageView.image = image;
                    
                    [weakSelf.activityIndicatorForFinalImage stopAnimating];
                    
                }];

    // end of loading finalImage
    
}

- (CGRect) countRectForText:(NSString *) text forWidth:(CGFloat) width forFont:(UIFont *) font {
    
    NSDictionary *attributes = [self attributesForTextWithFont:font];
    
    CGRect rect = [text boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) // учитываем отступы по горизонтали
                                     options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                  attributes:attributes
                                     context:nil];
    
    return rect;
}

- (NSDictionary *) attributesForTextWithFont:(UIFont *) font {
    
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

// method contains code for the calculation of heightForStepsTableView
- (CGFloat) heightForStepsTableView {
    
    CGFloat heightForStepsTableView = 0;
    
    NSMutableArray *heights = [NSMutableArray array];
    
    for (OPRecipeStep *step in self.recipe.steps) {
        
        CGFloat stepCellHeight = [OPRecipeStepCell heightForStep:step
                                                       cellWidth:self.stepsTableWidth];
        
        heightForStepsTableView += stepCellHeight;
        
        [heights addObject:[NSNumber numberWithFloat:stepCellHeight]];
        
    }
    
    self.heightsOfCellsForStepsTableView = [heights copy];
    
    return heightForStepsTableView;
    
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.recipe.steps count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    OPRecipeStep* step = [self.stepsArray objectAtIndex:indexPath.row];
    
    static NSString *identifier = @"Cell";
    
    OPRecipeStepCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        
        cell = [[OPRecipeStepCell alloc] initWithStep:step
                                               recipe:self.recipe
                                                width:self.stepsTableWidth];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
//    return tableView.rowHeight; // by default
    
    CGFloat height = 0;
    
    if ([self.heightsOfCellsForStepsTableView count]) {
        
        height = [[self.heightsOfCellsForStepsTableView objectAtIndex:indexPath.row] floatValue];
        
    }
    
    return height;
}

#pragma mark - Actions

- (void)actionShowStepsOfCooking:(UIButton *)sender {
    
    self.wasPressed = YES;
    
    [self countAllFrames];
}

@end
