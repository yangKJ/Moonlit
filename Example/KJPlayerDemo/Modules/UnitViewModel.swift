//
//  UnitViewModel.swift
//  KJPlayerDemo
//
//  Created by 77。 on 2022/3/19.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import Foundation
import UIKit

enum UnitType: String {
    case Record = "记录播放时间"
}

extension UnitType {
    
    var viewController: BaseViewController {
        switch self {
        case .Record:
            return RecordViewController()
        }
    }
}

struct UnitViewModel {
    let datas: [UnitType] = {
        return [
            .Record,
        ]
    }()
}
