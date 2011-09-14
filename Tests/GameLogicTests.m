#import <GHUnitIOS/GHUnit.h> 
#import <OCMock/OCMock.h>

#import "GridGameViewController.h"

@interface GameLogicTests : GHTestCase { 
    GridGameViewController *gridVC;
}
@end

@implementation GameLogicTests

#pragma mark - Tests

-(void)testCheckIfGameWonMethod {
    
    NSArray *blockPlacementArray = [[NSArray alloc] initWithObjects:
                                    [NSNumber numberWithInt:21], 
                                    [NSNumber numberWithInt:22],
                                    [NSNumber numberWithInt:23], nil];
    
    NSArray *correctAnswersArray = [NSArray arrayWithArray:blockPlacementArray];
    
    NSArray *unsortedCorrectAnswers = [[NSArray alloc] initWithObjects:
                                       [NSNumber numberWithInt:23], 
                                       [NSNumber numberWithInt:21],
                                       [NSNumber numberWithInt:22], nil];
    
    NSArray *incorrectPlacementArray = [[NSArray alloc] initWithObjects:
                                    [NSNumber numberWithInt:33], 
                                    [NSNumber numberWithInt:41],
                                    [NSNumber numberWithInt:52], nil];
    
    // Test winning situation
    BOOL winResult = [gridVC checkIfGameWonWithAnswers:correctAnswersArray andPlacings:blockPlacementArray];
    GHAssertTrue(winResult, @"should have returned true, returned %d", winResult);

    // Test winning situation with unsorted array of answers
    BOOL unsortedResult = [gridVC checkIfGameWonWithAnswers:unsortedCorrectAnswers andPlacings:blockPlacementArray];
    GHAssertTrue(unsortedResult, @"should have returned true, returned %d", winResult);

    // Test losing situation
    BOOL loseResult = [gridVC checkIfGameWonWithAnswers:incorrectPlacementArray andPlacings:blockPlacementArray];
    GHAssertFalse(loseResult, @"should have returned false, returned %d", loseResult);
    
}

-(void)testCheckIfGameWonProducesCorrectValuesForAWin {
    
    // Set current values
    int testPoints = 0;
    int testTurn = 1;
    int testLives = 2;
    int testCorrectGuesses = 0;
    
    gridVC.points = testPoints;
    gridVC.turn = testTurn;
    gridVC.lives = testLives;
    gridVC.correctGuessesThisTurn = testCorrectGuesses;
    
    // Create test data arrays
    NSArray *blockPlacementArray = [[NSArray alloc] initWithObjects:
                                    [NSNumber numberWithInt:21], 
                                    [NSNumber numberWithInt:22],
                                    [NSNumber numberWithInt:23], nil];
    
    NSArray *correctAnswersArray = [NSArray arrayWithArray:blockPlacementArray];
    
    // Test values are incremented correctly on win
    BOOL testResult = [gridVC checkIfGameWonWithAnswers:correctAnswersArray andPlacings:blockPlacementArray];
    
    // Test results
    if (testResult) {
        
        // Test that points should have increased by 1 for a win
        GHAssertEquals(gridVC.points, testPoints + 1, @"points are %d, should be %d", gridVC.points, testPoints + 1);
        
        // Test that turn should have increased by 1 for a win
        GHAssertEquals(gridVC.turn, testTurn + 1, @"points are %d, should be %d", gridVC.turn, testTurn + 1);
        
        // Test that lives should remain the same
        GHAssertEquals(gridVC.lives, testLives, @"points are %d, should be %d", gridVC.lives, testLives);

        // Test that correctGuessesThisTurn should have increased by 1 for a win
        GHAssertEquals(gridVC.correctGuessesThisTurn, testCorrectGuesses + 1, @"correctGuessesThisTurn are %d, should be %d", gridVC.correctGuessesThisTurn, testCorrectGuesses + 1);

        
    }
    
}

