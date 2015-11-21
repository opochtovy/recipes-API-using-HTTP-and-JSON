//
//  OPUtils.h
//  Recipes
//
//  Created by Oleg Pochtovy on 29.10.15.
//  Copyright © 2015 Oleg Pochtovy. All rights reserved.
//

#import <Foundation/Foundation.h>

#define JSON_FILE_NAME @"05-salads"

#define BASE_URL @"https://dl.dropbox.com/u/81083649/Cooking/static/images/05-salads/ipad_"

#define PREVIEW_WIDTH 169
#define PREVIEW_HEIGHT 162

#define RETINA_START_WIDTH 760
#define RETINA_START_HEIGHT 504
#define NONRETINA_START_WIDTH 380
#define NONRETINA_START_HEIGHT 252

#define RETINA_FINAL_WIDTH 1178
#define RETINA_FINAL_HEIGHT 1244
#define NONRETINA_FINAL_WIDTH 589
#define NONRETINA_FINAL_HEIGHT 622

#define RETINA_STEP_WIDTH 688
#define RETINA_STEP_HEIGHT 456
#define NONRETINA_STEP_WIDTH 344
#define NONRETINA_STEP_HEIGHT 228

#define RECIPE_CELL_OFFSET 2
#define RECIPE_CELL_NAME_LEFT_OFFSET 10
#define RECIPE_CELL_NAME_HEIGHT 55

BOOL retina();

void customizeAppearance();
