#import <objc/runtime.h>
#import <CoreFoundation/CoreFoundation.h>

%hook NSFileManager
- (NSArray *)contentsOfDirectoryAtPath:(NSString *)path error:(NSError **)error
{
	BOOL isDir;
	BOOL dirExist = [[NSFileManager defaultManager] fileExistsAtPath:@"/Library/ProceduralWallpaper" isDirectory:&isDir];
	if ([path isEqualToString:@"/System/Library/ProceduralWallpaper"] && dirExist)
    {
        NSMutableArray *bundleArray = [NSMutableArray array];
		path = @"/Library/ProceduralWallpaper";
        bundleArray = [NSMutableArray arrayWithArray:%orig];
        [bundleArray addObject:@"../../System/Library/ProceduralWallpaper/ProceduralWallpapers.bundle"];
        return bundleArray;
    }
    return %orig;	
}
%end

%hook NSBundle
+ (NSBundle *)bundleWithPath:(NSString *)path
{
    NSString *newPath = nil;
    NSRange sysRange = [path rangeOfString:@"/System/Library/ProceduralWallpaper" options:0];
    if (sysRange.location != NSNotFound) {
        newPath = [path stringByReplacingCharactersInRange:sysRange withString:@"/Library/ProceduralWallpaper"];
    }
    if (newPath && [[NSFileManager defaultManager] fileExistsAtPath:newPath]) {
        path = newPath; // /Library/ProceduralWallpaper will override /System/Library/ProceduralWallpaper.
    }
    return %orig;
}
%end

//==============================================================================
%ctor
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    %init;
    [pool release];
}