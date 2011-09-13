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
    
    NSArray *incorrectPlacementArray = [[NSArray alloc] initWithObjects:
                                    [NSNumber numberWithInt:21], 
                                    [NSNumber numberWithInt:22],
                                    [NSNumber numberWithInt:23], nil];
    
    // Test winning situation
    BOOL winResult = [gridVC checkIfGameWonWithAnswers:correctAnswersArray andPlacings:blockPlacementArray];
    GHAssertTrue(winResult, @"should have returned true, returned %d", winResult);
    
    // Test losing situation
    BOOL loseResult = [gridVC checkIfGameWonWithAnswers:incorrectPlacementArray andPlacings:blockPlacementArray];
    GHAssertFalse(loseResult, @"should have returned false, returned %d", loseResult);
    
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