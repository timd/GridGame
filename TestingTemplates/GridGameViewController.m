    //
//  TestingTemplatesViewController.m
//  TestingTemplates
//
//  Created by Tim Duckett on 13/09/2011.
//  Copyright 2011 Charismatic Megafauna Ltd. All rights reserved.
//

#import "GridGameViewController.h"

#define kSquareWidth 60
#define kSquareHeight 60
#define kSquarePadding 8

@implementation GridGameViewController

@synthesize points;
@synthesize wins;
@synthesize lives;
@synthesize rows;
@synthesize columns;
@synthesize turn;
@synthesize level;
@synthesize scoreLabel;
@synthesize turnLabel;
@synthesize livesLabel;
@synthesize levelLabel;
@synthesize correctGuessesThisTurn;

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}



#pragma mark - View lifecycle


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Setup initial values
    self.points = 0;
    self.wins = 0;
    self.lives = 2;
    self.columns = 3;
    self.rows = 3;
    self.level = 1;
    self.turn = 1;
    
    scoreLabel.text = [NSString stringWithFormat:@"%d", self.points];;
    livesLabel.text = [NSString stringWithFormat:@"%d", self.lives];
    turnLabel.text = [NSString stringWithFormat:@"%d", self.turn];
    levelLabel.text = [NSString stringWithFormat:@"%d", self.level]; 
    
    // Set up answers array
    userAnswers = [[NSMutableArray alloc] init];
    
    [self startRound];
    
}

-(void)viewDidAppear:(BOOL)animated {

}


#pragma mark -
#pragma mark User interaction methods

-(IBAction)didTapGridButton:(id)sender {

    UIButton *tappedButton = (UIButton *)sender;
    NSNumber *tappedTag = [NSNumber numberWithInt:tappedButton.tag];

    if ([tappedButton backgroundImageForState:UIControlStateNormal] == [UIImage imageNamed:@"whiteButtonBackground"]) {
        // button isn't selected, so select it and add square to answers
        [tappedButton setBackgroundImage:[UIImage imageNamed:@"blueButtonBackground"] forState:UIControlStateNormal];

        [userAnswers addObject:tappedTag];

    } else {
        // button IS selected, deselect and remove square from answers
        [tappedButton setBackgroundImage:[UIImage imageNamed:@"whiteButtonBackground"] forState:UIControlStateNormal];

        if ( [userAnswers containsObject:tappedTag] ) {
            [userAnswers removeObject:tappedTag];
        } 

    }
    
    NSLog(@"Button %d tapped", tappedButton.tag);
    
}

- (IBAction)submitButtonTapped:(id)sender {
    
    NSLog(@"submit button tapped");
    NSLog(@"userAnswers = %@", userAnswers);
    
    UIButton *button = (UIButton *)sender;
    [button setHidden:YES];
    
    // Did user win
    [self checkIfGameWonWithAnswers:userAnswers andPlacings:appAnswers];
    
    [self shouldLevelIncrease];
    
    scoreLabel.text = [NSString stringWithFormat:@"%d", self.points];;
    livesLabel.text = [NSString stringWithFormat:@"%d", self.lives];
    turnLabel.text = [NSString stringWithFormat:@"%d", self.turn];
    levelLabel.text = [NSString stringWithFormat:@"%d", self.level]; 

}

#pragma mark -
#pragma mark Game methods

