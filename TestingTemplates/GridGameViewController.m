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
    columns = 4;
    rows = 5;
    
    // Create and show new grid
    UIView *gridView = [self createGridWithRows:rows andColumns:columns];
    
    NSArray *xyPositions = [self createArrayOfPositionsForRows:rows andColumns:columns];
    
    // Load buttons onto the view
    UIView *beButtonedView = [self addButtonsToView:gridView atPositions:xyPositions];
    
    [self.view addSubview:beButtonedView];

}

-(IBAction)didTapGridButton:(id)sender {
    
    UIButton *tappedButton = (UIButton *)sender;
    if ([tappedButton backgroundImageForState:UIControlStateNormal] == [UIImage imageNamed:@"whiteButtonBackground"]) {
        [tappedButton setBackgroundImage:[UIImage imageNamed:@"blueButtonBackground"] forState:UIControlStateNormal];
    } else {
        [tappedButton setBackgroundImage:[UIImage imageNamed:@"whiteButtonBackground"] forState:UIControlStateNormal];
    }
    
    NSLog(@"Button %d tapped", tappedButton.tag);
    
}

-(UIView *)addButtonsToView:(UIView *)theView atPositions:(NSArray *)positionsArray {
    
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
    
    UIView *gridView = [[[UIView alloc] initWithFrame:CGRectMake([self calculateXoffsetForGridWithColumns:numberOfColumns], 60, gridWidth, gridHeight)] autorelease];
    UIImageView *gridImageView = [[UIImageView alloc] initWithImage:backgroundImage];
    
    [gridView addSubview:gridImageView];
    
    return gridView;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
