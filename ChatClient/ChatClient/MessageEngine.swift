//
//  MessageEngine.swift
//  ChatClient
//
//  Created by luoxuan-mac on 14/12/27.
//  Copyright (c) 2014年 luoyibu. All rights reserved.
//

import Foundation

@objc protocol Observer {
    func messageReceived(message: String)
}

class MessageEngine: NSObject, NSStreamDelegate {
    
    var inputStream: NSInputStream?
    var outputStream: NSOutputStream?
    var observers: NSMutableArray = NSMutableArray()
    
    class func getInstance() -> MessageEngine {
        struct Static {
            static var onceToken : dispatch_once_t = 0
            static var instance : MessageEngine? = nil
        }
        dispatch_once(&Static.onceToken) {
            Static.instance = MessageEngine()
        }
        return Static.instance!
    }
    
    func registerObserver(observer: Observer) {
        self.observers.addObject(observer)
    }
    
    func removeObserver(observer: Observer) {
        self.observers.removeObject(observer)
    }
    
    func notifyObservers(message: String) {
        for observer in self.observers {
            if observer is Observer {
                observer.messageReceived(message)
            }
        }
    }
    
    override init() {
        super.init()
        self.initNetworkCommunication()
    }
    
    func initNetworkCommunication() {
        NSStream.getStreamsToHostWithName("localhost", port: 80, inputStream: &self.inputStream, outputStream: &self.outputStream)
        self.inputStream?.delegate = self
        self.outputStream?.delegate = self
        self.inputStream?.scheduleInRunLoop(NSRunLoop.currentRunLoop(), forMode: NSDefaultRunLoopMode)
        self.outputStream?.scheduleInRunLoop(NSRunLoop.currentRunLoop(), forMode: NSDefaultRunLoopMode)
        self.inputStream?.open()
        self.outputStream?.open()
    }
    
    func sendMessage(message: NSString) {
        let data = NSData(data: message.dataUsingEncoding(NSASCIIStringEncoding, allowLossyConversion: true)!)
        self.outputStream?.write(UnsafePointer<UInt8>(data.bytes), maxLength: data.length)
    }
    
    func stream(aStream: NSStream, handleEvent eventCode: NSStreamEvent) {
        switch eventCode {
        case NSStreamEvent.OpenCompleted:
            NSLog("stream opened")
        case NSStreamEvent.HasSpaceAvailable:
            NSLog("write available");
            if aStream == self.inputStream {
                while (self.inputStream?.hasBytesAvailable != nil) {
                    var data: NSData = NSData()
                    var len = self.inputStream?.read(UnsafeMutablePointer<UInt8>(data.bytes), maxLength: data.length)
                    if len > 0 {
                        let output = NSString(bytes: data.bytes, length: data.length, encoding: NSASCIIStringEncoding)
                        if nil != output {
                            self.notifyObservers(output!)
                        }
                    }
                }
            }
        case NSStreamEvent.HasBytesAvailable:
            NSLog("read available");
        case NSStreamEvent.ErrorOccurred:
            NSLog("Can not connect to the host!");
        case NSStreamEvent.EndEncountered:
            NSLog("end encountered");
        default:
            NSLog("Unknown event")
        }
    }
}