//
//  OPUtils.m
//  Recipes
//
//  Created by Oleg Pochtovy on 29.10.15.
//  Copyright © 2015 Oleg Pochtovy. All rights reserved.
//

#import "OPUtils.h"
#import <UIKit/UIKit.h>

BOOL retina() {
    
    return ( [[UIScreen mainScreen] scale] == 2.0f );
}

void customizeAppearance() {
    
    // UINavigationBar
    
    UINavigationBar* navBar = [UINavigationBar appearance];
    
    [navBar setBarTintColor:[UIColor brownColor]];
    
    UIFont* titleFont = [UIFont systemFontOfSize:30.f];
    NSDictionary *titleAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                     [UIColor whiteColor], NSForegroundColorAttributeName,
                                     titleFont, NSFontAttributeName, nil];
    [navBar setTitleTextAttributes:titleAttributes];
    
    // UIBarButtonItem
    
    UIBarButtonItem* navBarItem = [UIBarButtonItem appearance];
    
    [navBarItem setTintColor:[UIColor whiteColor]];
    
    // UITabBar
    
    UITabBar* tabBar = [UITabBar appearance];
    
    [tabBar setBarTintColor:[UIColor brownColor]];
    
    UIImage* selectionImage = [UIImage imageNamed:@"t_selected"];
    [tabBar setSelectionIndicatorImage:selectionImage];
    
    [tabBar setTintColor:[UIColor whiteColor]];
    
    // title for UITabBarItem - UIControlStateNormal
    
    UITabBarItem* tabBarItem = [UITabBarItem appearance];
    
    UIFont *font = [UIFont systemFontOfSize:14.f];
    
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                [UIColor lightGrayColor], NSForegroundColorAttributeName,
                                font, NSFontAttributeName, nil];
    
    [tabBarItem setTitleTextAttributes:attributes forState:UIControlStateNormal];
    
    // title for UITabBarItem - UIControlStateSelected
    
    NSDictionary *attributesForSelected = [NSDictionary dictionaryWithObjectsAndKeys:
                                           [UIColor whiteColor], NSForegroundColorAttributeName,
                                           font, NSFontAttributeName, nil];
    
    [tabBarItem setTitleTextAttributes:attributesForSelected forState:UIControlStateSelected];
}


