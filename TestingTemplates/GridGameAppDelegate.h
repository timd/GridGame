//
//  TestingTemplatesAppDelegate.h
//  TestingTemplates
//
//  Created by Tim Duckett on 13/09/2011.
//  Copyright 2011 Charismatic Megafauna Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GridGameViewController;

@interface GridGameAppDelegate : NSObject <UIApplicationDelegate>

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet GridGameViewController *viewController;

@end
