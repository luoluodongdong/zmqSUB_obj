//
//  AppDelegate.m
//  zmq_oc_test000
//
//  Created by 曹伟东 on 2018/12/19.
//  Copyright © 2018年 曹伟东. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@property (nonatomic,strong) ZMQContext *ctx;
@property (atomic,strong) ZMQSocket *socket;
@property (nonatomic,strong) NSString *logString;

@property (weak) IBOutlet NSWindow *window;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
    //[self test];

    self.ctx=[[ZMQContext alloc] initWithIOThreads:1];
    self.logString=@"";
}

-(IBAction)newWindowAction:(id)sender{
    NSString *executablePath=[[NSBundle mainBundle] executablePath];
    NSTask *task=[[NSTask alloc] init];
    task.launchPath = executablePath;
    [task launch];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
    
}
-(IBAction)startBtnAction:(id)sender{
    NSString *portStr=[portTF stringValue];
    if ([portStr length] == 0) {
        return;
    }
    NSString *endpoint=[@"tcp://" stringByAppendingString:portStr];
    self.socket = [self.ctx socketWithType:ZMQ_SUB];
    //socket.setsockopt(ZMQ_RCVTIMEO,300);
    BOOL didConnect = [self.socket connectToEndpoint:endpoint];
    if (!didConnect) {
        NSLog(@"*** Failed to connect to endpoint [%@].", endpoint);
        [self printTV:@"connect NG"];
        //return EXIT_FAILURE;
    }else{
        NSLog(@"client connect ok");
        [self printTV:@"connect OK"];
        BOOL subcribeOK=[self.socket subscribeAll];
        if (!subcribeOK) {
            NSLog(@"subcribe not OK");
            [self printTV:@"subcribe NG"];
            //return 3;
        }else{
            [self printTV:@"subcribe OK"];
            [NSThread detachNewThreadSelector:@selector(loopSUB) toTarget:self withObject:nil];
            [startBtn setHidden:YES];
            [portTF setEnabled:NO];
        }
    }
    
    
}
-(void)loopSUB{
    while (1) {
        NSData *reply = [self.socket receiveDataWithFlags:0];
        NSString *text = [[NSString alloc] initWithData:reply encoding:NSUTF8StringEncoding];
        //NSString *msg=[NSString stringWithFormat:@"Received reply %d: %@", request_nbr, text];
        [self performSelectorOnMainThread:@selector(printTV:) withObject:text waitUntilDone:YES];
    }
    
}
-(IBAction)clearBtnAction:(id)sender{
    self.logString=@"";
    [self printTV:@"Clear log OK"];
}
-(void)printTV:(NSString *)msg{
    NSDateFormatter *dateFormat=[[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"[yyyy-MM-dd HH:mm:ss.SSS]"];
    NSString *dateText=[dateFormat stringFromDate:[NSDate date]];
    self.logString = [self.logString stringByAppendingFormat:@"%@ %@\r\n",dateText,msg];
    [_msgTV setString:self.logString];
    [_msgTV scrollRangeToVisible:NSMakeRange([[_msgTV textStorage] length],0)];
    [_msgTV setNeedsDisplay: YES];
    if ([self.logString length] > 100000) {
        self.logString=@"";
    }
}
-(void)windowShouldClose:(id)sender{
    NSLog(@"window will close...");
    if (self.socket != nil) {
        //[self.socket close];
        //[self.ctx closeSockets];
        //[self.ctx terminate];
    }
    [NSApp terminate:NSApp];
}
@end
