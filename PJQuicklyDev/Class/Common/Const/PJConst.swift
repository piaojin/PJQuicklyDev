//
//  PJConst.swift
//  Swift3Learn
//
//  Created by 飘金 on 2017/4/10.
//  Copyright © 2017年 飘金. All rights reserved.
//

import UIKit

let PJScreenSize   = UIScreen.main.bounds.size
let PJScreenWidth  = UIScreen.main.bounds.size.width
let PJScreenHeight = UIScreen.main.bounds.size.height
let PJScreenBounds = UIScreen.main.bounds
let Scale = PJScreenHeight / 568 //屏幕比例用于布局适配不同大小屏幕
func PJScale(scale:CGFloat) -> CGFloat{
    return scale * Scale
}

struct PJConst {
    
}
