//
//  OPRecipesViewController.m
//  Recipes
//
//  Created by Oleg Pochtovy on 30.10.15.
//  Copyright © 2015 Oleg Pochtovy. All rights reserved.
//

#import "OPRecipesViewController.h"

#import "OPJSONManager.h"

#import "OPRecipe.h"
#import "OPRecipeStep.h"

#import "OPUtils.h"

#import "OPRecipeCell.h"

#import "OPRecipeProfileViewController.h"

@interface OPRecipesViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (strong, nonatomic) IBOutlet UICollectionView* recipeCollectionView;

@property (strong, nonatomic) NSMutableArray *recipesArray;

@end

@implementation OPRecipesViewController

static NSString * const reuseIdentifier = @"OPRecipeCell";

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
//    self.title = @"САЛАТЫ КЛАССИЧЕСКИЕ";
    
//    self.tabBarItem.title = @"Главное меню";
    
    // all code for customization of UITabBar & UINavigationBar is in OPUtils.m in function customizeAppearance()(it's called from AppDelegate.m)
    
    self.recipeCollectionView.dataSource = self;
    self.recipeCollectionView.delegate = self;
    
    self.recipeCollectionView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_cork.png"]];
    
    self.recipesArray = [NSMutableArray array];
    
    [self getRecipesFromJSON];
    
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}

#pragma mark - Private Methods

- (void) getRecipesFromJSON {
    
    [[OPJSONManager sharedManager]
     getRecipesOnSuccess:^(NSArray *recipes)
     {
         [self.recipesArray addObjectsFromArray:recipes];
         
         for (OPRecipe* recipe in self.recipesArray) {
             
             recipe.recipeIndex = [self.recipesArray indexOfObject:recipe];
             
         }
         
     }
     onFailure:^(NSError *error, NSInteger statusCode)
     {
         
     }];
    
}

// UICollectionViewDelegateFlowLayout

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return [self.recipesArray count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    OPRecipeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    if (!cell) {
        
        cell = [[OPRecipeCell alloc] init];
        
    }
    
    cell.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5f];
    
    cell.recipe = [self.recipesArray objectAtIndex:indexPath.row];
    
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return YES;
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return YES;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    OPRecipeProfileViewController *recipeProfileVC = [self.storyboard instantiateViewControllerWithIdentifier:@"OPRecipeProfileViewController"];
    
    OPRecipe* recipe = [self.recipesArray objectAtIndex:indexPath.row];
    
    recipeProfileVC.recipe = recipe;
    
    [self.navigationController pushViewController:recipeProfileVC animated:YES];
    
}

#pragma mark - UICollectionViewDelegateFlowLayout

// collectionView:layout:sizeForItemAtIndexPath is responsible for telling the layout the size of a given cell. To do this, you must first determine which FlickrPhoto you are looking at, since each photo could have different dimensions.
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat cellWidth = PREVIEW_WIDTH;
    CGFloat cellHeight = PREVIEW_HEIGHT;
    
    cellWidth += 2 * RECIPE_CELL_OFFSET; // horizontal offset for cell
    cellHeight += 2 * RECIPE_CELL_OFFSET + RECIPE_CELL_NAME_HEIGHT; // vertical offset for cell
    
    return CGSizeMake(cellWidth, cellHeight);
}

// collectionView:layout:insetForSectionAtIndex: returns the spacing between the cells, headers, and footers.
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    return UIEdgeInsetsMake(5, 10, 5, 10);
}

@end
