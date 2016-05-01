//
//  File.swift
//  Cherries
//
//  Created by HanLiu on 16/5/1.
//  Copyright © 2016年 HanLiu. All rights reserved.
//

import Foundation

struct File {
    let name:String
    let path:NSURL
    init(name:String,path:NSURL){
        self.name = name
        self.path = path
    }
}