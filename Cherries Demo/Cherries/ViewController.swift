//
//  ViewController.swift
//  Cherries
//
//  Created by HanLiu on 16/5/1.
//  Copyright © 2016年 HanLiu. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    let url = "http://dev.wjhgw.com/mobile/index.php?act=xs&op=auto_complete"
    let url2 = "http://dev.wjhgw.com/mobile/index.php?act=search"
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func tapToReqeust(sender: AnyObject) {
        
        Cherries.request(url,method:.POST,params:["term":"白"]){ (data,response,error)in
            //let dic = data!.objectForKey("data")
            print("\(data) \n response = \(response) \n error = \(error)")
        }
        
        let dic  = ["act":"search","keyword":"卡罗兰","curpage":"1","page":"10"]
    
        Cherries.Get(url2, params: dic) { (data, response, error) in
            print("\(data) \n response = \(response) \n error = \(error)")

        }
    
        
    }

}

