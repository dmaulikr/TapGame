//
//  ViewController.h
//  TapGame
//
//  Created by Sasha Reid on 15/05/2015.
//  Copyright (c) 2015 raredynamics. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TapGameSession.h"

@interface ViewController : UIViewController <TapGameSessionDelegate>

// These labels simply show the values such as score and lives to the user.
// They will be updated each time the delegate calls them
@property (weak, nonatomic) IBOutlet UILabel *currentScoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *topScoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *livesLabel;
@property (weak, nonatomic) IBOutlet UILabel *levelLabel;

// These are the 6 buttons that are shown to the user.
// Currently I have them highlighting during sequence playback or incorrect answers
// Can be done however the design dictates really.
@property (weak, nonatomic) IBOutlet UIButton *button1Outlet;
@property (weak, nonatomic) IBOutlet UIButton *button2Outlet;
@property (weak, nonatomic) IBOutlet UIButton *button3Outlet;
@property (weak, nonatomic) IBOutlet UIButton *button4Outlet;
@property (weak, nonatomic) IBOutlet UIButton *button5Outlet;
@property (weak, nonatomic) IBOutlet UIButton *button6Outlet;

// The actions for the 6 buttons. These just need to call TapGameSession with the number selected
- (IBAction)button1:(id)sender;
- (IBAction)button2:(id)sender;
- (IBAction)button3:(id)sender;
- (IBAction)button4:(id)sender;
- (IBAction)button5:(id)sender;
- (IBAction)button6:(id)sender;






@end

