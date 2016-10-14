//
//  ViewController.h
//  SpeechRecognize
//
//  Created by 句芒 on 16/10/13.
//  Copyright © 2016年 fanwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
- (IBAction)speechBuffer:(id)sender;
- (IBAction)stopBuffer:(UIButton *)sender;
- (IBAction)resetBuffer:(UIButton *)sender;
- (IBAction)pauseBuffer:(UIButton *)sender;
- (IBAction)prepar:(UIButton *)sender;

- (IBAction)speechRecoginze:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UITextView *speechText;
@property (weak, nonatomic) IBOutlet UIButton *bufferButton;

@end

