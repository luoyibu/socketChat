//
//  ViewController.swift
//  ChatClient
//
//  Created by luoxuan-mac on 14/12/21.
//  Copyright (c) 2014年 luoyibu. All rights reserved.
//

import UIKit

class ViewController: UIViewController, NSStreamDelegate {

    @IBOutlet weak var nameInput: UITextField!
    var inputStream: NSInputStream?
    var outputStream: NSOutputStream?
    
    @IBAction func joinChat(sender: UIButton) {
        let response = self.nameInput.text
        let data = NSData(data: response.dataUsingEncoding(NSASCIIStringEncoding, allowLossyConversion: true)!)
        self.outputStream?.write(data.bytes, maxLength: data.length)
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initNetworkCommunication()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }

    func stream(aStream: NSStream, handleEvent eventCode: NSStreamEvent) {
        
    }
}