-(void)startRound {    
    
    scoreLabel.text = [NSString stringWithFormat:@"%d", self.points];;
    livesLabel.text = [NSString stringWithFormat:@"%d", self.lives];
    turnLabel.text = [NSString stringWithFormat:@"%d", self.turn];
    levelLabel.text = [NSString stringWithFormat:@"%d", self.level]; 
    
    //    appAnswers = [[NSArray arrayWithObjects:[NSNumber numberWithInt:11], nil] retain];
    //    appAnswers = [[NSArray arrayWithArray:[self generateBlockPlacementArrayForLevelWithColumns:self.columns andRows:self.rows]] retain];
    
    xyPositions = [self createArrayOfPositionsForRows:self.rows andColumns:self.columns];
    appAnswers = [[self generateRandomBlockPlacements] retain];
    
    // Create and show new grid
    
    NSArray *tagsArray = [self generateArrayOfFilledBlocksForRows:self.rows andColumns:self.columns];
    NSLog(@"tagsArray = %@", tagsArray);
    
    // Create a blank grid
    UIView *startingGrid = [self createGridWithRows:self.rows andColumns:self.columns];
    UIView *buttonGrid = [self createGridWithRows:self.rows andColumns:self.columns];
    
    // Create the buttoned grid
    UIView *beButtonedView = [self addButtonsToView:buttonGrid atPositions:xyPositions];
    UIView *unButtonedView = [self addSubviewsToView:startingGrid atPositions:xyPositions];
    
    
    /****************************
    *
    * Set up this turn's answers
    *
    * TODO: Create "live" grid"
    *
    ****************************/
    
    
    
    // Clear out the user answers array
    [userAnswers removeAllObjects];
    
    UIView *blockedUpView = [self addBlocksFromArray:appAnswers ToGrid:unButtonedView];
    
    [self.view addSubview:beButtonedView];
    [beButtonedView setUserInteractionEnabled:NO];
    
    [self.view addSubview:blockedUpView];
    
    UIButton *submitButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [submitButton setFrame:CGRectMake(123, 403, 75, 40)];
    [submitButton setTitle:@"Guess!" forState:UIControlStateNormal];
    [submitButton addTarget:self action:@selector(submitButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [submitButton setHidden:YES];
    [self.view addSubview:submitButton];
    
    [UIView animateWithDuration:0.5 delay:2.0 options:UIViewAnimationCurveLinear animations:^{
        [blockedUpView setAlpha:0];
    }
                     completion:^(BOOL finished) {
                         [beButtonedView setUserInteractionEnabled:YES];
                         [submitButton setHidden:NO];
                     }];
    
}


-(BOOL)checkIfGameWonWithAnswers:(NSMutableArray *)answersArray andPlacings:(NSArray *)placingsArray {
    
    // Check if there are the same number of elements in each
    if ([answersArray count] != [placingsArray count]) {

        self.turn++;
        self.lives--;
        [self shouldLevelIncrease];
        
        return NO;
    }
    
    
    // Sort the two arrays
    NSArray *sortedAppArray = [NSArray arrayWithArray:[answersArray sortedArrayUsingSelector:@selector(compare:)]];
    NSArray *sortedUserArray = [NSArray arrayWithArray:[placingsArray sortedArrayUsingSelector:@selector(compare:)]];

    for (int i = 0; i < [sortedUserArray count]; i++) {
    
        int answerOne = [[sortedAppArray objectAtIndex:i] intValue];
        int placerOne = [[sortedUserArray objectAtIndex:i] intValue];
    
        NSLog(@"A:%d / P:%d", answerOne, placerOne);
    
        if (answerOne != placerOne) {

            // Dissimilar answer. It's incorrect
            // so game is lost

            self.turn++;
            self.lives--;
            [self shouldLevelIncrease];
            
            return NO;
            
        }
        
    }
    
    // Has got to the end of all the elements in both arrays, therefore
    // the answer must be correct.  Game has been won.
    
        
        self.points++;
        self.turn++;
        self.correctGuessesThisTurn++;
        [self shouldLevelIncrease];
        
        //        [sortedAppArray release];
        //        [sortedUserArray release];
        
        return YES;
    
}

-(void)shouldLevelIncrease {
    
    if (self.correctGuessesThisTurn == 2) {
        self.turn = 1;
        self.level++;
        self.correctGuessesThisTurn = 0;
        [self increaseBoardSize];
    }
    
    BOOL shouldStartNewRound = [self shouldNewRoundStart];
    
    if (shouldStartNewRound) {
        
        // release the app answers
        //        [appAnswers release];
        
        [self startRound];
    } else  {
        
        BOOL wasGameLost = [self wasGameLost];
        
        if (wasGameLost) {
            [self endGameAsLost];
        } else {
            [self endGameAsWon];
        }
            
    }
    
}

-(BOOL)shouldNewRoundStart {

    if ( self.lives != 0 && self.level !=5 && self.correctGuessesThisTurn != 2 ) {
        return YES;
    } else {
        return NO;
    }
    
}

-(BOOL)wasGameLost {
    
    if (self.lives == 0) {
        return YES;
    } else {
        return NO;
    }
    
}

-(void)increaseBoardSize{
    
    if (self.columns == 3) {
        self.columns++;
    } else {
        self.rows++;
    }
}

-(void)endGameAsWon {
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Congratulations!" 
                                                    message:@"You won the game" 
                                                   delegate:nil 
                                          cancelButtonTitle:@"OK" 
                                          otherButtonTitles: nil];
    [alert show];
    [alert release];
    
}

-(void)endGameAsLost {
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Commiserations" 
                                                    message:@"You lost the game" 
                                                   delegate:nil 
                                          cancelButtonTitle:@"OK" 
                                          otherButtonTitles: nil];
    [alert show];
    [alert release];

    
}

