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
#define KEY_ALPHA (@"alpha")

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
    //NSDictionary
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
 NSMutableDictionary: 
    key:red+gree+blue+appha
 object:
    NSDictionary
        key1: red   [123]/255
        key2: gree  [89]/255
        key3: blue  [213]/255
        key4: alpha [23]/100
 */

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //load data
    NSString *filePath = [self getColorFilePath];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if([fileManager fileExistsAtPath:filePath])
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
    
    self.myTableView.allowsSelectionDuringEditing = YES;
    
    //self.view set
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (IBAction)sliderValueChanged
{
	int red = self.redSlider.value;
    [_tfRed setText:[NSString stringWithFormat:@"%d",red]];
    
	int green = self.greenSlider.value;
    [_tfGree setText:[NSString stringWithFormat:@"%d",green]];
    
	int blue = self.blueSlider.value;
    [_tfBlue setText:[NSString stringWithFormat:@"%d",blue]];
    
    float alpha = self.alphaSlider.value/100.0;
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
    NSString *alpha= self.tfAlpha.text;
    
    if ([red isEqualToString:@""] || [gree isEqualToString:@""] || [blue isEqualToString:@""] || [alpha isEqualToString:@""])
    {
        return;
    }
    
    //key
    NSString *colorVaules = [NSString stringWithFormat:@"%@%@%@%.2f",red,gree,blue,[alpha floatValue]];
    
    //查询是否已在该值
    for (NSMutableDictionary *tempDic in _myTableSource) {
        NSString *key = [NSString stringWithFormat:@"%@%@%@%@",[tempDic objectForKey:KEY_RED],[tempDic objectForKey:KEY_GREE], [tempDic objectForKey:KEY_BLUE], [tempDic objectForKey:KEY_ALPHA]];
        
        if ([key isEqualToString:colorVaules]) {
            return;
        }
    }
    
    //加入table source
    NSMutableDictionary *btnMatchColor = [[NSMutableDictionary alloc] init];
    [btnMatchColor setValue:red   forKey:KEY_RED];
    [btnMatchColor setValue:gree  forKey:KEY_GREE];
    [btnMatchColor setValue:blue  forKey:KEY_BLUE];
    [btnMatchColor setValue:alpha forKey:KEY_ALPHA];
    
    [_myTableSource addObject:btnMatchColor];
    [btnMatchColor release];
    
    int index = _myTableSource.count;
    index = index==0?0:index-1;
    
    [self.myTableView insertRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:index inSection:0]]  withRowAnimation:UITableViewRowAnimationTop];
    
    [self.myTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
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
    else{
        NSArray *ary = [cell subviews];
        for (UIView *subView  in ary) {
            if(subView.tag == 1000)
            {
                [subView removeFromSuperview];
            }
        }
    }
    
    // record color's
    NSDictionary *btnMatchColor = [_myTableSource objectAtIndex:indexPath.row];
    
    int red     = [[btnMatchColor objectForKey:KEY_RED]  intValue];
	int green   = [[btnMatchColor objectForKey:KEY_GREE] intValue];
	int blue    = [[btnMatchColor objectForKey:KEY_BLUE] intValue];
    float alpha = [[btnMatchColor objectForKey:KEY_ALPHA] floatValue];
    
    //cell image color
    NVUIGradientButton *btn = [[NVUIGradientButton alloc] initWithFrame:CGRectMake(15, 4, 60, 38) style:NVUIGradientButtonStyleDefault];
	btn.tintColor = [UIColor colorWithRed:red/255.0 green:green/255.0 blue:blue/255.0 alpha:alpha];
    btn.tag = 1000;
    [cell addSubview:btn];
    [btn release];
    
    //cell color value
    UILabel *lbRed = [[[UILabel alloc] initWithFrame:CGRectMake(89, 11, 49, 21)] autorelease];
    lbRed.tag = 1000;
    [lbRed setTextColor:[UIColor redColor]];
    [lbRed setBackgroundColor:[UIColor clearColor]];
    [lbRed setText:[NSString stringWithFormat:@"R:%d",red]];
    [cell addSubview:lbRed];
    
    UILabel *lbGree = [[[UILabel alloc] initWithFrame:CGRectMake(146,11,49,21)] autorelease];
    lbGree.tag = 1000;
    [lbGree setTextColor:[UIColor greenColor]];
    [lbGree setBackgroundColor:[UIColor clearColor]];
    [lbGree setText:[NSString stringWithFormat:@"G:%d",green]];
    [cell addSubview:lbGree];
    
    UILabel *lbBlue = [[[UILabel alloc] initWithFrame:CGRectMake(203,11,49,21)] autorelease];
    lbBlue.tag = 1000;
    [lbBlue setTextColor:[UIColor blueColor]];
    [lbBlue setBackgroundColor:[UIColor clearColor]];
    [lbBlue setText:[NSString stringWithFormat:@"B:%d",blue]];
    [cell addSubview:lbBlue];
    
    
    UILabel *lbAlpha = [[[UILabel alloc] initWithFrame:CGRectMake(260,11,49,21)] autorelease];
    lbAlpha.tag = 1000;
    [lbAlpha setBackgroundColor:[UIColor clearColor]];
    [lbAlpha setText:[NSString stringWithFormat:@"a:%.2f",alpha]];
    [cell addSubview:lbAlpha];
    
    
    cell.backgroundColor = [UIColor scrollViewTexturedBackgroundColor];
    return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *btnMatchColor = [_myTableSource objectAtIndex:indexPath.row];
    
    int red     = [[btnMatchColor objectForKey:KEY_RED]  intValue];
	int green   = [[btnMatchColor objectForKey:KEY_GREE] intValue];
	int blue    = [[btnMatchColor objectForKey:KEY_BLUE] intValue];
    float alpha = [[btnMatchColor objectForKey:KEY_ALPHA] floatValue];
    
    [self.redSlider   setValue:red      animated:YES];
    [self.greenSlider setValue:green    animated:YES];
    [self.blueSlider  setValue:blue     animated:YES];
    [self.alphaSlider setValue:alpha*100 animated:YES];
    
    [self sliderValueChanged];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [_myTableSource removeObjectAtIndex:indexPath.row];
        
        int randT = random()%UITableViewRowAnimationMiddle;
        
        [self.myTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:indexPath.row inSection:0]] withRowAnimation:randT];
    }
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if ([textField.text isEqualToString:@""] || [textField.text intValue]>255) {
        return;
    }
    
    if (textField == self.tfRed) {
        [self.redSlider setValue:[textField.text intValue]  animated:YES];
    }
    else if(textField == self.tfGree)
    {
        [self.greenSlider setValue:[textField.text intValue]  animated:YES];
    }
    else if(textField == self.tfBlue)
    {
        [self.blueSlider setValue:[textField.text intValue]  animated:YES];
    }
    else if(textField == self.tfAlpha)
    {
        [self.alphaSlider setValue:[textField.text floatValue]*100  animated:YES];
    }
    
    [self sliderValueChanged];
    return;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    return YES;
}
@end
