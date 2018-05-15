/*
 # PrivilegedTaskExample
 # Copyright (C) 2009 Sveinbjorn Thordarson <sveinbjorn@sveinbjorn.org>
 #
 # BSD License
 # Redistribution and use in source and binary forms, with or without
 # modification, are permitted provided that the following conditions are met:
 #     * Redistributions of source code must retain the above copyright
 #       notice, this list of conditions and the following disclaimer.
 #     * Redistributions in binary form must reproduce the above copyright
 #       notice, this list of conditions and the following disclaimer in the
 #       documentation and/or other materials provided with the distribution.
 #     * Neither the name of Sveinbjorn Thordarson nor that of any other
 #       contributors may be used to endorse or promote products
 #       derived from this software without specific prior written permission.
 #
 # THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
 # ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 # WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 # DISCLAIMED. IN NO EVENT SHALL  BE LIABLE FOR ANY
 # DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 # (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 # LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
 # ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 # (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 # SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#import "AppDelegate.h"
#import "STPrivilegedTask.h"
typedef NS_OPTIONS(NSUInteger, YHZConfigKey) {
    YHZConfig_Chinese = 101,
    YHZConfig_English = 102,
    YHZConfig_weixin = 103,
    YHZConfig_dingding = 104,
    YHZConfig_WXorDing = 105,
    YHZConfig_OEMorNor = 106,
    YHZConfig_InorOverseas = 107,
    YHZConfig_Version = 108,
    YHZConfig_Copyright = 109,
    YHZConfig_qq = 110,
};

NSString*YHZConfig(YHZConfigKey key ){
    NSArray *array = @[@"YHZConfig_Chinese",@"YHZConfig_English",@"YHZConfig_weixin",@"YHZConfig_dingding",@"YHZConfig_WXorDing",@"YHZConfig_OEMorNor",@"YHZConfig_InorOverseas",@"YHZConfig_Version",@"YHZConfig_Copyright",@"YHZConfig_qq"];
    return array[key - 101];
    
};



@interface AppDelegate()
@property (nonatomic,strong)NSString*settingPath;
@property (nonatomic,strong)NSString*projectPath;
@property (nonatomic,weak)IBOutlet  NSTextField*settingField;
@property (nonatomic,weak)IBOutlet NSTextField*projectField;

@property (nonatomic,weak)IBOutlet NSImageView*icon1024;
@property (nonatomic,weak)IBOutlet NSImageView*logo;

@property (nonatomic,weak)IBOutlet NSTextField*englishField;
@property (nonatomic,weak)IBOutlet NSTextField*chineseField;
@property (nonatomic,weak)IBOutlet NSTextField*wxField;
@property (nonatomic,weak)IBOutlet NSTextField*dingField;
@property (nonatomic,weak)IBOutlet NSSegmentedControl*wxSegment;
@property (nonatomic,weak)IBOutlet NSSegmentedControl*oemSegment;
@property (nonatomic,weak)IBOutlet NSSegmentedControl*innerSegment;
@property (nonatomic,weak)IBOutlet NSTextField *versionField;
@property (nonatomic,weak)IBOutlet NSTextField *copyrightField;
@property (nonatomic,weak)IBOutlet NSTextField *qqField;
@end

@implementation AppDelegate

- (IBAction)selectBtnClick:(id)sender {
    NSInteger tag = [sender tag];
    if (tag == 1) {
        [self selectPath:^(NSString *path) {
            _settingPath = path;
            _settingField.stringValue = _settingPath;
                 [self getDataAndShow];
        }];
    }
    
    if (tag == 2) {
        [self selectPath:^(NSString *path) {
            _projectPath = path;
            _projectField.stringValue = _projectPath;
            [self getDataAndShow];
        }];
    }
    
    
    if (tag == 3) {
        [self outputSetting];
    }
    
    if(tag == 4){
        [self reset];
        
    }
    if(tag == 5){
        [self archive];
        
    }
    
}
-(void)archive{
    
    STPrivilegedTask *privilegedTask = [[STPrivilegedTask alloc] init];
    
    NSString*action=[[NSBundle mainBundle]pathForResource:@"productIPA" ofType:@"sh"];
    NSString *launchPath = action;

       NSString* exportPath = [[NSBundle mainBundle]pathForResource:@"exportTest" ofType:@"plist"];
    
    [privilegedTask setLaunchPath:launchPath];
    [privilegedTask setArguments:@[_settingPath,_projectPath,exportPath]];
    
    [privilegedTask setCurrentDirectoryPath:[[NSBundle mainBundle] resourcePath]];
    
    //set it off
    OSStatus err = [privilegedTask launch];
    if (err != errAuthorizationSuccess) {
        if (err == errAuthorizationCanceled) {
            NSLog(@"User cancelled");
            return;
        }  else {
            NSLog(@"Something went wrong: %d", (int)err);
            // For error codes, see http://www.opensource.apple.com/source/libsecurity_authorization/libsecurity_authorization-36329/lib/Authorization.h
        }
    }
    
    [privilegedTask waitUntilExit];
    
    // Success!  Now, start monitoring output file handle for data
    NSFileHandle *readHandle = [privilegedTask outputFileHandle];
    NSData *outputData = [readHandle readDataToEndOfFile];
    NSString *outputString = [[NSString alloc] initWithData:outputData encoding:NSUTF8StringEncoding];
    [self.outputTextField setString:outputString];
    
    NSString *exitStr = [NSString stringWithFormat:@"Exit status: %d", privilegedTask.terminationStatus];
    [self.exitStatusTextField setStringValue:exitStr];
}
-(void)reset{
    _settingPath = nil;
    _projectPath = nil;
    _settingField.stringValue= @"";
    _projectField.stringValue=@"";
//    _chineseField.stringValue = @"";;
//    _englishField.stringValue = @"";
    _wxField.stringValue = @"";
    _dingField.stringValue = @"";
    _versionField.stringValue = @"";
//    _copyrightField.stringValue = @"";
    _qqField.stringValue = @"";
    
    [_wxSegment setSelectedSegment:0];
    [_oemSegment setSelectedSegment:0];
    [_innerSegment setSelectedSegment:0];
    
    
}
-(void)outputSetting{
    NSString*setting =   [_settingPath stringByAppendingPathComponent:@"YHZConfig.plist"];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
        [dict setObject:_chineseField.stringValue forKey:YHZConfig(_chineseField.tag)];
      [dict setObject:_englishField.stringValue forKey:YHZConfig(_englishField.tag)];
      [dict setObject:_wxField.stringValue forKey:YHZConfig(_wxField.tag)];
      [dict setObject:_dingField.stringValue forKey:YHZConfig(_dingField.tag)];
    
      [dict setObject:@(_wxSegment.selectedSegment) forKey:YHZConfig(_wxSegment.tag)];
      [dict setObject:@(_oemSegment.selectedSegment) forKey:YHZConfig(_oemSegment.tag)];
      [dict setObject:@(_innerSegment.selectedSegment) forKey:YHZConfig(_innerSegment.tag)];
    

      [dict setObject:_versionField.stringValue forKey:YHZConfig(_versionField.tag)];
      [dict setObject:_copyrightField.stringValue forKey:YHZConfig(_copyrightField.tag)];
      [dict setObject:@"1106228075" forKey:YHZConfig(110)];
    
        [dict writeToFile:setting atomically:YES];
     NSString *infoPath = [_settingPath stringByAppendingPathComponent:@"Info.plist"];
    
    if (![[NSFileManager defaultManager]fileExistsAtPath:infoPath]) {
        NSError *copyError;
         NSString *infoPath1 = [_projectPath stringByAppendingString:@"/Cloudoc2/Info.plist"];
        [[NSFileManager defaultManager]copyItemAtPath:infoPath1 toPath:infoPath error:&copyError];
        
        NSLog(@"%@",copyError);
    }
    
   
    NSMutableDictionary *info = [NSMutableDictionary dictionaryWithContentsOfFile:infoPath];
    NSMutableArray*array = info[@"CFBundleURLTypes"];
    
    [info setObject:_versionField.stringValue forKey:@"CFBundleShortVersionString"];
    [info setObject:_versionField.stringValue forKey:@"CFBundleVersion"];
    for (NSMutableDictionary *dict in array) {
        NSString *value=dict[@"CFBundleURLName"];
        if ([value isEqualToString:@"weixin"]) {
            [dict setObject:@[_wxField.stringValue] forKey:@"CFBundleURLSchemes"];
        }
        if ([value isEqualToString:@"dingtalk"]) {
            [dict setObject:@[_dingField.stringValue] forKey:@"CFBundleURLSchemes"];
        }
        if ([value isEqualToString:@"tencent"]) {
            NSString *str= [NSString stringWithFormat:@"tencent%@",_qqField.stringValue];
            [dict setObject:@[str] forKey:@"CFBundleURLSchemes"];
        }
        
    }
    NSLog(@"%@",info);
    
    
    [info writeToFile:infoPath atomically:YES];
        
    [self runSTPrivilegedTask];
    
    
}

- (IBAction)runSTPrivilegedTask{
    
    STPrivilegedTask *privilegedTask = [[STPrivilegedTask alloc] init];
    
    NSString*action=[[NSBundle mainBundle]pathForResource:@"action" ofType:@"sh"];
    NSString *launchPath = action;
    NSString*content=[[NSBundle mainBundle]pathForResource:@"content" ofType:@"txt"];
    NSString* Contentsjson = [[NSBundle mainBundle]pathForResource:@"Contents" ofType:@"json"];
        NSString* exportPath = [[NSBundle mainBundle]pathForResource:@"exportTest" ofType:@"plist"];
    
    [privilegedTask setLaunchPath:launchPath];
    [privilegedTask setArguments:@[_settingPath,_projectPath,content,Contentsjson,exportPath]];
    
    [privilegedTask setCurrentDirectoryPath:[[NSBundle mainBundle] resourcePath]];
    
    //set it off
    OSStatus err = [privilegedTask launch];
    if (err != errAuthorizationSuccess) {
        if (err == errAuthorizationCanceled) {
            NSLog(@"User cancelled");
            return;
        }  else {
            NSLog(@"Something went wrong: %d", (int)err);
            // For error codes, see http://www.opensource.apple.com/source/libsecurity_authorization/libsecurity_authorization-36329/lib/Authorization.h
        }
    }
    
    [privilegedTask waitUntilExit];
    
    // Success!  Now, start monitoring output file handle for data
    NSFileHandle *readHandle = [privilegedTask outputFileHandle];
    NSData *outputData = [readHandle readDataToEndOfFile];
    NSString *outputString = [[NSString alloc] initWithData:outputData encoding:NSUTF8StringEncoding];
    [self.outputTextField setString:outputString];
    
    NSString *exitStr = [NSString stringWithFormat:@"Exit status: %d", privilegedTask.terminationStatus];
    [self.exitStatusTextField setStringValue:exitStr];
}


-(void)showSettingInfoZ{
    NSString*settingPath =   [_settingPath stringByAppendingPathComponent:@"YHZConfig.plist"];
    if ([[NSFileManager defaultManager]fileExistsAtPath:settingPath]) {
        NSMutableDictionary *settingDict = [NSMutableDictionary dictionaryWithContentsOfFile:settingPath];
        _chineseField.stringValue = settingDict[YHZConfig(_chineseField.tag)];
        _englishField.stringValue = settingDict[YHZConfig(_englishField.tag)];
        _wxField.stringValue = settingDict[YHZConfig(_wxField.tag)];
        _dingField.stringValue = settingDict[YHZConfig(_dingField.tag)];
        _versionField.stringValue = settingDict[YHZConfig(_versionField.tag)];
        _copyrightField.stringValue = settingDict[YHZConfig(_copyrightField.tag)];
        _qqField.stringValue = settingDict[YHZConfig(_qqField.tag)];
        
        [_wxSegment setSelectedSegment:[settingDict[YHZConfig(_chineseField.tag) ]integerValue]];
        [_oemSegment setSelectedSegment:[settingDict[YHZConfig(_oemSegment.tag) ]integerValue]];
        [_innerSegment setSelectedSegment:[settingDict[YHZConfig(_innerSegment.tag) ]integerValue]];
    }
    
}

-(void)getDataAndShow{
    if ((_projectPath != nil && _projectPath.length > 0)&&(_settingPath != nil && _settingPath.length > 0)) {
        NSString*settingPath =   [_settingPath stringByAppendingPathComponent:@"YHZConfig.plist"];
        if ([[NSFileManager defaultManager]fileExistsAtPath:settingPath]) {
            NSMutableDictionary *settingDict = [NSMutableDictionary dictionaryWithContentsOfFile:settingPath];
            NSLog(@"%@",settingDict);
                _chineseField.stringValue = settingDict[YHZConfig(_chineseField.tag)];
               _englishField.stringValue = settingDict[YHZConfig(_englishField.tag)];
               _wxField.stringValue = settingDict[YHZConfig(_wxField.tag)];
               _dingField.stringValue = settingDict[YHZConfig(_dingField.tag)];
               _versionField.stringValue = settingDict[YHZConfig(_versionField.tag)];
               _copyrightField.stringValue = settingDict[YHZConfig(_copyrightField.tag)];
            
                _qqField.stringValue = settingDict[YHZConfig(_qqField.tag)];
               [_wxSegment setSelectedSegment:[settingDict[YHZConfig(_chineseField.tag) ]integerValue]];
               [_oemSegment setSelectedSegment:[settingDict[YHZConfig(_oemSegment.tag) ]integerValue]];
                [_innerSegment setSelectedSegment:[settingDict[YHZConfig(_innerSegment.tag) ]integerValue]];
            
        }else{
            
            NSString *infoPath = [_projectPath stringByAppendingString:@"/Cloudoc2/Info.plist"];
            NSMutableDictionary *info = [NSMutableDictionary dictionaryWithContentsOfFile:infoPath];
            NSMutableArray*array = info[@"CFBundleURLTypes"];
            _versionField.stringValue = info[@"CFBundleShortVersionString"];
            for (NSMutableDictionary *dict in array) {
                NSString *value=dict[@"CFBundleURLName"];
                if ([value isEqualToString:@"weixin"]) {
                    _wxField.stringValue = [dict[@"CFBundleURLSchemes"]firstObject];
                    
                }
                if ([value isEqualToString:@"dingtalk"]) {
                    _dingField.stringValue =[dict[@"CFBundleURLSchemes"]firstObject];
                }
                if ([value isEqualToString:@"tencent"]) {
                    _qqField.stringValue =[dict[@"CFBundleURLSchemes"]firstObject];
                }
                
            }
            
            
            
            
            if (_settingPath != nil || _settingPath.length > 0) {
                [info writeToFile:[_settingPath stringByAppendingPathComponent:@"Info.plist"]atomically:YES];
                
            }
        }
        
   
    

        NSImage *image1 = [[NSImage alloc]initWithContentsOfFile:[_settingPath stringByAppendingPathComponent:@"cloud_ico.png"]];
        _icon1024.image = image1;
        
        _logo.image=[[NSImage alloc]initWithContentsOfFile:[_settingPath stringByAppendingPathComponent:@"logo@3x.png"]];
    }
}

-(void)selectPath:(void(^)(NSString *path))callback{
    NSOpenPanel* panel = [NSOpenPanel openPanel];
    __weak typeof(self)weakSelf = self;
    //是否可以创建文件夹
    panel.canCreateDirectories = YES;
    //是否可以选择文件夹
    panel.canChooseDirectories = YES;
    //是否可以选择文件
    panel.canChooseFiles = NO;
    
    //是否可以多选
    [panel setAllowsMultipleSelection:NO];
    
    //显示
    [panel beginSheetModalForWindow:self.window completionHandler:^(NSInteger result) {
        
        //是否点击open 按钮
        if (result == NSModalResponseOK) {
            //NSURL *pathUrl = [panel URL];
            NSString *pathString = [panel.URLs.firstObject path];
            if (callback) {
                callback(pathString);
            }
        }
        
        
    }];
    
}


- (IBAction)runNSTask:(id)sender {
    
    NSTask *task = [[NSTask alloc] init];
    
    NSMutableArray *components = [[[self.commandTextField stringValue] componentsSeparatedByString:@" "] mutableCopy];
    task.launchPath = components[0];
    [components removeObjectAtIndex:0];
    task.arguments = components;
    task.currentDirectoryPath = [[NSBundle  mainBundle] resourcePath];
    
    NSPipe *outputPipe = [NSPipe pipe];
    [task setStandardOutput:outputPipe];
    [task setStandardError:outputPipe];
    NSFileHandle *readHandle = [outputPipe fileHandleForReading];
    
    [task launch];
    [task waitUntilExit];
    
    NSData *outputData = [readHandle readDataToEndOfFile];
    NSString *outputString = [[NSString alloc] initWithData:outputData encoding:NSUTF8StringEncoding];
    [self.outputTextField setString:outputString];
    
    NSString *exitStr = [NSString stringWithFormat:@"Exit status: %d", task.terminationStatus];
    [self.exitStatusTextField setStringValue:exitStr];
}

- (IBAction)runSTPrivilegedTask:(id)sender {
    
    STPrivilegedTask *privilegedTask = [[STPrivilegedTask alloc] init];
    
    NSMutableArray *components = [[[self.commandTextField stringValue] componentsSeparatedByString:@" "] mutableCopy];
    NSString *launchPath = components[0];
    [components removeObjectAtIndex:0];
    
    [privilegedTask setLaunchPath:launchPath];
    [privilegedTask setArguments:components];
    [privilegedTask setCurrentDirectoryPath:[[NSBundle mainBundle] resourcePath]];
    
    //set it off
    OSStatus err = [privilegedTask launch];
    if (err != errAuthorizationSuccess) {
        if (err == errAuthorizationCanceled) {
            NSLog(@"User cancelled");
            return;
        }  else {
            NSLog(@"Something went wrong: %d", (int)err);
            // For error codes, see http://www.opensource.apple.com/source/libsecurity_authorization/libsecurity_authorization-36329/lib/Authorization.h
        }
    }
    
    [privilegedTask waitUntilExit];
    
    // Success!  Now, start monitoring output file handle for data
    NSFileHandle *readHandle = [privilegedTask outputFileHandle];
    NSData *outputData = [readHandle readDataToEndOfFile];
    NSString *outputString = [[NSString alloc] initWithData:outputData encoding:NSUTF8StringEncoding];
    [self.outputTextField setString:outputString];
    
    NSString *exitStr = [NSString stringWithFormat:@"Exit status: %d", privilegedTask.terminationStatus];
    [self.exitStatusTextField setStringValue:exitStr];
}

@end