#pragma mark -
#pragma mark Grid methods

-(float)calculateWidthOfGridFor:(int)numberOfColumns {
    
    int height = (kSquareHeight * numberOfColumns) + (kSquarePadding * (numberOfColumns - 1));
    return (float)height;
    
}

-(float)calculateHeightOfGridFor:(int)numberOfRows {
    
    int width = (kSquareWidth * numberOfRows) + (kSquarePadding * (numberOfRows - 1));
    return (float)width;
    
};

-(float)calculateXoffsetForGridWithColumns:(int)numberOfColumns {
    
    int offset = (320 - (int)[self calculateWidthOfGridFor:numberOfColumns]) / 2;
    return (float)offset;
}


#pragma mark -
#pragma mark Board creation methods

-(NSArray *)generateRandomBlockPlacements {
    
    // Copy xypositions into a mutable array
    NSMutableArray *mutableXY = [NSMutableArray arrayWithArray:xyPositions];
    NSMutableArray *randomPlacements = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < (self.level + 1); i++) {
        
        int randomIndex = (arc4random() % [mutableXY count]);
       
        NSArray *chosenElement = [mutableXY objectAtIndex:randomIndex];
        
        NSNumber *tag = [chosenElement objectAtIndex:2];
        
        NSLog(@"Chosen tag = %@", tag);
        
        [randomPlacements addObject:tag];
        
        [mutableXY removeObjectAtIndex:randomIndex];
        
    }
    
    return [NSArray arrayWithArray:randomPlacements];
}

-(NSArray *)generateBlockPlacementArrayForLevelWithColumns:(int)columnCount andRows:(int)rowCount {
    
    NSMutableArray *blockPlacementArray = [[NSMutableArray alloc] initWithObjects: nil];
    
    NSMutableArray *colSeeds = [[NSMutableArray alloc] init];
    NSMutableArray *rowSeeds = [[NSMutableArray alloc] init];
    
    NSMutableArray *colArray = [[NSMutableArray alloc] init];
    NSMutableArray *rowArray = [[NSMutableArray alloc] init];
    
    // Seed colArray
    for (int i=1; i <= columnCount; i++) {
        [colSeeds addObject:[NSNumber numberWithInt:i]];
    }

    // Seed rowArray
    for (int i=1; i <= columnCount; i++) {
        [rowSeeds addObject:[NSNumber numberWithInt:i]];
    }

    // Grab random element from colArray
    for (int i=0; i <= [colSeeds count] - 1; i++) {
        
        int indexToUse = arc4random() % ([colSeeds count] - 1);
        
        [colArray addObject:[colSeeds objectAtIndex:indexToUse]];
        
        [colSeeds removeObjectAtIndex:indexToUse];
        
    }    

    // Grab random element from colArray
    for (int i=0; i <= ([rowSeeds count] - 1); i++) {
        
        int indexToUse = arc4random() % ([rowSeeds count] - 1);
        
        [rowArray addObject:[rowSeeds objectAtIndex:indexToUse]];
        
        [rowSeeds removeObjectAtIndex:indexToUse];
        
    }    
    
    NSLog(@"colArray = %@", colArray);
    NSLog(@"rowArray = %@", rowArray);
    
    for (int i=0; i < [colArray count]; i++) {
        
        int rowRef = [[rowArray objectAtIndex:i] intValue];
        int colRef = [[rowArray objectAtIndex:i] intValue] * 10;
        
        int coord = colRef + rowRef;
        NSLog(@"coord = %d", coord);
        
        [blockPlacementArray addObject:[NSNumber numberWithInt:coord]];
        
    }
    
    [colSeeds release];
    [rowSeeds release];
    [colArray release];
    [rowArray release];
    
    NSLog(@"returnArray = %@", blockPlacementArray);
    
    return [NSArray arrayWithArray:blockPlacementArray];
    
}


