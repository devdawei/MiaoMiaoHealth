//
//  MMHSingleLineInputController.m
//  MiaoMiaoHealth
//
//  Created by 大威 on 2016/8/31.
//  Copyright © 2016年 devdawei. All rights reserved.
//

#import "MMHSingleLineInputController.h"

@interface MMHSingleLineInputController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIButton *okButton;

@property (nonatomic, strong) NSArray *numberArray;

@end

@implementation MMHSingleLineInputController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [MMHAppConst controllerBgColor];
    
    if (_keyboardType) _textField.keyboardType = _keyboardType;
    if (_placeholder) _textField.placeholder = _placeholder;
    if (_text) _textField.text = _text;
    
    [_okButton mmh_makeCornerRadius:kLargeButtonCornerRadius];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // 强制使用苹果键盘
    [[NSNotificationCenter defaultCenter] postNotificationName:kForcedUseAppleKeyboardNotify object:kForcedUseAppleKeyboard];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [_textField becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    // 不强制使用苹果键盘
    [[NSNotificationCenter defaultCenter] postNotificationName:kForcedUseAppleKeyboardNotify object:kNotForceUseAppleKeyboard];
}

#pragma mark - Action

- (IBAction)okButtonAction:(id)sender
{
    if (_doneBlock) _doneBlock(_textField.text);
    if (self.navigationController)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    DLog(@"%@", string);
    if (!string.length) return YES; // 如果为 @"" 则为删除按钮点击事件
    
    DLog(@"range: %@, string: %@", NSStringFromRange(range), string);
    DLog(@"%@", textField.text);
    
    if (MMHInputTypeNSUInteger == _inputType)
    {
        if (![self.numberArray containsObject:string])
        {
            [DVVToast showMessage:@"只能输入数字哦" fromView:self.view];
            return NO;
        }
        NSString *placeValue = 0 == textField.text.integerValue ? @"" : FormatString(@"%lu", (unsigned long)textField.text.integerValue);
        NSString *text = FormatString(@"%@%@", placeValue, string);
        NSString *covText = FormatString(@"%lu", (unsigned long)text.integerValue);
        DLog(@"%@, %@", text, covText);
        if (![text isEqualToString:covText])
        {
            [DVVToast showMessage:FormatString(@"不能再输入了哟")  fromView:self.view];
            return NO;
        }
    }
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    if (_doneBlock) _doneBlock(_textField.text);
    return YES;
}

#pragma mark - Lazy load

- (NSArray *)numberArray
{
    if (!_numberArray)
    {
        _numberArray = @[ @"0", @"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9" ];
    }
    return _numberArray;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
