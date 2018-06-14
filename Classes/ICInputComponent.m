/*
 * Licensed to the Apache Software Foundation (ASF) under one
 * or more contributor license agreements.  See the NOTICE file
 * distributed with this work for additional information
 * regarding copyright ownership.  The ASF licenses this file
 * to you under the Apache License, Version 2.0 (the
 * "License"); you may not use this file except in compliance
 * with the License.  You may obtain a copy of the License at
 *
 *   http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing,
 * software distributed under the License is distributed on an
 * "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 * KIND, either express or implied.  See the License for the
 * specific language governing permissions and limitations
 * under the License.
 */

#import "ICInputComponent.h"
#import <WeexSDK/WXConvert.h>
#import "NumberKeypadView.h"

@implementation ICTextInputView

- (instancetype)init
{
    self = [super init];
    if (self) {
        _padding = UIEdgeInsetsZero;
        _border = UIEdgeInsetsZero;
    }
    return self;
}

- (CGRect)textRectForBounds:(CGRect)bounds
{
    bounds.size.width -= self.padding.left + self.border.left;
    bounds.origin.x += self.padding.left + self.border.left;
    
    bounds.size.height -= self.padding.top + self.border.top;
    bounds.origin.y += self.padding.top + self.border.top;
    
    bounds.size.width -= self.padding.right + self.border.right;
    
    bounds.size.height -= self.padding.bottom + self.border.bottom;
    
    return bounds;
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    // this behavior will hide the action like copy, cut, paste, selectAll and so on.
    return [[self.wx_component valueForKey:@"allowCopyPaste"] boolValue];
}

- (CGRect)editingRectForBounds:(CGRect)bounds
{
    return [self textRectForBounds:bounds];
}
@end

@interface ICInputComponent()

@property (nonatomic, strong) ICTextInputView *inputView;
@property (nonatomic, assign) BOOL allowCopyPaste;

@end

@implementation ICInputComponent

- (instancetype)initWithRef:(NSString *)ref type:(NSString *)type styles:(NSDictionary *)styles attributes:(NSDictionary *)attributes events:(NSArray *)events weexInstance:(WXSDKInstance *)weexInstance
{
    if (self = [super initWithRef:ref type:type styles:styles attributes:attributes events:events weexInstance:weexInstance]) {
        _allowCopyPaste = YES;
        if (attributes[@"allowCopyPaste"]) {
            _allowCopyPaste = [WXConvert BOOL:attributes[@"allowCopyPaste"]];
        }
    }
    return self;
}

- (UIView *)loadView
{
    _inputView = [[ICTextInputView alloc] init];
    NumberKeypadView *date = [[NumberKeypadView alloc] init];
    [date drawRect];
    date.click = ^(NSString *text) {
        if ([text isEqualToString:@"-"]) {
            if([_inputView.text rangeOfString:@"-"].location == NSNotFound){
                _inputView.text = [NSString stringWithFormat:@"%@%@",text,_inputView.text];
            }
            if(_onEvent){
                [self fireEvent:@"onEvent" params:@{@"value":text}];
            }
            return;
        }else if([text isEqualToString:@"Delete"]){
            if(_inputView.text.length > 0){
                _inputView.text = [_inputView.text substringToIndex:([_inputView.text length]-1)];
            }
            if(_onEvent){
                [self fireEvent:@"onEvent" params:@{@"value":text}];
            }
            if (_inputEvent) {
                [self fireEvent:@"input" params:@{@"value":_inputView.text} domChanges:@{@"attrs":@{@"value":_inputView.text}}];
            }
            return;
        }else if([text isEqualToString:@"touchUp"]){
            if(_onEvent){
                [self fireEvent:@"onEvent" params:@{@"value":text}];
            }
            return;
        }else if([text isEqualToString:@"touchDown"]){
            if(_onEvent){
                [self fireEvent:@"onEvent" params:@{@"value":text}];
            }
            return;
        }else if([text isEqualToString:@"Confirm"]){
            [_inputView resignFirstResponder];
            if(_onEvent){
                [self fireEvent:@"onEvent" params:@{@"value":text}];
            }
            return;
        }
        _inputView.text = [NSString stringWithFormat:@"%@%@",_inputView.text,text];
        if (_inputEvent) {
            [self fireEvent:@"input" params:@{@"value":_inputView.text} domChanges:@{@"attrs":@{@"value":_inputView.text}}];
        }
    };
    _inputView.inputView = date;
    return _inputView;
}

