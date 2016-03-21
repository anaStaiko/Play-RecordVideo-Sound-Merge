//
//  MergeVideoViewController.m
//  AVFoundationPlayRecord
//
//  Created by Anastasiia Staiko on 3/18/16.
//  Copyright © 2016 Anastasiia Staiko. All rights reserved.
//

#import "MergeVideoViewController.h"

@interface MergeVideoViewController ()

@end

@implementation MergeVideoViewController

@synthesize firstAsset, secondAsset, audioAsset;
@synthesize activityView;


- (void)viewDidUnload
{
    [self setActivityView:nil];
    [super viewDidUnload];

}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (IBAction)loadAssetOne:(id)sender {
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum] == NO) {

        UIAlertController * alert=   [UIAlertController
                                      alertControllerWithTitle:@"Error"
                                      message:@"No Saved Album Found"
                                      preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction
                             actionWithTitle:@"OK"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 [self dismissViewControllerAnimated:YES completion:nil];
                             }];
        
        [alert addAction:ok];
        [self presentViewController:alert animated:YES completion:nil];

    } else {
        isSelectingAssetOne = TRUE;
        [self startMediaBrowserFromViewController:self usingDelegate:self];
    }
}


- (IBAction)loadAssetTwo:(id)sender {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum] == NO) {

        UIAlertController * alert=   [UIAlertController
                                      alertControllerWithTitle:@"Error"
                                      message:@"No Saved Album Found"
                                      preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction
                             actionWithTitle:@"OK"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 [self dismissViewControllerAnimated:YES completion:nil];
                             }];
        
        [alert addAction:ok];
        [self presentViewController:alert animated:YES completion:nil];
        
    } else {
        isSelectingAssetOne = FALSE;
        [self startMediaBrowserFromViewController:self usingDelegate:self];
    }
}


- (IBAction)loadAudio:(id)sender {
    
    MPMediaPickerController *mediaPicker = [[MPMediaPickerController alloc] initWithMediaTypes:MPMediaTypeAny];
    mediaPicker.delegate = self;
    mediaPicker.prompt = @"Select Audio";
    [self presentViewController:mediaPicker animated:YES completion:nil];
}



