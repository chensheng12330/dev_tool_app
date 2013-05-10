//
//  NVViewController.h
//  NVUIGradientButtonSample
//
//  Created by Nicolas Verinaud on 20/06/12.
//  Copyright (c) 2012 nverinaud.com. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "NVUIGradientButton.h"

@interface NVViewController : UIViewController<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate>
{
    
}

@property (strong, nonatomic) IBOutlet NVUIGradientButton *dynamicButton;

@property (strong, nonatomic) IBOutlet UISlider *redSlider;
@property (strong, nonatomic) IBOutlet UISlider *blueSlider;
@property (strong, nonatomic) IBOutlet UISlider *greenSlider;
@property (retain, nonatomic) IBOutlet UISlider *alphaSlider;

@property (retain, nonatomic) IBOutlet UITableView *myTableView;
@property (nonatomic, retain) NSMutableArray *myTableSource;

@property (retain, nonatomic) IBOutlet UITextField *tfRed;
@property (retain, nonatomic) IBOutlet UITextField *tfGree;
@property (retain, nonatomic) IBOutlet UITextField *tfBlue;
@property (retain, nonatomic) IBOutlet UITextField *tfAlpha;


- (IBAction)sliderValueChanged;
- (IBAction)segmentedControlValueChanged:(UISegmentedControl *)sender;
- (IBAction)addToColorFile:(NVUIGradientButton *)sender;


@end
