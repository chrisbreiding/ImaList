#import "NSString+UtilityMethods.h"

@implementation NSString (UtilityMethods)

- (NSUInteger)wordCount {
    NSRegularExpression *whiteSpaceRegex = [NSRegularExpression regularExpressionWithPattern:@"\\s+"
                                                                                     options:NSRegularExpressionCaseInsensitive
                                                                                       error:nil];
    NSString *string = [whiteSpaceRegex stringByReplacingMatchesInString:self
                                                                 options:NSMatchingReportCompletion
                                                                   range:NSRangeFromString(self)
                                                            withTemplate:@" "];
    NSArray *words = [string componentsSeparatedByString:@" "];
    return words.count;
}

@end