-(void) mediaPicker:(MPMediaPickerController *)mediaPicker didPickMediaItems:(MPMediaItemCollection *)mediaItemCollection {
    NSArray *selectedSong = [mediaItemCollection items];
    if ([selectedSong count] > 0) {
        MPMediaItem *songItem = [selectedSong objectAtIndex:0];
        NSURL *songURL = [songItem valueForProperty:MPMediaItemPropertyAssetURL];
        audioAsset = [AVAsset assetWithURL:songURL];
        NSLog(@"Audio Loaded");
               UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Asset Loaded" message:@"Audio Loaded"
                                                       delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
      [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)mediaPickerDidCancel:(MPMediaPickerController *)mediaPicker {
      [self dismissViewControllerAnimated:YES completion:nil];
}

// For responding to the user tapping Cancel.
- (void) imagePickerControllerDidCancel: (UIImagePickerController *) picker {
      [self dismissViewControllerAnimated:YES completion:nil];
}

-(BOOL)startMediaBrowserFromViewController:(UIViewController*)controller usingDelegate:(id)delegate {

    if (([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum] == NO)
        || (delegate == nil)
        || (controller == nil)) {
        return NO;
    }
    UIImagePickerController *mediaUI = [[UIImagePickerController alloc] init];
    mediaUI.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    mediaUI.mediaTypes = [[NSArray alloc] initWithObjects:(NSString *)kUTTypeMovie, nil];
    mediaUI.allowsEditing = YES;
    mediaUI.delegate = delegate;
    [controller presentViewController:mediaUI animated:YES completion:nil];
    return YES;
}



-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    NSString *mediaType = [info objectForKey: UIImagePickerControllerMediaType];
    [self dismissViewControllerAnimated:NO completion:nil];
    if (CFStringCompare ((__bridge_retained CFStringRef) mediaType, kUTTypeMovie, 0) == kCFCompareEqualTo) {
        if (isSelectingAssetOne){
            NSLog(@"Video One  Loaded");
            UIAlertController * alert=   [UIAlertController
                                          alertControllerWithTitle:@"Asset Loaded"
                                          message:@"Video One Loaded"
                                          preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* ok = [UIAlertAction
                                 actionWithTitle:@"OK"
                                 style:UIAlertActionStyleDefault
                                 handler:^(UIAlertAction * action)
                                 {
                                     [self dismissViewControllerAnimated:YES completion:nil];
                                 }];
            
            [alert addAction:ok];
            [self presentViewController:alert animated:YES completion:nil];
            firstAsset = [AVAsset assetWithURL:[info objectForKey:UIImagePickerControllerMediaURL]];
        } else {
            NSLog(@"Video two Loaded");
            UIAlertController * alert=   [UIAlertController
                                          alertControllerWithTitle:@"Asset Loaded"
                                          message:@"Video Two Loaded"
                                          preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* ok = [UIAlertAction
                                 actionWithTitle:@"OK"
                                 style:UIAlertActionStyleDefault
                                 handler:^(UIAlertAction * action)
                                 {
                                     [self dismissViewControllerAnimated:YES completion:nil];
                                 }];
            
            [alert addAction:ok];
            [self presentViewController:alert animated:YES completion:nil];
            secondAsset = [AVAsset assetWithURL:[info objectForKey:UIImagePickerControllerMediaURL]];
        }
    }
}


- (IBAction)mergeAndSave:(id)sender {
    
    if(firstAsset !=nil && secondAsset!=nil){
        [activityView startAnimating];
        //Create AVMutableComposition Object.This object will hold our multiple AVMutableCompositionTrack.
        AVMutableComposition* mixComposition = [[AVMutableComposition alloc] init];
        
        //Video tracks
        AVMutableCompositionTrack *firstTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
        [firstTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, firstAsset.duration) ofTrack:[[firstAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0] atTime:kCMTimeZero error:nil];
        
        AVMutableCompositionTrack *secondTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
        [secondTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, secondAsset.duration) ofTrack:[[secondAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0] atTime:firstAsset.duration error:nil];
        
        AVMutableVideoCompositionInstruction * MainInstruction = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
        MainInstruction.timeRange = CMTimeRangeMake(kCMTimeZero, CMTimeAdd(firstAsset.duration, secondAsset.duration));
        
        //Fixing view
        AVMutableVideoCompositionLayerInstruction *FirstlayerInstruction = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:firstTrack];
        AVAssetTrack *FirstAssetTrack = [[firstAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0];
        UIImageOrientation FirstAssetOrientation_  = UIImageOrientationUp;
        BOOL  isFirstAssetPortrait_  = NO;
        CGAffineTransform firstTransform = FirstAssetTrack.preferredTransform;
        if(firstTransform.a == 0 && firstTransform.b == 1.0 && firstTransform.c == -1.0 && firstTransform.d == 0)  {FirstAssetOrientation_= UIImageOrientationRight; isFirstAssetPortrait_ = YES;}
        if(firstTransform.a == 0 && firstTransform.b == -1.0 && firstTransform.c == 1.0 && firstTransform.d == 0)  {FirstAssetOrientation_ =  UIImageOrientationLeft; isFirstAssetPortrait_ = YES;}
        if(firstTransform.a == 1.0 && firstTransform.b == 0 && firstTransform.c == 0 && firstTransform.d == 1.0)   {FirstAssetOrientation_ =  UIImageOrientationUp;}
        if(firstTransform.a == -1.0 && firstTransform.b == 0 && firstTransform.c == 0 && firstTransform.d == -1.0) {FirstAssetOrientation_ = UIImageOrientationDown;}
        CGFloat FirstAssetScaleToFitRatio = 320.0/FirstAssetTrack.naturalSize.width;
        if(isFirstAssetPortrait_){
            FirstAssetScaleToFitRatio = 320.0/FirstAssetTrack.naturalSize.height;
            CGAffineTransform FirstAssetScaleFactor = CGAffineTransformMakeScale(FirstAssetScaleToFitRatio,FirstAssetScaleToFitRatio);
            [FirstlayerInstruction setTransform:CGAffineTransformConcat(FirstAssetTrack.preferredTransform, FirstAssetScaleFactor) atTime:kCMTimeZero];
        }else{
            CGAffineTransform FirstAssetScaleFactor = CGAffineTransformMakeScale(FirstAssetScaleToFitRatio,FirstAssetScaleToFitRatio);
            [FirstlayerInstruction setTransform:CGAffineTransformConcat(CGAffineTransformConcat(FirstAssetTrack.preferredTransform, FirstAssetScaleFactor),CGAffineTransformMakeTranslation(0, 160)) atTime:kCMTimeZero];
        }
        [FirstlayerInstruction setOpacity:0.0 atTime:firstAsset.duration];
        
        AVMutableVideoCompositionLayerInstruction *SecondlayerInstruction = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:secondTrack];
        AVAssetTrack *SecondAssetTrack = [[secondAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0];
        UIImageOrientation SecondAssetOrientation_  = UIImageOrientationUp;
        BOOL  isSecondAssetPortrait_  = NO;
        CGAffineTransform secondTransform = SecondAssetTrack.preferredTransform;
        if(secondTransform.a == 0 && secondTransform.b == 1.0 && secondTransform.c == -1.0 && secondTransform.d == 0)  {SecondAssetOrientation_= UIImageOrientationRight; isSecondAssetPortrait_ = YES;}
        if(secondTransform.a == 0 && secondTransform.b == -1.0 && secondTransform.c == 1.0 && secondTransform.d == 0)  {SecondAssetOrientation_ =  UIImageOrientationLeft; isSecondAssetPortrait_ = YES;}
        if(secondTransform.a == 1.0 && secondTransform.b == 0 && secondTransform.c == 0 && secondTransform.d == 1.0)   {SecondAssetOrientation_ =  UIImageOrientationUp;}
        if(secondTransform.a == -1.0 && secondTransform.b == 0 && secondTransform.c == 0 && secondTransform.d == -1.0) {SecondAssetOrientation_ = UIImageOrientationDown;}
        CGFloat SecondAssetScaleToFitRatio = 320.0/SecondAssetTrack.naturalSize.width;
        if(isSecondAssetPortrait_){
            SecondAssetScaleToFitRatio = 320.0/SecondAssetTrack.naturalSize.height;
            CGAffineTransform SecondAssetScaleFactor = CGAffineTransformMakeScale(SecondAssetScaleToFitRatio,SecondAssetScaleToFitRatio);
            [SecondlayerInstruction setTransform:CGAffineTransformConcat(SecondAssetTrack.preferredTransform, SecondAssetScaleFactor) atTime:firstAsset.duration];
        }else{
            ;
            CGAffineTransform SecondAssetScaleFactor = CGAffineTransformMakeScale(SecondAssetScaleToFitRatio,SecondAssetScaleToFitRatio);
            [SecondlayerInstruction setTransform:CGAffineTransformConcat(CGAffineTransformConcat(SecondAssetTrack.preferredTransform, SecondAssetScaleFactor),CGAffineTransformMakeTranslation(0, 160)) atTime:firstAsset.duration];
        }
        
        
        MainInstruction.layerInstructions = [NSArray arrayWithObjects:FirstlayerInstruction,SecondlayerInstruction,nil];;
        
        AVMutableVideoComposition *MainCompositionInst = [AVMutableVideoComposition videoComposition];
        MainCompositionInst.instructions = [NSArray arrayWithObject:MainInstruction];
        MainCompositionInst.frameDuration = CMTimeMake(1, 30);
        MainCompositionInst.renderSize = CGSizeMake(320.0, 480.0);
        
        //Audio track
        if(audioAsset!=nil){
            AVMutableCompositionTrack *AudioTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
            [AudioTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, CMTimeAdd(firstAsset.duration, secondAsset.duration)) ofTrack:[[audioAsset tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0] atTime:kCMTimeZero error:nil];
        }
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *myPathDocs =  [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"mergeVideo-%d.mov",arc4random() % 1000]];
        
        NSURL *url = [NSURL fileURLWithPath:myPathDocs];
        
        AVAssetExportSession *exporter = [[AVAssetExportSession alloc] initWithAsset:mixComposition presetName:AVAssetExportPresetHighestQuality];
        exporter.outputURL=url;
        exporter.outputFileType = AVFileTypeQuickTimeMovie;
        exporter.videoComposition = MainCompositionInst;
        exporter.shouldOptimizeForNetworkUse = YES;
        [exporter exportAsynchronouslyWithCompletionHandler:^
         {
             dispatch_async(dispatch_get_main_queue(), ^{
                 [self exportDidFinish:exporter];
             });
         }];
    }
}

-(void)exportDidFinish:(AVAssetExportSession*)session {
    if (session.status == AVAssetExportSessionStatusCompleted) {
        NSURL *outputURL = session.outputURL;
        ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
        if ([library videoAtPathIsCompatibleWithSavedPhotosAlbum:outputURL]) {
            [library writeVideoAtPathToSavedPhotosAlbum:outputURL completionBlock:^(NSURL *assetURL, NSError *error){
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (error) {
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Video Saving Failed"
                                                                       delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                        [alert show];
                    } else {
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Video Saved" message:@"Saved To Photo Album"
                                                                       delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                        [alert show];
                    }
                });
            }];
        }
    }
    audioAsset = nil;
    firstAsset = nil;
    secondAsset = nil;
    [activityView stopAnimating];
}


@end
