//
//  RecordVideoViewController.m
//  AVFoundationPlayRecord
//
//  Created by Anastasiia Staiko on 3/18/16.
//  Copyright © 2016 Anastasiia Staiko. All rights reserved.
//

#import "RecordVideoViewController.h"

@interface RecordVideoViewController ()

@end

@implementation RecordVideoViewController

- (IBAction)recordAndPlay:(id)sender {
    
    [self startCameraControllerFromViewController:self usingDelegate:self];
}


-(BOOL)startCameraControllerFromViewController:(UIViewController*)controller
                                 usingDelegate:(id )delegate {
 
    if (([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] == NO)
        || (delegate == nil)
        || (controller == nil)) {
        return NO;
    }
    UIImagePickerController *cameraUI = [[UIImagePickerController alloc] init];
    cameraUI.sourceType = UIImagePickerControllerSourceTypeCamera;
    cameraUI.mediaTypes = [[NSArray alloc] initWithObjects:(NSString *)kUTTypeMovie, nil];
    cameraUI.allowsEditing = NO;
    cameraUI.delegate = delegate;
    [controller presentViewController:cameraUI animated:YES completion:nil];
    return YES;
}


-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    NSString *mediaType = [info objectForKey: UIImagePickerControllerMediaType];
    [self dismissViewControllerAnimated:NO completion:nil];
    if (CFStringCompare ((__bridge_retained CFStringRef) mediaType, kUTTypeMovie, 0) == kCFCompareEqualTo) {
        NSString *moviePath = [[info objectForKey:UIImagePickerControllerMediaURL] path];
        if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(moviePath)) {
            UISaveVideoAtPathToSavedPhotosAlbum(moviePath, self,
                                                @selector(video:didFinishSavingWithError:contextInfo:), nil);
        } 
    }
}

-(void)video:(NSString*)videoPath didFinishSavingWithError:(NSError*)error contextInfo:(void*)contextInfo {
    if (error) {
        
        UIAlertController * alert=   [UIAlertController
                                      alertControllerWithTitle:@"Error"
                                      message:@"Video Saving Failed"
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
        
        
        UIAlertController * alert=   [UIAlertController
                                      alertControllerWithTitle:@"Video Saved"
                                      message:@"Saved to Photo Album"
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
        
    }
}


@end
