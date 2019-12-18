//
//  AppDelegate.h
//  zmq_oc_test000
//
//  Created by 曹伟东 on 2018/12/19.
//  Copyright © 2018年 曹伟东. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "ZMQObjC.h"
@interface AppDelegate : NSObject <NSApplicationDelegate>
{
    IBOutlet NSTextView *_msgTV;
    IBOutlet NSTextField *portTF;
    IBOutlet NSButton *startBtn;
    IBOutlet NSButton *clearBtn;
    
    IBOutlet NSMenuItem *newWindow;
}

-(IBAction)startBtnAction:(id)sender;
-(IBAction)clearBtnAction:(id)sender;
-(IBAction)newWindowAction:(id)sender;
@end

