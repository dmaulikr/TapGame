//
//  TapGameSession.h
//  TapGame
//
//  Created by Sasha Reid on 15/05/2015.
//  Copyright (c) 2015 raredynamics. All rights reserved.
//

#import <Foundation/Foundation.h>


@class TapGameSession;  //define class

@protocol TapGameSessionDelegate <NSObject> //define delegate protocol

@required

// UI value updates such as lives, level and score
- (void) tapGameSession:(TapGameSession *)tapGameSession didUpdateLives:(NSInteger) currentLives;
- (void) tapGameSession:(TapGameSession *)tapGameSession didUpdateLevel:(NSInteger) currentLevel;
- (void) tapGameSession:(TapGameSession *)tapGameSession didUpdateScore:(NSInteger) currentScore withPoints:(NSInteger)withPoints;

// Buttons that need updates based on a sequence replay or an incorrect button being selected
- (void) tapGameSession:(TapGameSession *)tapGameSession shouldAnimateButton:(NSInteger) buttonIndex isLastInSequence:(BOOL)isLastInSequence;
- (void) tapGameSession:(TapGameSession *)tapGameSession didSelectIncorrectButton:(NSInteger) buttonIndex;

// Change in game state such as game over
- (void) tapGameSession:(TapGameSession *)tapGameSession didFinishGameWithScore:(NSInteger) finalScore isTopScore:(BOOL)isTopScore;

@end


@interface TapGameSession : NSObject

//define TapGameSession as delegate
@property (nonatomic, weak) id <TapGameSessionDelegate> delegate;

// The controller only needs to call 2 functions
- (void) resetGame;
- (void) sendButtonInput:(NSInteger) input;

@end
