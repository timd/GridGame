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
    
}

-(void)viewDidAppear:(BOOL)animated {

    // Setup initial values
    points = 0;
    wins = 0;
    lives = 2;
    columns = 3;
    rows = 3;
    turns = 1;
    
    // Set up answers array
    userAnswers = [[NSMutableArray alloc] init];
    appAnswers = [[NSMutableArray alloc] init];
    
    [self setupGame];
}

-(void)setupGame {    
    
    // Create and show new grid
    NSArray *xyPositions = [self createArrayOfPositionsForRows:rows andColumns:columns];
    NSArray *tagsArray = [self generateArrayOfFilledBlocksForRows:rows andColumns:columns];
    NSLog(@"tagsArray = %@", tagsArray);

    // Create a blank grid
    UIView *startingGrid = [self createGridWithRows:rows andColumns:columns];
    UIView *buttonGrid = [self createGridWithRows:rows andColumns:columns];
    
    // Create the buttoned grid
    UIView *beButtonedView = [self addButtonsToView:buttonGrid atPositions:xyPositions];
    UIView *unButtonedView = [self addSubviewsToView:startingGrid atPositions:xyPositions];
    
    appAnswers = [[NSArray arrayWithObjects:[NSNumber numberWithInt:21],
                         [NSNumber numberWithInt:32], nil] retain];
    
    UIView *blockedUpView = [self addBlocksFromArray:appAnswers ToGrid:unButtonedView];
    
    [self.view addSubview:beButtonedView];
    [beButtonedView setUserInteractionEnabled:NO];
    
    [self.view addSubview:blockedUpView];

    [UIView animateWithDuration:1.0 delay:5.0 options:UIViewAnimationCurveLinear animations:^{
        [blockedUpView setAlpha:0];
    }
                     completion:^(BOOL finished) {
                         [beButtonedView setUserInteractionEnabled:YES];
                         UIButton *submitButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
                         [submitButton setFrame:CGRectMake(123, 403, 75, 40)];
                         [submitButton addTarget:self action:@selector(submitButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
                         [self.view addSubview:submitButton];
                     }];
    
     //    [startingGrid setAlpha:0];
    
}

#pragma mark -
#pragma mark User interaction methods

-(IBAction)didTapGridButton:(id)sender {
    
    UIButton *tappedButton = (UIButton *)sender;
    if ([tappedButton backgroundImageForState:UIControlStateNormal] == [UIImage imageNamed:@"whiteButtonBackground"]) {
        [tappedButton setBackgroundImage:[UIImage imageNamed:@"blueButtonBackground"] forState:UIControlStateNormal];
    } else {
        [tappedButton setBackgroundImage:[UIImage imageNamed:@"whiteButtonBackground"] forState:UIControlStateNormal];
    }
    
    NSNumber *tappedTag = [NSNumber numberWithInt:tappedButton.tag];

    if ( [userAnswers containsObject:tappedTag] ) {
        [userAnswers removeObject:tappedTag];
    } else {
        [userAnswers addObject:tappedTag];
    }
    
    NSLog(@"Button %d tapped", tappedButton.tag);
    
}

- (IBAction)submitButtonTapped:(id)sender {
    
    NSLog(@"submit button tapped");
    NSLog(@"userAnswers = %@", userAnswers);
    
    if (![self checkIfGameWonWithAnswers:userAnswers andPlacings:appAnswers]) {
        // game was lost
    } else {
        // game was lost
    }
}

#pragma mark -
#pragma mark Game methods

-(BOOL)checkIfGameWonWithAnswers:(NSArray *)answersArray andPlacings:(NSArray *)placingsArray {
    
    // Sort the two arrays
    NSArray *sortedAppArray = [answersArray sortedArrayUsingSelector:@selector(compare:)];
    NSArray *sortedUserArray = [placingsArray sortedArrayUsingSelector:@selector(compare:)];
    
    if ([sortedUserArray isEqualToArray:sortedAppArray]) {
        return YES;
    } else {
        return NO;
    }
    
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
        //        UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setBackgroundImage:[UIImage imageNamed:@"whiteButtonBackground"] forState:UIControlStateNormal];
        [button setFrame:CGRectMake(xCoord, yCoord, 60, 60)];
        [button setTag:tagInt];
        [button setTitle:tagString forState:UIControlStateNormal];
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
        //        UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        UIView *subView = [[UIView alloc] initWithFrame:CGRectMake(xCoord, yCoord, 60, 60)];
        [subView setTag:tagInt];
        
        // add the button to the gridView
        [theView addSubview:subView];
        
    }
    
    return theView;
    
}


-(NSArray *)createArrayOfPositionsForRows:(int)noOfRows andColumns:(int)noOfCols {
    
    NSMutableArray *xyPositions = [[NSMutableArray alloc] init];
    
    for (int r=0; r < noOfRows; r++) {
    
        for (int c = 0; c < noOfCols; c++) {
            
            NSNumber *xpos = [NSNumber numberWithInt:((c * 60) + (c * 8))];
            NSNumber *ypos = [NSNumber numberWithInt:((r * 60) + (r * 8))];
            NSString *tag = [NSString stringWithFormat:@"%d%d", r+1, c+1];
            
            NSArray *coord = [NSArray arrayWithObjects:xpos, ypos, tag, nil];
            [xyPositions addObject:coord];
            
        }
        
    }
    
    NSArray *returnArray = [NSArray arrayWithArray:xyPositions];
    [xyPositions release];
    
    return returnArray;

}

-(UIImage *)backgroundImageForRows:(int)numberOfRows andColumns:(int)numberOfColumns {

    UIImage *backgroundImage;
    
    //Select the background image
    if (numberOfColumns == 3 && numberOfRows == 3) {
        backgroundImage = [UIImage imageNamed:@"3x3"];
    } else if ( numberOfColumns == 3 && numberOfRows == 4 ) {
        backgroundImage = [UIImage imageNamed:@"3x4"];        
    } else if ( numberOfColumns == 4 && numberOfRows == 4 ) {
        backgroundImage = [UIImage imageNamed:@"4x4"];        
    } else if ( numberOfColumns == 4 && numberOfRows == 5 ) {
        backgroundImage = [UIImage imageNamed:@"4x5"];        
    } else if ( numberOfColumns == 4 && numberOfRows == 6 ) {
        backgroundImage = [UIImage imageNamed:@"4x6"];        
    }

    return backgroundImage;

}

- (UIView *)createGridWithRows:(int)numberOfRows andColumns:(int)numberOfColumns {
    
    // Create and show new grid
    // Size is a function of the number of rows
    int gridWidth = [self calculateWidthOfGridFor:numberOfRows];
    int gridHeight = [self calculateHeightOfGridFor:numberOfColumns] + 60;
    
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

    [super dealloc];
}
@end