- (void)updateAttributes:(NSDictionary *)attributes {
    [super updateAttributes:attributes];
    if (attributes[@"allowCopyPaste"]) {
        _allowCopyPaste = [WXConvert BOOL:attributes[@"allowCopyPaste"]];
    }
}

- (void)addEvent:(NSString *)eventName
{
    [super addEvent:eventName];
    if ([eventName isEqualToString:@"onEvent"]) {
        _onEvent = YES;
    }
    if ([eventName isEqualToString:@"input"]) {
        _inputEvent = YES;
    }
}

-(void)removeEvent:(NSString *)eventName
{
    [super removeEvent:eventName];
    if ([eventName isEqualToString:@"onEvent"]) {
        _onEvent = NO;
    }
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    _inputView.delegate = self;
}

# pragma mark - overwrite method
-(NSString *)text
{
    return _inputView.text;
}
- (void)setText:(NSString *)text
{
    _inputView.text = text;
}
-(void)setTextColor:(UIColor *)color
{
    _inputView.textColor = color;
}

-(void)setTextAlignment:(NSTextAlignment)textAlignForStyle
{
    _inputView.textAlignment = textAlignForStyle;
}
-(void)setUserInteractionEnabled:(BOOL)userInteractionEnabled
{
    _inputView.userInteractionEnabled = userInteractionEnabled;
}
-(void)setEnabled:(BOOL)enabled
{
    _inputView.enabled=enabled;
}
-(void)setReturnKeyType:(UIReturnKeyType)returnKeyType
{
    _inputView.returnKeyType = returnKeyType;
}
-(void)setInputAccessoryView:(UIView *)inputAccessoryView
{
    _inputView.inputAccessoryView = inputAccessoryView;
}
-(void)setKeyboardType:(UIKeyboardType)keyboardType
{
    _inputView.keyboardType = keyboardType;
}
-(void)setSecureTextEntry:(BOOL)secureTextEntry
{
    _inputView.secureTextEntry = secureTextEntry;
}
-(void)setEditPadding:(UIEdgeInsets)padding
{
    [_inputView setPadding:padding];
}
-(void)setEditBorder:(UIEdgeInsets)border
{
    [_inputView setBorder:border];
}

-(void)setAttributedPlaceholder:(NSMutableAttributedString *)attributedString font:font
{
    [_inputView setAttributedPlaceholder:attributedString];
}

-(void)setFont:(UIFont *)font
{
    [_inputView setFont:font];
}

-(void)setEditSelectionRange:(NSInteger)selectionStart selectionEnd:(NSInteger)selectionEnd
{
    UITextPosition *startPos =  [self.inputView positionFromPosition:self.inputView.beginningOfDocument offset:selectionStart];
    UITextPosition *endPos = [self.inputView positionFromPosition:self.inputView.beginningOfDocument offset:selectionEnd];
    UITextRange *textRange = [self.inputView textRangeFromPosition:startPos
                                                        toPosition:endPos];
    self.inputView.selectedTextRange = textRange;
}

-(NSDictionary *)getEditSelectionRange
{
    NSInteger selectionStart = [self.inputView offsetFromPosition:self.inputView.beginningOfDocument toPosition:self.inputView.selectedTextRange.start];
    NSInteger selectionEnd = [self.inputView offsetFromPosition:self.inputView.beginningOfDocument toPosition:self.inputView.selectedTextRange.end];
    NSDictionary *res = @{@"selectionStart":@(selectionStart),@"selectionEnd":@(selectionEnd)};
    return res;
}

@end
