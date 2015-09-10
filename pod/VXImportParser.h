//
//  CSVParser.h
//  CSVImporter
//
//  Created by Matt Gallagher on 2009/11/30.
//  Copyright 2009 Matt Gallagher. All rights reserved.
//
//  Permission is given to use this source code file, free of charge, in any
//  project, commercial or otherwise, entirely at your risk, with the condition
//  that any redistribution (in part or whole) of source code must retain
//  this copyright and permission notice. Attribution in compiled projects is
//  appreciated but not required.
//

@interface VXImportParser : NSObject
{
	NSString *csvString;
	NSString *separator;
	NSScanner *scanner;
	BOOL hasHeader;
	NSMutableArray *fieldNames;
	id receiver;
	SEL receiverSelector;
	NSCharacterSet *endTextCharacterSet;
	BOOL separatorIsSingleChar;
}

- (instancetype)initWithString:(NSString *)aCSVString
    separator:(NSString *)aSeparatorString
    hasHeader:(BOOL)header
    fieldNames:(NSArray *)names NS_DESIGNATED_INITIALIZER;

- (NSArray *)arrayOfParsedRows;
- (void)parseRowsForReceiver:(id)aReceiver selector:(SEL)aSelector;

@property (NS_NONATOMIC_IOSONLY, readonly, copy) NSArray *parseFile;
@property (NS_NONATOMIC_IOSONLY, readonly, copy) NSMutableArray *parseHeader;
@property (NS_NONATOMIC_IOSONLY, readonly, copy) NSDictionary *parseRecord;
@property (NS_NONATOMIC_IOSONLY, readonly, copy) NSString *parseName;
@property (NS_NONATOMIC_IOSONLY, readonly, copy) NSString *parseField;
@property (NS_NONATOMIC_IOSONLY, readonly, copy) NSString *parseEscaped;
@property (NS_NONATOMIC_IOSONLY, readonly, copy) NSString *parseNonEscaped;
@property (NS_NONATOMIC_IOSONLY, readonly, copy) NSString *parseDoubleQuote;
@property (NS_NONATOMIC_IOSONLY, readonly, copy) NSString *parseSeparator;
@property (NS_NONATOMIC_IOSONLY, readonly, copy) NSString *parseLineSeparator;
@property (NS_NONATOMIC_IOSONLY, readonly, copy) NSString *parseTwoDoubleQuotes;
@property (NS_NONATOMIC_IOSONLY, readonly, copy) NSString *parseTextData;

@end
