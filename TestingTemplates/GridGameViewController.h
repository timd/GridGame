//
//  TestingTemplatesViewController.h
//  TestingTemplates
//
//  Created by Tim Duckett on 13/09/2011.
//  Copyright 2011 Charismatic Megafauna Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GridGameViewController : UIViewController {
    
    NSMutableArray *userAnswers;
    NSArray *appAnswers;
    
    NSArray *xyPositions;
    
    UILabel *scoreLabel;
    UILabel *turnLabel;
    UILabel *livesLabel;
    UILabel *levelLabel;
}

@property (nonatomic) int points;
@property (nonatomic) int wins;
@property (nonatomic) int lives;
@property (nonatomic) int rows;
@property (nonatomic) int columns;
@property (nonatomic) int turn;
@property (nonatomic) int level;
@property (nonatomic) int correctGuessesThisTurn;
@property (nonatomic, retain) IBOutlet UILabel *scoreLabel;
@property (nonatomic, retain) IBOutlet UILabel *turnLabel;
@property (nonatomic, retain) IBOutlet UILabel *livesLabel;
@property (nonatomic, retain) IBOutlet UILabel *levelLabel;

- (UIView *)createGridWithRows:(int)numberOfRows andColumns:(int)numberOfColumns;
- (UIImage *)backgroundImageForRows:(int)numberOfRows andColumns:(int)numberOfColumns;
    
-(float)calculateWidthOfGridFor:(int)numberOfColumns;
-(float)calculateHeightOfGridFor:(int)numberOfRows;
-(float)calculateXoffsetForGridWithColumns:(int)numberOfColumns;
-(NSArray *)createArrayOfPositionsForRows:(int)noOfRows andColumns:(int)noOfCols;
-(UIView *)addButtonsToView:(UIView *)theView atPositions:(NSArray *)positionsArray;
-(UIView *)addSubviewsToView:(UIView *)theView atPositions:(NSArray *)positionsArray;
-(UIView *)addBlocksFromArray:(NSArray *)theArray ToGrid:(UIView *)theGrid;
-(NSArray *)generateArrayOfFilledBlocksForRows:(int)rows andColumns:(int)columns;
-(NSArray *)generateBlockPlacementArrayForLevelWithColumns:(int)columnCount andRows:(int)rowCount;

-(NSArray *)generateRandomBlockPlacements;


-(IBAction)didTapGridButton:(id)sender;
-(IBAction)submitButtonTapped:(id)sender;

-(void)startRound;
-(BOOL)checkIfGameWonWithAnswers:(NSMutableArray *)answersArray andPlacings:(NSArray *)placingsArray;
-(void)shouldLevelIncrease;
-(BOOL)shouldNewRoundStart;
-(BOOL)wasGameLost;
-(void)increaseBoardSize;
-(void)endGameAsWon;
-(void)endGameAsLost;


@end
