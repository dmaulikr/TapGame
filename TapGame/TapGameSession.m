//
//  TapGameSession.m
//  TapGame
//
//  Created by Sasha Reid on 15/05/2015.
//  Copyright (c) 2015 raredynamics. All rights reserved.
//

#import "TapGameSession.h"

@interface TapGameSession ()

@property (nonatomic, assign) NSInteger currentScore;
@property (nonatomic, assign) NSInteger currentBonus;
@property (nonatomic, assign) NSInteger topScore;
@property (nonatomic, assign) NSInteger lives;
@property (nonatomic, assign) NSInteger currentLevel;
@property (nonatomic, strong) NSMutableArray * officialSequence;
@property (nonatomic, strong) NSMutableArray * enteredSequence;

// A way of storing constants
typedef NS_ENUM(NSInteger, GameConstant) {
    kGameConstantLivesInitial =                 3,
    kGameConstantLivesAdditional =              3,
    kGameConstantPointsBase =                   10,
    kGameConstantPointsBonus =                  5,
    kGameConstantTotalButtons =                 6,
    kGameConstantButtonDelayInMilliseconds =    750
};

@end

@implementation TapGameSession



- (instancetype)init
{
    self = [super init];
    if (self) {
        
        // Setup variables that are only once off
        self.topScore = 0;
        self.officialSequence = [NSMutableArray array];
        self.enteredSequence = [NSMutableArray array];
        
    }
    return self;
}




- (void) resetGame {
    
    // This method sets up the variables after a game reset.
    // It's also used to start the game for the first time
    
    // Setup variables
    self.currentScore = 0;
    self.currentBonus = 0;
    self.currentLevel = 0;
    self.lives = kGameConstantLivesInitial;
    [self.officialSequence removeAllObjects];
    [self.enteredSequence removeAllObjects];
    
    // Starts the next turn
    [self startNextTurn];
}




- (void) startNextTurn {
    
    // This method starts the next turn.
    // It's called after the user's input has finished processing or at the very start
    
    // Clear the user's entered sequence ready for the next round
    [self.enteredSequence removeAllObjects];

    // Add additinoal lives to the user if they've gone past the threshold
    [self checkIfAchievedAdditionalLives];

    // Increment the level as we're starting the next turn
    self.currentLevel = self.currentLevel + 1;
    
    // Generate the next number and store it in the offical array
    [self.officialSequence addObject:[self generateNextSequenceNumber]];
    
    // Fire off the delegates that will update the UI in the controller
    [self.delegate tapGameSession:self didUpdateLevel:self.currentLevel];
    [self.delegate tapGameSession:self didUpdateLives:self.lives];
    [self.delegate tapGameSession:self didUpdateScore:self.currentScore withPoints:0];

    // Call the method that plays the sequence to the user through the delgate
    [self playbackFullSequenceWithButtonDelays];
}




- (NSNumber *) generateNextSequenceNumber {
    
    // This method generates a number between 1 and 6 and returns it.
    // The calling method will update the offical sequence array
    
    NSNumber * generatedNumber = [NSNumber numberWithInt:arc4random_uniform(kGameConstantTotalButtons) + 1];
    
    return generatedNumber;
}



- (void) playbackFullSequenceWithButtonDelays {
    
    // This method plays the full sequence back to the user
    // It calls the delegate to highlight each button at specific intervals so the controller doesn't have to
    
    NSLog(@" ");
    NSLog(@"** Round %ld **", (long)self.currentLevel);

    NSInteger indexOfNumber = 1;
    
    for (NSNumber * thisNumber in self.officialSequence) {
        
        // This calls the delegate after set intervals and tells it to highlight the appropriate button
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (kGameConstantButtonDelayInMilliseconds * indexOfNumber) * NSEC_PER_MSEC), dispatch_get_main_queue(), ^{
            [self.delegate tapGameSession:self shouldAnimateButton:thisNumber.integerValue isLastInSequence:thisNumber.integerValue < self.officialSequence.count? NO : YES];
            NSLog(@"%ld) %ld",indexOfNumber, thisNumber.integerValue);
        });

        indexOfNumber++;
    }
}



- (void) sendButtonInput:(NSInteger) input {
    
    // The UI Controller calls this method
    // It assess the input value and compares it to the required sequence
    // It detects when the entire sequence has been completed and moves to the next turn
    // It also detects errors and when the user is out of lives
    
    // Find the index of the number the user has entered. This index is used to compare against the offical sequence.
    NSInteger indexOfNumberToCompare = self.enteredSequence.count;
    
    // Grab the official sequence number ready to compare
    NSNumber * numberToCompare = [self.officialSequence objectAtIndex:indexOfNumberToCompare];
    
    // Create a Boolean to show whether the correct number was inputted
    BOOL correctInput = numberToCompare.integerValue == input ? YES : NO;
    NSLog(@"%ld) %ld: %ld %@", indexOfNumberToCompare +1, numberToCompare.integerValue, input, correctInput? @"✔" : @"- Incorrect. Guess again");

    if (correctInput == YES) {
        
        // The correct input was entered. Add it to the list
        [self.enteredSequence addObject:[NSNumber numberWithInteger:input]];
        
        if (self.enteredSequence.count >= self.officialSequence.count) {
            
            // All the numbers have been entered for this round / turn. Add any points and start the next turn
            [self addPointsForCorrectGuess];
            [self startNextTurn];
        }
    }
    else if (correctInput == NO) {
        
        // Incorrect input. Remove lives and reset multiplier
        self.lives = self.lives -1;
        self.currentBonus = 0;
        
        // Call the delegates to show the user the updated lives and incorrect button
        [self.delegate tapGameSession:self didUpdateLives:self.lives];
        [self.delegate tapGameSession:self didSelectIncorrectButton:input];
        NSLog(@"Lives Remaining: %ld", self.lives);

        if (self.lives <= 0) {
            
            // User has no move lives.
            NSLog(@" ");
            NSLog(@"Game Over. Restarting");
            BOOL isTopScore = self.currentScore > self.topScore? YES : NO;
            [self.delegate tapGameSession:self didFinishGameWithScore:self.currentScore isTopScore:isTopScore];
        }
    }
}



- (void) addPointsForCorrectGuess {
    
    // This controls adding points to the board and is called at the end of a round
    // It also increments the bonus that's awarded
    
    self.currentScore = self.currentScore + kGameConstantPointsBase + self.currentBonus;
    
    self.currentBonus = self.currentBonus + kGameConstantPointsBonus;
    
    NSLog(@"Score: %ld   Next Bonus: %ld   Lives: %ld", self.currentScore, self.currentBonus, self.lives);
}



- (void) checkIfAchievedAdditionalLives {
    
    // This is called at the start of every turn
    // It checks if you've passed the bonus life threshold
    
    BOOL bonusAchieved = self.currentLevel % kGameConstantLivesAdditional == 0? YES : NO;
    
    if (self.currentLevel != 0 && bonusAchieved == YES) {
        
        // It's not the very first round and the bonus should be awarded.
        self.lives = self.lives +1;
        
        // Call the delegate to show the life increase
        [self.delegate tapGameSession:self didUpdateLives:self.lives];
        NSLog(@"New life added. New Lives: %ld", self.lives);
    }
}





@end