-(void)testCheckIfGameWonProducesCorrectValuesForALoss {
    
    // Set current values
    int testPoints = 0;
    int testTurn = 1;
    int testLives = 2;
    int testCorrectGuesses = 0;    

    gridVC.points = testPoints;
    gridVC.turn = testTurn;
    gridVC.lives = testLives;
    gridVC.correctGuessesThisTurn = testCorrectGuesses;    
    
    // Create test data arrays
    NSArray *blockPlacementArray = [[NSArray alloc] initWithObjects:
                                    [NSNumber numberWithInt:21], 
                                    [NSNumber numberWithInt:22],
                                    [NSNumber numberWithInt:23], nil];
    
    NSArray *incorrectPlacementArray = [[NSArray alloc] initWithObjects:
                                        [NSNumber numberWithInt:33], 
                                        [NSNumber numberWithInt:41],
                                        [NSNumber numberWithInt:52], nil];
    
    // Test values are incremented correctly on win
    BOOL testResult = [gridVC checkIfGameWonWithAnswers:incorrectPlacementArray andPlacings:blockPlacementArray];
    
    // Test results
    if (!testResult) {
        
        // Test that points should remain the same for a loss
        GHAssertEquals(gridVC.points, testPoints, @"points are %d, should be %d", gridVC.points, testPoints);
        
        // Test that turn should have increased by 1 for a loss
        GHAssertEquals(gridVC.turn, testTurn + 1, @"points are %d, should be %d", gridVC.turn, testTurn + 1);
        
        // Test that lives should decreased by 1 for a loss
        GHAssertEquals(gridVC.lives, testLives - 1, @"points are %d, should be %d", gridVC.lives, testLives - 1);
        
        // Test that correctGuessesThisTurn should not have changed
        GHAssertEquals(gridVC.correctGuessesThisTurn, testCorrectGuesses, @"correctGuessesThisTurn are %d, should be %d", gridVC.correctGuessesThisTurn, testCorrectGuesses);        
        
    }
    
}

-(void)testShouldLevelIncreaseMethod {

    // Test a yes situation
    int testTurn = 3;
    int testLevel = 1;
    int testCorrectGuesses = 2;
    
    gridVC.turn = testTurn;
    gridVC.level = testLevel;
    gridVC.correctGuessesThisTurn = testCorrectGuesses;
    
    [gridVC shouldLevelIncrease];
    
    // Test success
    GHAssertEquals(gridVC.turn, 1, @"turn should be reset to 1, is %d", gridVC.turn);
    GHAssertEquals(gridVC.level, testLevel + 1, @"level should have increased to %d, is %d", testLevel + 1, gridVC.level);
    GHAssertEquals(gridVC.correctGuessesThisTurn, 0, @"correctGuessesThisTurn should be 0, got %d", gridVC.correctGuessesThisTurn);
    
    // Test a no situation
    testTurn = 1;
    testLevel = 1;
    testCorrectGuesses = 1;

    gridVC.turn = testTurn;
    gridVC.level = testLevel;
    gridVC.correctGuessesThisTurn = testCorrectGuesses;
    
    [gridVC shouldLevelIncrease];
    
    // Test success
    GHAssertEquals(gridVC.turn, testTurn, @"turn should remain %d, is %d", testTurn ,gridVC.turn);
    GHAssertEquals(gridVC.level, testLevel, @"level should remain %d, is %d", testLevel, gridVC.level);
    GHAssertEquals(gridVC.correctGuessesThisTurn, testCorrectGuesses, @"correctGuessesThisTurn not have changed from %d, got %d", testCorrectGuesses, gridVC.correctGuessesThisTurn);
    

}

