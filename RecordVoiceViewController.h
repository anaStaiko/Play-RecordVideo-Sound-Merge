//
//  RecordVoiceViewController.h
//  AVFoundationPlayRecord
//
//  Created by Anastasiia Staiko on 3/20/16.
//  Copyright © 2016 Anastasiia Staiko. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface RecordVoiceViewController : UIViewController <AVAudioPlayerDelegate> {
    
    NSURL *recordedFile;
    AVAudioPlayer *player;
    AVAudioRecorder *recorder;
    BOOL isRecording;
    
}

@property (nonatomic) BOOL isRecording;
@property (weak, nonatomic) IBOutlet UIButton *playButton;
@property (weak, nonatomic) IBOutlet UIButton *recordButton;

- (IBAction)playPause:(id)sender;

- (IBAction)startStopRecording:(id)sender;

@end
