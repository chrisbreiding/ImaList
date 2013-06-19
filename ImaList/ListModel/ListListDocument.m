#import "ListListDocument.h"
#import "List.h"

@implementation ListListDocument {
    NSMutableArray *lists;
}

- (id)initWithFileURL:(NSURL *)url {
    self = [super initWithFileURL:url];
    if (self) {
        id value = nil;
        NSError *error = nil;
        if(![url getResourceValue:&value
                           forKey:NSURLAttributeModificationDateKey
                            error:&error]) {
            [self saveToURL:url
           forSaveOperation:UIDocumentSaveForCreating
          completionHandler:^(BOOL success) {
              if(!success) {
                  NSLog(@"Failed to create file");
              }
          }];
        }
    }
    return self;
}

#pragma mark - persistence

- (BOOL)loadFromContents:(id)contents ofType:(NSString *)typeName error:(NSError **)outError {
    BOOL success = NO;
    if([contents isKindOfClass:[NSData class]] && [contents length] > 0) {
        NSData *data = (NSData *)contents;
        lists = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        if (!lists) {
            lists = [NSMutableArray array];
            [self createListWithName:@"Grocery"];
            [self commitChanges];
        }
        success = YES;
    }
    return success;
}

- (id)contentsForType:(NSString *)typeName error:(NSError **)outError {
    return [NSKeyedArchiver archivedDataWithRootObject:lists];
}

- (void)handleError:(NSError *)error userInteractionPermitted:(BOOL)userInteractionPermitted {
    if([[error domain] isEqualToString:NSCocoaErrorDomain] &&
       [error code] == NSFileReadNoSuchFileError) {
        [self saveToURL:[self fileURL]
       forSaveOperation:UIDocumentSaveForCreating
      completionHandler:^(BOOL success) {
          // ignore it here, we just wanted to make sure the document is created
          NSLog(@"handled open error with a new doc");
      }];
    } else {
        // if it's not a NSFileReadNoSuchFileError just call super
        [super handleError:error userInteractionPermitted:userInteractionPermitted];
    }
}

#pragma mark - list list data source

- (NSInteger)listCount {
    return lists.count;
}

- (List *)listAtIndex:(NSInteger)index {
    return [lists objectAtIndex:index];
}

- (NSInteger)indexOfList:(List *)list {
    return [lists indexOfObject:list];
}

- (void)deleteListAtIndex:(NSInteger)index {
    [lists removeObjectAtIndex:index];
    [self commitChanges];
}

- (List *)createListWithName:(NSString *)name {
    List *newList = [[List alloc] init];
    newList.name = name;
    newList.items = @[];
    [lists addObject:newList];
    [self commitChanges];
    return newList;
}

- (void)commitChanges {
    [self updateChangeCount:UIDocumentChangeDone];
}

@end
