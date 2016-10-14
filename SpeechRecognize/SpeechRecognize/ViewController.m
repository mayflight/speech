//
//  ViewController.m
//  SpeechRecognize
//
//  Created by 句芒 on 16/10/13.
//  Copyright © 2016年 fanwei. All rights reserved.
//

#import "ViewController.h"
#import <Speech/Speech.h>
@interface ViewController ()

@end

@implementation ViewController {
    AVAudioEngine * auengine;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    auengine = [[AVAudioEngine alloc] init];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)speechBuffer:(id)sender {
    //请求权限
    [SFSpeechRecognizer requestAuthorization:^(SFSpeechRecognizerAuthorizationStatus status) {
        if (status == SFSpeechRecognizerAuthorizationStatusAuthorized) {
            [self recognizeAudioBuffer];
        }
    }];

}

- (IBAction)stopBuffer:(UIButton *)sender {
    [auengine stop];
}

- (IBAction)resetBuffer:(UIButton *)sender {
    [auengine reset];
}

- (IBAction)pauseBuffer:(UIButton *)sender {
    [auengine pause];
}

- (IBAction)prepar:(UIButton *)sender {
    [auengine prepare];
}

- (IBAction)speechRecoginze:(UIButton *)sender {
    //请求权限
    [SFSpeechRecognizer requestAuthorization:^(SFSpeechRecognizerAuthorizationStatus status) {
        if (status == SFSpeechRecognizerAuthorizationStatusAuthorized) {
            NSURL *url = [[NSBundle mainBundle] URLForResource:@"speech" withExtension:@"m4a"];
            [self recognizeAudioFile:url];
        }
    }];
}

- (void)recognizeAudioFile:(NSURL *)url {
    SFSpeechRecognizer *recongize = [[SFSpeechRecognizer alloc] init];
    SFSpeechURLRecognitionRequest *request = [[SFSpeechURLRecognitionRequest alloc] initWithURL:url];
    [recongize recognitionTaskWithRequest:request resultHandler:^(SFSpeechRecognitionResult * _Nullable result, NSError * _Nullable error) {
        if (result) {
            self.speechText.text = result.bestTranscription.formattedString;
        }
        if (error) {
            self.speechText.text = error.description;
        }
    }];
}



- (void)recognizeAudioBuffer {
    
    self.bufferButton.userInteractionEnabled = NO;
    
    SFSpeechRecognizer *recognize = [[SFSpeechRecognizer alloc] init];
    SFSpeechAudioBufferRecognitionRequest *requestbuffer = [[SFSpeechAudioBufferRecognitionRequest alloc] init];
    
  
    
    
    
    AVAudioSession *session = [AVAudioSession sharedInstance];
    NSError *error;
    [session setCategory:AVAudioSessionCategoryRecord error:&error];
    if (error) {
        self.speechText.text = error.description;
        return;
    }
    [session setMode:AVAudioSessionModeMeasurement error:&error];
    if (error) {
        self.speechText.text = error.description;
        return;
    }
    [session setActive:YES withOptions:AVAudioSessionSetActiveOptionNotifyOthersOnDeactivation error:&error];
    if (error) {
         self.speechText.text = error.description;
        return;
    }

    if (!auengine.inputNode) {
        self.speechText.text = @"无输入节点";
        return;

    }
    
    
    [auengine.inputNode installTapOnBus:0 bufferSize:1024 format:[auengine.inputNode outputFormatForBus:0] block:^(AVAudioPCMBuffer * _Nonnull buffer, AVAudioTime * _Nonnull when) {
        if (buffer) {
            [requestbuffer appendAudioPCMBuffer:buffer];
        }
    }];
    
    
    [recognize recognitionTaskWithRequest:requestbuffer resultHandler:^(SFSpeechRecognitionResult * _Nullable result, NSError * _Nullable error) {
        if (result) {
            self.speechText.text = result.bestTranscription.formattedString;
        }
        if (error) {
            self.speechText.text = error.description;
        }
    }];
    
    [auengine prepare];
    [auengine startAndReturnError:&error];
}



@end
