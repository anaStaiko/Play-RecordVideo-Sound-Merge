//
//  RecordVoiceViewController.m
//  AVFoundationPlayRecord
//
//  Created by Anastasiia Staiko on 3/20/16.
//  Copyright © 2016 Anastasiia Staiko. All rights reserved.
//

#import "RecordVoiceViewController.h"


@interface RecordVoiceViewController ()

@end

@implementation RecordVoiceViewController


@synthesize playButton = _playButton;
@synthesize recordButton = _recordButton;
@synthesize isRecording = _isRecording;

- (void)viewDidLoad {
    [super viewDidLoad];

    self.isRecording = NO;
    [self.playButton setEnabled:NO];
    self.playButton.titleLabel.alpha = 0.5;
    recordedFile = [NSURL fileURLWithPath:[NSTemporaryDirectory() stringByAppendingString:@"RecordedFile"]];
    
    AVAudioSession *session = [AVAudioSession sharedInstance];
    
    NSError *sessionError;
    [session setCategory:AVAudioSessionCategoryPlayAndRecord error:&sessionError];
    
    if(session == nil)
        NSLog(@"Error creating session: %@", [sessionError description]);
    else
        [session setActive:YES error:nil];

}

- (void)viewDidUnload
{
    [self setPlayButton:nil];
    [self setRecordButton:nil];
    recorder = nil;
    player = nil;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    // [fileManager removeItemAtPath:recordedFile.path error:nil];
    [fileManager removeItemAtURL:recordedFile error:nil];
    recordedFile = nil;
    [super viewDidUnload];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)playPause:(id)sender
{
    if([player isPlaying])
    {
        [player pause];
        [self.playButton setTitle:@"Play" forState:UIControlStateNormal];
    }
    else
    {
        [player play];
        [self.playButton setTitle:@"Pause" forState:UIControlStateNormal];
    }
}

- (IBAction)startStopRecording:(id)sender
{
    if(!self.isRecording)
    {
        self.isRecording = YES;
        [self.recordButton setTitle:@"STOP" forState:UIControlStateNormal];
        [self.playButton setEnabled:NO];
        [self.playButton.titleLabel setAlpha:0.5];
        recorder = [[AVAudioRecorder alloc] initWithURL:recordedFile settings:nil error:nil];
        [recorder prepareToRecord];
        [recorder record];
        player = nil;
    }
    else
    {
        self.isRecording = NO;
        [self.recordButton setTitle:@"REC" forState:UIControlStateNormal];
        [self.playButton setEnabled:YES];
        [self.playButton.titleLabel setAlpha:1];
        [recorder stop];
        recorder = nil;
        
        NSError *playerError;
        
        player = [[AVAudioPlayer alloc] initWithContentsOfURL:recordedFile error:&playerError];
        
        if (player == nil)
        {
            NSLog(@"ERror creating player: %@", [playerError description]);
        }
        player.delegate = self;
    }
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    [self.playButton setTitle:@"Play" forState:UIControlStateNormal];
}



@end
