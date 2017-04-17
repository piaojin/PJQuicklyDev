//
//  ViewController.swift
//  PJQuicklyDev
//
//  Created by 飘金 on 2017/4/12.
//  Copyright © 2017年 飘金. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        //"http://v5.owner.mjbang.cn/api/gallery/get_experience_house"
        PJHttpTool.pj_request(requestType : ._get, params : ["type":"zhongtong","postid":"434017443551"], url : "http://www.kuaidi100.com/query",success : {
            (response : Any?) -> Void
            in
            PJPrintLog(response)
        },faild : {
            (error : Any?) -> Void
            in
            PJPrintLog(error)
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

