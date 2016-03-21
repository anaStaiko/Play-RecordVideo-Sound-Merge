//
//  PlayVideoViewController.m
//  AVFoundationPlayRecord
//
//  Created by Anastasiia Staiko on 3/18/16.
//  Copyright © 2016 Anastasiia Staiko. All rights reserved.
//

#import "PlayVideoViewController.h"

@interface PlayVideoViewController ()

@property (strong, nonatomic) AVPlayerViewController *playerViewController;

@end

@implementation PlayVideoViewController

@synthesize playerViewController = _playerViewController;

- (IBAction)playVideo:(id)sender {
    
    [self startMediaBrowserFromViewController:self usingDelegate:self];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


-(BOOL)startMediaBrowserFromViewController:(UIViewController*)controller usingDelegate:(id )delegate {
    
    if (([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum]) == NO || (delegate == nil) || (controller == nil)) {
        return NO;
    }
    
    UIImagePickerController *mediaUI = [[UIImagePickerController alloc] init];
    mediaUI.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    mediaUI.mediaTypes = [[NSArray alloc] initWithObjects:(NSString *) kUTTypeMovie, nil];
    mediaUI.allowsEditing = YES;
    mediaUI.delegate = delegate;
    [controller presentViewController:mediaUI animated:YES completion:nil];
    return YES;
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    [self dismissViewControllerAnimated:NO completion:nil];
    if (CFStringCompare ((__bridge_retained CFStringRef)mediaType, kUTTypeMovie, 0) == kCFCompareEqualTo) {
    MPMoviePlayerViewController *theMovie = [[MPMoviePlayerViewController alloc]
                                                 initWithContentURL:[info objectForKey:UIImagePickerControllerMediaURL]];
    [self presentViewController:theMovie animated:YES completion:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(myMovieFinishedCallback:)
                                                     name:MPMoviePlayerPlaybackDidFinishNotification object:theMovie];
    }
    
}

// Cancel

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
}


//Release the controller

-(void)myMovieFinishedCallback:(NSNotification*)aNotification {
    [self dismissMoviePlayerViewControllerAnimated];
    MPMoviePlayerController *theMovie = [aNotification object];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:theMovie];
}


@end