-(NSArray *)generateArrayOfFilledBlocksForRows:(int)bRows andColumns:(int)bColumns {

    NSMutableArray *tagsArray = [[NSMutableArray alloc] init];
    
    for (int rInt = 1; rInt <= bRows; rInt++) {
        
        int rowStem = rInt * 10;
        
        for (int cInt = 1; cInt <= bColumns; cInt++) {
            
            int tagInt = rowStem + cInt;
            [tagsArray addObject:[NSNumber numberWithInt:tagInt]];
            
        }
    }
    
    NSArray *returnArray = [NSArray arrayWithArray:tagsArray];
    
    return returnArray;
    
}

-(UIView *)addBlocksFromArray:(NSArray *)theArray ToGrid:(UIView *)theGrid {

    for (NSNumber *tagAsNum in theArray) {
        
        int tagInt = [tagAsNum intValue];
        
        for (UIView *subView in theGrid.subviews) {
            if (subView.tag == tagInt) {
                UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"blueButtonBackground"]];
                [subView addSubview:imageView];
            }
        }
        
    }
    
    return theGrid;
    
}


-(UIView *)addButtonsToView:(UIView *)theView atPositions:(NSArray *)positionsArray {
    
    for (NSArray *coords in positionsArray) {
        
        // Extract the x/y coords
        float xCoord = [[coords objectAtIndex:0] floatValue];
        float yCoord = [[coords objectAtIndex:1] floatValue];
        NSString *tagString = [coords objectAtIndex:2];        

        //int intXCoord = (int)xCoord;
        //int intYCoord = (int)yCoord;
        
        int tagInt = [tagString intValue];
        
        //NSLog(@"Floats: X/Y = %f/%f", xCoord, yCoord);
        //NSLog(@"Ints: X/Y = %d/%d", intXCoord, intYCoord);
        //NSLog(@"tagString = %@", tagString);
        //NSLog(@"tagInt = %d", tagInt);
        //NSLog(@"=========================");
        
        // Create a button at the x/y coordinates
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setBackgroundImage:[UIImage imageNamed:@"whiteButtonBackground"] forState:UIControlStateNormal];
        [button setFrame:CGRectMake(xCoord, yCoord, 60, 60)];
        [button setTag:tagInt];
        // [button setTitle:tagString forState:UIControlStateNormal];
        [button addTarget:self action:@selector(didTapGridButton:) forControlEvents:UIControlEventTouchUpInside];
        
        // add the button to the gridView
        [theView addSubview:button];
        
    }
    
    return theView;
    
}

