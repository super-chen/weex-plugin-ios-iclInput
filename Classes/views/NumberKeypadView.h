//
//  NumberKeypadView.h
//  AFNetworking
//
//  Created by chenyuan on 2018/5/17.
//

#import <UIKit/UIKit.h>

typedef void (^Click) (NSString *text);

@interface NumberKeypadView : UIView

- (void)drawRect;

@property (atomic, copy) Click click;

@end
