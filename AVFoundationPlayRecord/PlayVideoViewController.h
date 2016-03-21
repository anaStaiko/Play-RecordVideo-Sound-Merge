//
//  PlayVideoViewController.h
//  AVFoundationPlayRecord
//
//  Created by Anastasiia Staiko on 3/18/16.
//  Copyright © 2016 Anastasiia Staiko. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MobileCoreServices/UTCoreTypes.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>

@interface PlayVideoViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

- (IBAction)playVideo:(id)sender;

-(BOOL)startMediaBrowserFromViewController:(UIViewController*)controller usingDelegate:(id )delegate;


@end
