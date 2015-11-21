//
//  OPRecipesCollectionViewController.m
//  Recipes
//
//  Created by Oleg Pochtovy on 29.10.15.
//  Copyright © 2015 Oleg Pochtovy. All rights reserved.
//

#import "OPRecipesCollectionViewController.h"

#import "OPJSONManager.h"

#import "OPRecipe.h"
#import "OPRecipeStep.h"

#import "OPUtils.h"

#import "OPRecipeCellViaAF.h"

#import "OPRecipeProfileViewController.h"

@interface OPRecipesCollectionViewController () <UICollectionViewDelegateFlowLayout>

@property (strong, nonatomic) NSMutableArray *recipesArray;

@end

@implementation OPRecipesCollectionViewController

static NSString * const reuseIdentifier = @"OPRecipeCellViaAF";

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.title = @"Избранное";
    
    self.collectionView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_cork.png"]];
    
    self.recipesArray = [NSMutableArray array];
    
    [self getRecipesFromJSON];
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}

#pragma mark - Private Methods

- (void) getRecipesFromJSON {
    
    [[OPJSONManager sharedManager] getRecipesOnSuccess:^(NSArray *recipes)
    {
        [self.recipesArray addObjectsFromArray:recipes];
    }
                                             onFailure:^(NSError *error, NSInteger statusCode)
    {
    }];
    
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return [self.recipesArray count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    OPRecipeCellViaAF *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    if (!cell) {
        
        cell = [[OPRecipeCellViaAF alloc] init];
        
    }
    
    cell.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5f];
    
    cell.recipe = [self.recipesArray objectAtIndex:indexPath.row];
    
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    OPRecipeProfileViewController *recipeProfileVC = [self.storyboard instantiateViewControllerWithIdentifier:@"OPRecipeProfileViewController"];
    
    OPRecipe* recipe = [self.recipesArray objectAtIndex:indexPath.row];
    
    recipeProfileVC.recipe = recipe;
    
    [self.navigationController pushViewController:recipeProfileVC animated:YES];
    
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat cellWidth = PREVIEW_WIDTH;
    CGFloat cellHeight = PREVIEW_HEIGHT;
    
    cellWidth += 2 * RECIPE_CELL_OFFSET;
    cellHeight += 2 * RECIPE_CELL_OFFSET + RECIPE_CELL_NAME_HEIGHT;
    
    return CGSizeMake(cellWidth, cellHeight);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    return UIEdgeInsetsMake(5, 5, 5, 5);
}

@end
