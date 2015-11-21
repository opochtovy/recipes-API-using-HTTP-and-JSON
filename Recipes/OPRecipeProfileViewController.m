//
//  OPRecipeProfileViewController.m
//  Recipes
//
//  Created by Oleg Pochtovy on 01.11.15.
//  Copyright © 2015 Oleg Pochtovy. All rights reserved.
//

#import "OPRecipeProfileViewController.h"

#import "OPRecipe.h"

#import "OPRecipeProfileView.h"

@interface OPRecipeProfileViewController () <UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView* scrollView;

@property (strong, nonatomic) OPRecipeProfileView* recipeProfileView;

@end

@implementation OPRecipeProfileViewController

//static CGFloat topBarHeight = 20.0;
//static CGFloat navBarHeight = 44.0;
//static CGFloat tabBarHeight = 44.0;
static CGFloat allBarsHeight = 108.0;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.title = @"Блюдо из коллекции \"САЛАТЫ КЛАССИЧЕСКИЕ\"";
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_cork.png"]];
    
    self.scrollView.delegate = self;
    
    // backButton in NavigationBar

    UIBarButtonItem* backButton = [[UIBarButtonItem alloc]
                                     initWithImage:[UIImage imageNamed:@"back_button.png"]
                                     style:UIBarButtonItemStylePlain
                                     target:self
                                     action:@selector(actionBack:)];
                                   
    self.navigationItem.leftBarButtonItem = backButton;
    
    CGFloat visibleScreenHeight = self.view.frame.size.height - allBarsHeight;
    
    CGSize scrollViewSize = CGSizeMake(self.view.frame.size.width,
                                       visibleScreenHeight);
    
    self.scrollView.contentSize = scrollViewSize;
    
    // self.recipeProfileView
    
    CGRect recipeProfileViewRect = CGRectMake(0,
                                              0,
                                              self.view.frame.size.width,
                                              visibleScreenHeight);
    
    self.recipeProfileView = [[OPRecipeProfileView alloc] initWithFrame:recipeProfileViewRect recipe:self.recipe];
    
    [self.scrollView addSubview:self.recipeProfileView];
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    if (self.recipeProfileView.frame.size.width != self.view.frame.size.width) {
        
        CGFloat visibleScreenHeight = self.view.frame.size.height - allBarsHeight;
        
        CGRect recipeProfileViewRect = CGRectMake(0,
                                                  0,
                                                  self.view.frame.size.width,
                                                  visibleScreenHeight);
        
        self.recipeProfileView.frame = recipeProfileViewRect;
        
        [self.recipeProfileView countAllFrames]; // из-за этой строки идет двойная загрузка countAllFrames при инициализации OPRecipeProfileViewController
        
        [self.recipeProfileView.stepsTableView reloadData];
        
    }
    
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}

- (void) dealloc {
 
    [self.recipeProfileView removeFromSuperview];
    
}

#pragma mark - Orientation

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    
    CGFloat visibleScreenHeight = self.view.frame.size.height - allBarsHeight;

    CGRect recipeProfileViewRect = CGRectMake(0,
                                              0,
                                              self.view.frame.size.width,
                                              visibleScreenHeight);
 
    self.recipeProfileView.frame = recipeProfileViewRect;
    
    [self.recipeProfileView countAllFrames];
    
    [self.recipeProfileView.stepsTableView reloadData];

}

#pragma mark - Actions

- (void)actionBack:(UIButton *)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

@end
