//
//  RecordVideoViewController.h
//  AVFoundationPlayRecord
//
//  Created by Anastasiia Staiko on 3/18/16.
//  Copyright © 2016 Anastasiia Staiko. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <AssetsLibrary/AssetsLibrary.h>


@interface RecordVideoViewController : UIViewController

- (IBAction)recordAndPlay:(id)sender;

-(BOOL)startCameraControllerFromViewController:(UIViewController*)controller usingDelegate:(id )delegate;

-(void)video:(NSString *)videoPath didFinishSavingWithError:(NSError *)error contextInfo:(void*)contextInfo;

@end
