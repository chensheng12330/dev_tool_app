//
//  NVViewController.m
//  NVUIGradientButtonSample
//
//  Created by Nicolas Verinaud on 20/06/12.
//  Copyright (c) 2012 nverinaud.com. All rights reserved.
//

#import "NVViewController.h"

#define color_file_name  (@"color.plist")

#define KEY_RED  (@"red")
#define KEY_GREE (@"gree")
#define KEY_BLUE (@"blue")

@interface NVViewController (private)
-(NSString*) getColorFilePath;
-(void) saveColorFile;
@end

@implementation NVViewController

-(NSString*) getColorFilePath
{
    NSString *imageCachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *pathComp = [imageCachePath stringByAppendingPathComponent:color_file_name];
    return pathComp;
}

//
-(void) saveColorFile
{
    [_myTableSource writeToFile:[self getColorFilePath] atomically:YES];
}

- (void)dealloc
{


	[_dynamicButton release];
	[_redSlider release];
	
	[_greenSlider release];
	
	[_blueSlider release];
	
    [_myTableSource release];
    [_myTableView   release];
    
    [_tfRed release];
    [_tfGree release];
    [_tfBlue release];
    [_alphaSlider release];
    [_tfAlpha release];
	[super dealloc];
}

/* myTableSource 结构
 NSArray: 123456789
        [1-3]位key1: red
        [4-6]位key2: gree
        [7-9]位key3: blue
 */

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //load data
    NSString *filePath = [self getColorFilePath];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if([fileManager isExecutableFileAtPath:filePath])
    {
        _myTableSource = [[NSMutableArray alloc] initWithContentsOfFile:filePath];
    }
    else
    {
        _myTableSource = [[NSMutableArray alloc] init];
    }
	
    //init button
	self.dynamicButton.text = @"Add";
	self.dynamicButton.textColor = [UIColor whiteColor];
	self.dynamicButton.textShadowColor = [UIColor darkGrayColor];
	[self sliderValueChanged];
    
    NSString *colorValues = @"123321123";
    
    [_myTableSource addObject:colorValues];
}

- (IBAction)sliderValueChanged
{
	int red = self.redSlider.value;
    [_tfRed setText:[NSString stringWithFormat:@"%d",red]];
    
	int green = self.greenSlider.value;
    [_tfGree setText:[NSString stringWithFormat:@"%d",green]];
    
	int blue = self.blueSlider.value;
    [_tfBlue setText:[NSString stringWithFormat:@"%d",blue]];
    
    float alpha = self.alphaSlider.value;
    [_tfAlpha setText:[NSString stringWithFormat:@"%.2f",alpha]];
	
	self.dynamicButton.tintColor = [UIColor colorWithRed:red/255.0 green:green/255.0 blue:blue/255.0 alpha:alpha];

}


- (IBAction)segmentedControlValueChanged:(UISegmentedControl *)sender
{
	static NSUInteger kWhiteSelectedIndex = 0;
	
	if (sender.selectedSegmentIndex == kWhiteSelectedIndex) 
	{
		self.dynamicButton.textColor = [UIColor whiteColor];
		self.dynamicButton.textShadowColor = [UIColor darkGrayColor];
	}
	else 
	{
		self.dynamicButton.textColor = [UIColor blackColor];
		self.dynamicButton.textShadowColor = [UIColor clearColor];
	}
}

- (IBAction)addToColorFile:(NVUIGradientButton *)sender {
    NSString *red = self.tfRed.text;
    NSString *gree= self.tfGree.text;
    NSString *blue= self.tfBlue.text;
    
    if ([red isEqualToString:@""] || [gree isEqualToString:@""] || [blue isEqualToString:@""]) {
        return;
    }
    
    //key
    NSString *colorVaules = [NSString stringWithFormat:@"%@%@%@",red,gree,blue];
    
    //查询是否已在该值
    for (NSString *key in _myTableSource) {
        if ([key isEqualToString:colorVaules]) {
            return;
        }
    }
    
    //加入table source
    [_myTableSource addObject:colorVaules];
    
    [self.myTableView insertRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:_myTableSource.count-1 inSection:0]]  withRowAnimation:UITableViewRowAnimationBottom];
    
//    NSDictionary *dic = [[NSDictionary alloc] init];
//    [dic setValue:red   forKey:KEY_RED];
//    [dic setValue:gree  forKey:KEY_GREE];
//    [dic setValue:blue  forKey:KEY_BLUE];
//    [dic release];
}


- (void)viewDidUnload
{
    [self setMyTableView:nil];
    [self setTfRed:nil];
    [self setTfGree:nil];
    [self setTfBlue:nil];
    [self setAlphaSlider:nil];
    [self setTfAlpha:nil];
    [super viewDidUnload];
	
	self.dynamicButton = nil;
	self.redSlider = nil;
	
	self.greenSlider = nil;
	
	self.blueSlider = nil;
	
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
	    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
	else
	    return YES;
}

#pragma mark - tableview delegate

-(int) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.myTableSource.count;
}

-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"DownloadCell";
    UITableViewCell *cell = [self.myTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier]autorelease];
    }
    
    //cell image color
    NVUIGradientButton *btn = [[NVUIGradientButton alloc] initWithFrame:CGRectMake(20, 4, 60, 38) style:NVUIGradientButtonStyleDefault];
    
    CGFloat red = self.redSlider.value;
	CGFloat green = self.greenSlider.value;
	CGFloat blue = self.blueSlider.value;
	btn.tintColor = [UIColor colorWithRed:red green:green blue:blue alpha:1];
    
    [cell addSubview:btn];
    [btn release];
    
    //cell color value
    [cell.textLabel setText:[NSString stringWithFormat:@"R:%.3f G:%.3f B:%.3f",red,green, blue]];
    [cell.textLabel setTextAlignment:NSTextAlignmentRight];
    
    return cell;
}

@end
