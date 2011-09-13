//
//  TestingTemplatesViewController.h
//  TestingTemplates
//
//  Created by Tim Duckett on 13/09/2011.
//  Copyright 2011 Charismatic Megafauna Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GridGameViewController : UIViewController {
    
    int points;
    int wins;
    int lives;
    int rows;
    int columns;
    
}

- (UIView *)createGridWithRows:(int)numberOfRows andColumns:(int)numberOfColumns;
- (UIImage *)backgroundImageForRows:(int)numberOfRows andColumns:(int)numberOfColumns;
    
-(float)calculateWidthOfGridFor:(int)numberOfColumns;
-(float)calculateHeightOfGridFor:(int)numberOfRows;
-(float)calculateXoffsetForGridWithColumns:(int)numberOfColumns;
-(NSArray *)createArrayOfPositionsForRows:(int)noOfRows andColumns:(int)noOfCols;
-(UIView *)addButtonsToView:(UIView *)theView atPositions:(NSArray *)positionsArray;

-(IBAction)didTapGridButton:(id)sender;


@end