-(UIView *)addSubviewsToView:(UIView *)theView atPositions:(NSArray *)positionsArray {
    
    for (NSArray *coords in positionsArray) {
        
        // Extract the x/y coords
        float xCoord = [[coords objectAtIndex:0] floatValue];
        float yCoord = [[coords objectAtIndex:1] floatValue];
        NSString *tagString = [coords objectAtIndex:2];        
        
        int intXCoord = (int)xCoord;
        int intYCoord = (int)yCoord;
        
        int tagInt = [tagString intValue];
        
        NSLog(@"Floats: X/Y = %f/%f", xCoord, yCoord);
        NSLog(@"Ints: X/Y = %d/%d", intXCoord, intYCoord);
        NSLog(@"tagString = %@", tagString);
        NSLog(@"tagInt = %d", tagInt);
        NSLog(@"=========================");
        
        // Create a button at the x/y coordinates
        UIView *subView = [[UIView alloc] initWithFrame:CGRectMake(xCoord, yCoord, 60, 60)];
        [subView setTag:tagInt];
        
        // add the button to the gridView
        [theView addSubview:subView];
        
    }
    
    return theView;
    
}


-(NSArray *)createArrayOfPositionsForRows:(int)noOfRows andColumns:(int)noOfCols {
    
    NSMutableArray *xyPositionsArray = [[NSMutableArray alloc] init];
    
    for (int r=0; r < noOfRows; r++) {
    
        for (int c = 0; c < noOfCols; c++) {
            
            NSNumber *xpos = [NSNumber numberWithInt:((c * 60) + (c * 8))];
            NSNumber *ypos = [NSNumber numberWithInt:((r * 60) + (r * 8))];
            NSString *tag = [NSString stringWithFormat:@"%d%d", r+1, c+1];
            
            NSArray *coord = [NSArray arrayWithObjects:xpos, ypos, tag, nil];
            [xyPositionsArray addObject:coord];
            
        }
        
    }
    
    NSArray *returnArray = [NSArray arrayWithArray:xyPositionsArray];
    [xyPositionsArray release];
    
    return returnArray;

}

-(UIImage *)backgroundImageForRows:(int)numberOfRows andColumns:(int)numberOfColumns {

    UIImage *backgroundImage = [[UIImage alloc] init];
    
    //Select the background image
    if (numberOfColumns == 3 && numberOfRows == 3) {
        backgroundImage = [UIImage imageNamed:@"3x3"];
    } else if ( numberOfColumns == 4 && numberOfRows == 3 ) {
        backgroundImage = [UIImage imageNamed:@"4x3"];        
    } else if ( numberOfColumns == 4 && numberOfRows == 4 ) {
        backgroundImage = [UIImage imageNamed:@"4x4"];        
    } else if ( numberOfColumns == 4 && numberOfRows == 5 ) {
        backgroundImage = [UIImage imageNamed:@"4x5"];        
    } else if ( numberOfColumns == 4 && numberOfRows == 6 ) {
        backgroundImage = [UIImage imageNamed:@"4x6"];        
    }

    return [backgroundImage autorelease];

}

- (UIView *)createGridWithRows:(int)numberOfRows andColumns:(int)numberOfColumns {
    
    // Create and show new grid
    // Size is a function of the number of rows
    int gridWidth = [self calculateWidthOfGridFor:numberOfColumns];
    int gridHeight = [self calculateHeightOfGridFor:numberOfRows] + 60;
    
    UIImage *backgroundImage = [self backgroundImageForRows:numberOfRows andColumns:numberOfColumns];
    
    UIView *gridView = [[UIView alloc] initWithFrame:CGRectMake([self calculateXoffsetForGridWithColumns:numberOfColumns], 60, gridWidth, gridHeight)];
    UIImageView *gridImageView = [[UIImageView alloc] initWithImage:backgroundImage];
    
    [gridView addSubview:gridImageView];
    
    return gridView;
}

#pragma mark -
#pragma mark Shutdown methods

- (void)viewDidUnload
{
    [self setScoreLabel:nil];
    [self setTurnLabel:nil];
    [self setLivesLabel:nil];
    [self setLevelLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    [userAnswers release];
    userAnswers = nil;
    
    [appAnswers release];
    appAnswers = nil;
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {

    [scoreLabel release];
    [turnLabel release];
    [livesLabel release];
    [levelLabel release];
    [super dealloc];
}
@end