-(void)testShouldNewRoundStartMethod {
    
    // Test a yes situation
    int testLives = 1;
    int testLevel = 1;
    
    gridVC.lives = testLives;
    gridVC.level = testLevel;
    
    BOOL result = [gridVC shouldNewRoundStart];
    
    GHAssertEquals(result, YES, @"should have returned YES, returned %d", result);
    
    // lives = INCORRECT / level == CORRECT
    testLives = 0;
    testLevel = 1;
    
    gridVC.lives = testLives;
    gridVC.level = testLevel;
    
    result = [gridVC shouldNewRoundStart];
    GHAssertEquals(result, NO, @"should have returned NO, returned %d", result);
    
    // lives = CORRECT / level == INCORRECT
    testLives = 1;
    testLevel = 5;
    
    gridVC.lives = testLives;
    gridVC.level = testLevel;
    
    result = [gridVC shouldNewRoundStart];
    GHAssertEquals(result, NO, @"should have returned NO, returned %d", result);
    
    // lives = INCORRECT / level == INCORRECT
    testLives = 0;
    testLevel = 6;
    
    gridVC.lives = testLives;
    gridVC.level = testLevel;
    
    result = [gridVC shouldNewRoundStart];
    GHAssertEquals(result, NO, @"should have returned NO, returned %d", result);
    
}

-(void)testWasGameLostMethod {
    
    // Test correct
    int testLives = 0;
    gridVC.lives = testLives;
    
    BOOL result = [gridVC wasGameLost];
    GHAssertEquals(result, YES, @"Should return YES, returned NO");

    // Test incorrect
    testLives = 2;
    gridVC.lives = testLives;
    
    result = [gridVC wasGameLost];
    GHAssertEquals(result, NO, @"Should return NO, returned YES");
    
}

-(void)testResizeBoard{
    
    // C x R
    // Case 1: 3x3 to 4x3
    // Set up initial values
    int testRows = 3;
    int testCols = 3;

    int newRows = 3;
    int newCols = 4;
    
    gridVC.rows = testRows;
    gridVC.columns = testCols;
    
    [gridVC increaseBoardSize];
    
    GHAssertEquals(gridVC.rows, newRows, @"rows are %d, should be %d", gridVC.rows, newRows);
    GHAssertEquals(gridVC.columns, newCols, @"cols are %d, should be %d", gridVC.columns, newCols);
    
    // Case 2: 3x4 to 4x4
    // Set up initial values
    testRows = 3;
    testCols = 4;
    
    newRows = 4;
    newCols = 4;
    
    gridVC.rows = testRows;
    gridVC.columns = testCols;
    
    [gridVC increaseBoardSize];
    
    GHAssertEquals(gridVC.rows, newRows, @"rows are %d, should be %d", gridVC.rows, newRows);
    GHAssertEquals(gridVC.columns, newCols, @"rows are %d, should be %d", gridVC.columns, newCols);

    // Case 3: 4x4 to 4x5
    // Set up initial values
    testRows = 4;
    testCols = 4;
    
    newRows = 5;
    newCols = 4;
    
    gridVC.rows = testRows;
    gridVC.columns = testCols;
    
    [gridVC increaseBoardSize];
    
    GHAssertEquals(gridVC.rows, newRows, @"rows are %d, should be %d", gridVC.rows, newRows);
    GHAssertEquals(gridVC.columns, newCols, @"rows are %d, should be %d", gridVC.columns, newCols);

    // Case 4: 4x5 to 4x6
    // Set up initial values
    testRows = 5;
    testCols = 4;
    
    newRows = 6;
    newCols = 4;
    
    gridVC.rows = testRows;
    gridVC.columns = testCols;
    
    [gridVC increaseBoardSize];
    
    GHAssertEquals(gridVC.rows, newRows, @"rows are %d, should be %d", gridVC.rows, newRows);
    GHAssertEquals(gridVC.columns, newCols, @"rows are %d, should be %d", gridVC.columns, newCols);
    
}

#pragma mark - Housekeeping

- (BOOL)shouldRunOnMainThread {
    // By default NO, but if you have a UI test or test dependent on running on the main thread return YES.
    // Also an async test that calls back on the main thread, you'll probably want to return YES.
    return YES;
}

- (void)setUpClass {
    // Run at start of all tests in the class
    //    gridVC = [[GridGameViewController alloc] init];
    //    [gridVC loadView];
    
    gridVC = [[GridGameViewController alloc] initWithNibName:@"GridGameViewController" bundle:nil]; 
    UIView *testView = gridVC.view;

    //  [gridVC loadView];
    //    gridVC.view; 
    //    GHAssertNotNil([viewController webView], @"WebView: %@", [viewController webView]); 
    
    
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