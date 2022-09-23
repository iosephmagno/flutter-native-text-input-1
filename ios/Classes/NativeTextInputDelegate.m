#import "NativeTextInputDelegate.h"

@implementation NativeTextInputDelegate {
    FlutterMethodChannel* _channel;
    id _Nullable _args;
    
    float _fontSize;
    NSString *_fontName;
    UIFontWeight _fontWeight;
    UIColor* _fontColor;
    
    float _placeholderFontSize;
    NSString *_placeholderFontName;
    UIFontWeight _placeholderFontWeight;
    UIColor* _placeholderFontColor;
}

- (instancetype)initWithChannel:(FlutterMethodChannel*)channel arguments:(id _Nullable)args {
    self = [super init];
    
    _fontSize = 16.0;
    _fontWeight = UIFontWeightRegular;
    _fontColor = UIColor.blackColor;
    
    _placeholderFontSize = 16.0;
    _placeholderFontWeight = UIFontWeightRegular;
    _placeholderFontColor = UIColor.lightGrayColor;
    
    if (args[@"fontSize"] && ![args[@"fontSize"] isKindOfClass:[NSNull class]]) {
        NSNumber* fontSize = args[@"fontSize"];
        _fontSize = [fontSize floatValue];
        _placeholderFontSize = _fontSize;
    }
    if (args[@"fontName"] && ![args[@"fontName"] isKindOfClass:[NSNull class]]) {
        _fontName = args[@"fontName"];
    }
    if (args[@"fontWeight"] && ![args[@"fontWeight"] isKindOfClass:[NSNull class]]) {
        _fontWeight = [self fontWeightFromString:args[@"fontWeight"]];
    }
    if (args[@"fontColor"] && ![args[@"fontColor"] isKindOfClass:[NSNull class]]) {
        NSDictionary* fontColor = args[@"fontColor"];
        _fontColor = [UIColor colorWithRed:[fontColor[@"red"] floatValue]/255.0 green:[fontColor[@"green"] floatValue]/255.0 blue:[fontColor[@"blue"] floatValue]/255.0 alpha:[fontColor[@"alpha"] floatValue]/255.0];
    }
    if (args[@"placeholderFontSize"] && ![args[@"placeholderFontSize"] isKindOfClass:[NSNull class]]) {
        NSNumber* placeholderFontSize = args[@"placeholderFontSize"];
        _placeholderFontSize = [placeholderFontSize floatValue];
    }
    if (args[@"placeholderFontName"] && ![args[@"placeholderFontName"] isKindOfClass:[NSNull class]]) {
        _placeholderFontName = args[@"placeholderFontName"];
    }
    if (args[@"placeholderFontWeight"] && ![args[@"placeholderFontWeight"] isKindOfClass:[NSNull class]]) {
        _placeholderFontWeight = [self fontWeightFromString:args[@"placeholderFontWeight"]];
    }
    if (args[@"placeholderFontColor"] && ![args[@"placeholderFontColor"] isKindOfClass:[NSNull class]]) {
        NSDictionary* placeholderFontColor = args[@"placeholderFontColor"];
        _placeholderFontColor = [UIColor colorWithRed:[placeholderFontColor[@"red"] floatValue]/255.0 green:[placeholderFontColor[@"green"] floatValue]/255.0 blue:[placeholderFontColor[@"blue"] floatValue]/255.0 alpha:[placeholderFontColor[@"alpha"] floatValue]/255.0];
    }
    
    if (self) {
        _channel = channel;
        _args = args;
    }
    
    return self;
}

- (UIColor *)fontColor {
    return _fontColor;
}

- (UIFont *)font {
    if (_fontName) {
        return [UIFont fontWithName:_fontName size:_fontSize];
    } else {
        return [UIFont systemFontOfSize:_fontSize weight:_fontWeight];
    }
}

- (UIColor *)placeholderFontColor {
    return _placeholderFontColor;
}

- (UIFont *)placeholderFont {
    if (_placeholderFontName) {
        return [UIFont fontWithName:_placeholderFontName size:_placeholderFontSize];
    } else {
        return [UIFont systemFontOfSize:_placeholderFontSize weight:_placeholderFontWeight];
    }
}

- (UIFontWeight)fontWeightFromString:(NSString*)fontWeight {
    if (!fontWeight || [fontWeight isKindOfClass:[NSNull class]]) {
        return UIFontWeightRegular;
    }
    if ([fontWeight isEqualToString:@"FontWeight.w100"]) {
        return UIFontWeightUltraLight;
    } else if ([fontWeight isEqualToString:@"FontWeight.w200"]) {
        return UIFontWeightThin;
    } else if ([fontWeight isEqualToString:@"FontWeight.w300"]) {
        return UIFontWeightLight;
    } else if ([fontWeight isEqualToString:@"FontWeight.w400"]) {
        return UIFontWeightRegular;
    } else if ([fontWeight isEqualToString:@"FontWeight.w500"]) {
        return UIFontWeightMedium;
    } else if ([fontWeight isEqualToString:@"FontWeight.w600"]) {
        return UIFontWeightSemibold;
    } else if ([fontWeight isEqualToString:@"FontWeight.w700"]) {
        return UIFontWeightBold;
    } else if ([fontWeight isEqualToString:@"FontWeight.w800"]) {
        return UIFontWeightHeavy;
    } else if ([fontWeight isEqualToString:@"FontWeight.w900"]) {
        return UIFontWeightBlack;
    }

    return UIFontWeightRegular;
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    if (textView.textContainer.maximumNumberOfLines == 1) {
        textView.textContainer.lineBreakMode = NSLineBreakByCharWrapping;
    }
    
    [_channel invokeMethod:@"inputStarted"
                 arguments:nil];
}

- (void)textViewDidChange:(UITextView *)textView {
    textView.scrollEnabled = true;
    CGFloat numberOfLinesNeeded = ceil(textView.contentSize.height / textView.font.lineHeight);
    CGFloat numberOfLinesInTextView = ceil(textView.frame.size.height / textView.font.lineHeight);
    textView.scrollEnabled = numberOfLinesNeeded > numberOfLinesInTextView;
    [_channel invokeMethod:@"inputValueChanged" arguments:@{ @"text": textView.text }];
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    if (textView.textContainer.maximumNumberOfLines == 1) {
        textView.textContainer.lineBreakMode = NSLineBreakByTruncatingTail;
    }
}

  - (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
      NSString *newString;
      if([text hasPrefix:@"\n"]) {
          if ([text stringByReplacingOccurrencesOfString:@"\n" withString:@""].length>0) {
              newString = [text stringByReplacingOccurrencesOfString:@"\n" withString:@""];
              textView.text = newString;
          } else {
              newString = text;
          }
      }
    if ((textView.returnKeyType != UIReturnKeyDefault ||
         textView.textContainer.maximumNumberOfLines == 1) && [newString isEqualToString:@"\n"]) {
         [_channel invokeMethod:@"inputFinished"
                      arguments:@{ @"text": textView.text }];
         return false;
     }
     return true;
 }

- (void)singleTapRecognized:(UIGestureRecognizer *)gestureRecognizer {
     [_channel invokeMethod:@"singleTapRecognized" arguments:@{}];
}

#pragma mark - Gesture recognizer delegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}


@end
