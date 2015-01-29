//
//  ViewController.swift
//  ChatClient
//
//  Created by luoxuan-mac on 14/12/21.
//  Copyright (c) 2014年 luoyibu. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var nameInput: UITextField!
    
    @IBAction func joinChat(sender: UIButton) {
        let response = "iam:" + self.nameInput.text
        let msgEngine = MessageEngine.getInstance()
        msgEngine.sendMessage(response)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }

}

