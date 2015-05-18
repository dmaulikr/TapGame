//
//  ViewController.m
//  TapGame
//
//  Created by Sasha Reid on 15/05/2015.
//  Copyright (c) 2015 raredynamics. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (strong, nonatomic) TapGameSession * tapGame; // The session is created here

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Clear the top score label
    self.topScoreLabel.text = @"0";

    // Initialise the game and set the delegate to self.
    self.tapGame = [[TapGameSession alloc] init];
    self.tapGame.delegate = self;
    
    // This starts the game up which will start showing the sequence
    [self.tapGame resetGame];
}



#pragma mark - Tap Game Delegate Methods

- (void) tapGameSession:(TapGameSession *)tapGameSession didUpdateLives:(NSInteger) currentLives {
    // Lives
    self.livesLabel.text = [NSNumber numberWithInteger:currentLives].stringValue;
}

- (void) tapGameSession:(TapGameSession *)tapGameSession didUpdateLevel:(NSInteger) currentLevel {
    // Level
    self.levelLabel.text = [NSNumber numberWithInteger:currentLevel].stringValue;
}

- (void) tapGameSession:(TapGameSession *)tapGameSession didUpdateScore:(NSInteger) currentScore withPoints:(NSInteger)withPoints {
    // Score
    self.currentScoreLabel.text = [NSNumber numberWithInteger:currentScore].stringValue;
}

- (void) tapGameSession:(TapGameSession *)tapGameSession shouldAnimateButton:(NSInteger) buttonIndex isLastInSequence:(BOOL)isLastInSequence {
    
    // The delegate will call the button that needs to be highlighted after set time intervals.
    // The controller just needs to do the actual highlighting.
    
    // I'm adding the buttons to an array to make selection easy.
    // This can be done any any time or a different way but I want to highlight how simple it is
    NSMutableArray * buttonArray = [NSMutableArray array];
    [buttonArray addObject:self.button1Outlet];
    [buttonArray addObject:self.button2Outlet];
    [buttonArray addObject:self.button3Outlet];
    [buttonArray addObject:self.button4Outlet];
    [buttonArray addObject:self.button5Outlet];
    [buttonArray addObject:self.button6Outlet];
    
    // Select the button based on the delegate's selected button
    UIButton * buttonToHighlight = [buttonArray objectAtIndex:buttonIndex - 1];
    
    // Simple animation code. It's up to the controller how this is done
    [UIView animateWithDuration:0.25f animations:^{
        buttonToHighlight.backgroundColor = [UIColor greenColor];
    } completion:^( BOOL finished ){
        [UIView animateWithDuration:0.25f animations:^{
            buttonToHighlight.backgroundColor = [UIColor whiteColor];
        }];
    }];
}

- (void) tapGameSession:(TapGameSession *)tapGameSession didSelectIncorrectButton:(NSInteger) buttonIndex {
    
    // This is very similar to the tapGameSession:shouldAnimateButton method
    // The delegate will call the button if it's not part of the sequence.
    // The controller just needs to do the actual highlighting.
    // incorrect answers DO NOT start the sequence again (as per spec) but this can be changed
    
    NSMutableArray * buttonArray = [NSMutableArray array];
    [buttonArray addObject:self.button1Outlet];
    [buttonArray addObject:self.button2Outlet];
    [buttonArray addObject:self.button3Outlet];
    [buttonArray addObject:self.button4Outlet];
    [buttonArray addObject:self.button5Outlet];
    [buttonArray addObject:self.button6Outlet];
    
    // Select the button based on the delegate's selected button
    UIButton * buttonToShowError = [buttonArray objectAtIndex:buttonIndex - 1];
    
    // Simple animation code. It's up to the controller how this is done
    [UIView animateWithDuration:0.25f animations:^{
        buttonToShowError.backgroundColor = [UIColor redColor];
    } completion:^( BOOL finished ){
        [UIView animateWithDuration:0.25f animations:^{
            buttonToShowError.backgroundColor = [UIColor whiteColor];
        }];
    }];
}

- (void) tapGameSession:(TapGameSession *)tapGameSession didFinishGameWithScore:(NSInteger) finalScore isTopScore:(BOOL)isTopScore {
    
    // Called when the game is over.
    // I simply update the top score label if necessary and show some sort of "start again" alert
    
    if (isTopScore == YES) {
        self.topScoreLabel.text = [NSNumber numberWithInteger:finalScore].stringValue;
    }
    
    NSString * alertTitle = @"Game Over";
    NSString * alertMessage = @"You ran out of lives.";
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:alertTitle
                                          message:alertMessage
                                          preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *OKAction = [UIAlertAction
                                actionWithTitle:@"Restart Game"
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction *action)
                                {
                                    [tapGameSession resetGame];
                                }];
    [alertController addAction:OKAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}








#pragma mark - Buttons

- (IBAction)button1:(id)sender {
    [self.tapGame sendButtonInput:1];
}

- (IBAction)button2:(id)sender {
    [self.tapGame sendButtonInput:2];
}

- (IBAction)button3:(id)sender {
    [self.tapGame sendButtonInput:3];
}

- (IBAction)button4:(id)sender {
    [self.tapGame sendButtonInput:4];
}

- (IBAction)button5:(id)sender {
    [self.tapGame sendButtonInput:5];
}

- (IBAction)button6:(id)sender {
    [self.tapGame sendButtonInput:6];
}



@end
