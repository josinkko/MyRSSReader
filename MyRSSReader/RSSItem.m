//
//  RSSItem.m
//  MyRSSReader
//
//  Created by Johanna Sinkkonen on 8/19/13.
//  Copyright (c) 2013 Johanna Sinkkonen. All rights reserved.
//

#import "RSSItem.h"
#import "GTMNSString+HTML.h"

@implementation RSSItem
-(NSAttributedString *)cellMessage
{
    if(_cellMessage != nil) return _cellMessage;
    NSDictionary *boldStyle = @{NSFontAttributeName: [UIFont fontWithName:@"Helvetica-Bold" size:16.0]};
    NSDictionary *normalStyle = @{NSFontAttributeName : [UIFont fontWithName:@"Helvetica" size:16.0]};
    NSMutableAttributedString *articleAbstract = [[NSMutableAttributedString alloc] initWithString:self.title];
    [articleAbstract setAttributes:boldStyle range:NSMakeRange(0, self.title.length)];
    [articleAbstract appendAttributedString:[[NSAttributedString alloc] initWithString:@"\n\n"]];
    
    int startIndex = [articleAbstract length];
    NSString *description = [NSString stringWithFormat:@"%@", [[self description]substringToIndex:0]];//detta värde funkar inte när description är mindre än 100 tecken.
    description = [description gtm_stringByUnescapingFromHTML]; //converter from ascii
    
    [articleAbstract appendAttributedString:[[NSAttributedString alloc]initWithString:description]];
    
    [articleAbstract setAttributes:normalStyle range:NSMakeRange(startIndex, articleAbstract.length - startIndex)];
    _cellMessage = articleAbstract;
    return _cellMessage;
}

@end
