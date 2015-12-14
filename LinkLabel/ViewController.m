//
//  ViewController.m
//  LinkLabel
//
//  Created by 肖利 on 15/12/14.
//  Copyright (c) 2015年 肖利. All rights reserved.
//

#import "ViewController.h"



#import "CXAHyperlinkLabel.h"
#import "NSString+CXAHyperlinkParser.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet CXAHyperlinkLabel *xib_label;
@end


@implementation ViewController
- (void)viewDidLoad {
    [super viewDidLoad];

    
    
    
    NSArray *URLs;
    NSArray *URLRanges;
    NSAttributedString *as = [self attributedString:&URLs URLRanges:&URLRanges];
//    _xib_label = [[CXAHyperlinkLabel alloc] initWithFrame:CGRectZero];
    _xib_label.numberOfLines = 0;
    _xib_label.backgroundColor = [UIColor clearColor];
    _xib_label.attributedText = as;
    [_xib_label setURLs:URLs forRanges:URLRanges];
    _xib_label.URLClickHandler = ^(CXAHyperlinkLabel *label, NSURL *URL, NSRange range, NSArray *textRects){
        [[[UIAlertView alloc] initWithTitle:@"URLClickHandler" message:[NSString stringWithFormat:NSLocalizedString(@"Click on the URL %@", nil), [URL absoluteString]] delegate:nil cancelButtonTitle:NSLocalizedString(@"Dismiss", nil) otherButtonTitles:nil] show];
    };
    _xib_label.URLLongPressHandler = ^(CXAHyperlinkLabel *label, NSURL *URL, NSRange range, NSArray *textRects){
        [[[UIActionSheet alloc] initWithTitle:[NSString stringWithFormat:@"URLLongPressHandler for URL: %@", [URL absoluteString]] delegate:nil cancelButtonTitle:NSLocalizedString(@"Cancel", nil) destructiveButtonTitle:nil otherButtonTitles:nil] showInView:self.view];
    };
    
    
    
    
}




#pragma mark - privates
- (NSAttributedString *)attributedString:(NSArray *__autoreleasing *)outURLs
                               URLRanges:(NSArray *__autoreleasing *)outURLRanges
{
    NSString *HTMLText = @"An inline link may display a modified version of the content; for instance, instead of an image, a <a href='/wiki/Thumbnail' title='Thumbnail'>thumbnail</a>, <a href='/wiki/Image_resolution' title='Image resolution'>low resolution</a> <a href='/wiki/Preview_(computing)' title='Preview (computing)'>preview</a>, <a href='/wiki/Cropping_(image)' title='Cropping (image)'>cropped</a> section, or <a href='/wiki/Magnification' title='Magnification'>magnified</a> section may be shown. The full content will then usually be available on demand, as is the case with <a href='/wiki/Desktop_publishing' title='Desktop publishing'>print publishing</a> software – e.g. with an external link. This allows for smaller file sizes and quicker response to changes when the full linked content is not needed, as is the case when rearranging a <a href='/wiki/Page_layout' title='Page layout'>page layout</a>.";
    NSArray *URLs;
    NSArray *URLRanges;
    UIColor *color = [UIColor blackColor];
    UIFont *font = [UIFont fontWithName:@"Baskerville" size:19.];
    NSMutableParagraphStyle *mps = [[NSMutableParagraphStyle alloc] init];
    mps.lineSpacing = ceilf(font.pointSize * .5);
    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowColor = [UIColor whiteColor];
    shadow.shadowOffset = CGSizeMake(0, 1);
    NSString *str = [NSString stringWithHTMLText:HTMLText baseURL:[NSURL URLWithString:@"http://en.wikipedia.org/"] URLs:&URLs URLRanges:&URLRanges];
    NSMutableAttributedString *mas = [[NSMutableAttributedString alloc] initWithString:str attributes:@
                                      {
                                          NSForegroundColorAttributeName : color,
                                          NSFontAttributeName            : font,
                                          NSParagraphStyleAttributeName  : mps,
                                          NSShadowAttributeName          : shadow,
                                      }];
    [URLRanges enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop){
        [mas addAttributes:@
         {
             NSForegroundColorAttributeName : [UIColor blueColor],
             NSUnderlineStyleAttributeName  : @(NSUnderlineStyleSingle)
         } range:[obj rangeValue]];
    }];
    
    *outURLs = URLs;
    *outURLRanges = URLRanges;
    
    return [mas copy];
}
@end
