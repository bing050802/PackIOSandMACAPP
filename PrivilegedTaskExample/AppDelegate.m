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
@interface AppDelegate()
@property (nonatomic,strong)NSString*settingPath;
@property (nonatomic,strong)NSString*projectPath;
@property (nonatomic,weak)IBOutlet  NSTextField*settingField;
@property (nonatomic,weak)IBOutlet NSTextField*projectField;

@property (nonatomic,weak)IBOutlet NSImageView*icon1024;
@property (nonatomic,weak)IBOutlet NSImageView*logo;

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
    
    
}
-(void)getDataAndShow{
    if (_projectPath != nil || _projectPath.length > 0) {
    
    }
    if (_settingPath != nil || _settingPath.length > 0) {
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
