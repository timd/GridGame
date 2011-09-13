#import <GHUnitIOS/GHUnit.h> 
#import <OCMock/OCMock.h>
#import "GridGameViewController.h"

@interface GridGameViewControllerTests : GHTestCase { 
    GridGameViewController *gridVC;
}
@end

@implementation GridGameViewControllerTests

#pragma mark - Tests

-(void)testCalculations {
    
    float actualWidth = 196;
    float actualHeight = 196;
    float actualXOffset = 62;
    float numberOfRows = 3;
    float numberOfColumns = 3;
    
    float calcWidth = [gridVC calculateWidthOfGridFor:numberOfColumns];
    GHAssertEquals(calcWidth, actualWidth, @"width should be %f, is %f", actualWidth, calcWidth);
    
    float calcHeight = [gridVC calculateHeightOfGridFor:numberOfRows];
    GHAssertEquals(calcHeight, actualHeight, @"height should be %f, is %f", calcHeight, actualHeight);
    
    float calcOffset = [gridVC calculateXoffsetForGridWithColumns:numberOfColumns];
    GHAssertEquals(calcOffset, actualXOffset, @"offset should be %f, is %f", calcOffset, actualXOffset);
   
}

-(void)testBackgroundImageIsCorrect {
    
    float cols = 3;
    float rows = 3;
    UIImage *actualImage = [UIImage imageNamed:@"3x3"];
    
    UIImage *backgroundView = [gridVC backgroundImageForRows:rows andColumns:cols];
    GHAssertEquals(backgroundView.size.height, actualImage.size.height, @"height of image should be %f, is %f", actualImage.size.height, backgroundView.size.height);
    GHAssertEquals(backgroundView.size.width, actualImage.size.width, @"width of image should be %f, is %f", actualImage.size.width, backgroundView.size.width);

    cols = 3;
    rows = 4;
    actualImage = [UIImage imageNamed:@"3x4"];
    
    backgroundView = [gridVC backgroundImageForRows:rows andColumns:cols];
    GHAssertEquals(backgroundView.size.height, actualImage.size.height, @"height of image should be %f, is %f", actualImage.size.height, backgroundView.size.height);
    GHAssertEquals(backgroundView.size.width, actualImage.size.width, @"width of image should be %f, is %f", actualImage.size.width, backgroundView.size.width);

    cols = 4;
    rows = 4;
    actualImage = [UIImage imageNamed:@"4x4"];
    
    backgroundView = [gridVC backgroundImageForRows:rows andColumns:cols];
    GHAssertEquals(backgroundView.size.height, actualImage.size.height, @"height of image should be %f, is %f", actualImage.size.height, backgroundView.size.height);
    GHAssertEquals(backgroundView.size.width, actualImage.size.width, @"width of image should be %f, is %f", actualImage.size.width, backgroundView.size.width);

    cols = 4;
    rows = 5;
    actualImage = [UIImage imageNamed:@"4x5"];
    
    backgroundView = [gridVC backgroundImageForRows:rows andColumns:cols];
    GHAssertEquals(backgroundView.size.height, actualImage.size.height, @"height of image should be %f, is %f", actualImage.size.height, backgroundView.size.height);
    GHAssertEquals(backgroundView.size.width, actualImage.size.width, @"width of image should be %f, is %f", actualImage.size.width, backgroundView.size.width);
    
    cols = 4;
    rows = 6;
    actualImage = [UIImage imageNamed:@"4x6"];
    
    backgroundView = [gridVC backgroundImageForRows:rows andColumns:cols];
    GHAssertEquals(backgroundView.size.height, actualImage.size.height, @"height of image should be %f, is %f", actualImage.size.height, backgroundView.size.height);
    GHAssertEquals(backgroundView.size.width, actualImage.size.width, @"width of image should be %f, is %f", actualImage.size.width, backgroundView.size.width);
    
}

-(void)testPositionsArrayCreation {
    
    for (int rows=3; rows == 5; rows++) {
        
        for (int cols = 3; cols == 4; cols++) {
    
            //int rows = 3;
            //int cols = 3;
            
            int expectedElements = rows * cols;
            
            NSArray *testArray = [gridVC createArrayOfPositionsForRows:rows andColumns:cols];
            
            GHAssertEquals((int)[testArray count], expectedElements, @"are %d elements, should be %d", (int)[testArray count], expectedElements);
        }
    }
}

-(void)testButtonCreation {
    
    int cols = 3;
    int rows = 4;
    
    int expectedButtons = (rows * cols) + 1;
    
    UIView *gridView = [gridVC createGridWithRows:rows andColumns:cols];
    NSArray *xyPositions = [gridVC createArrayOfPositionsForRows:rows andColumns:cols];
    
    UIView *viewUnderTest = [gridVC addButtonsToView:gridView atPositions:xyPositions];
    
    NSArray *subViews = viewUnderTest.subviews;
    
    GHAssertEquals((int)[subViews count], expectedButtons , @"expected %d buttons, found %d", expectedButtons, (int)[subViews count]);
    
}

#pragma mark - Housekeeping

- (BOOL)shouldRunOnMainThread {
    // By default NO, but if you have a UI test or test dependent on running on the main thread return YES.
    // Also an async test that calls back on the main thread, you'll probably want to return YES.
    return NO;
}

- (void)setUpClass {
    // Run at start of all tests in the class
    gridVC = [[GridGameViewController alloc] init];
}

- (void)tearDownClass {
    // Run at end of all tests in the class
    [gridVC release];
    gridVC = nil;
}

- (void)setUp {
    // Run before each test method
}

- (void)tearDown {
    // Run after each test method
}  


@end