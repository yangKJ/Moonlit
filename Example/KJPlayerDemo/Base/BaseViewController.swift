//
//  BaseViewController.swift
//  KJPlayerDemo_Example
//
//  Created by 77。 on 2021/12/23.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import UIKit
import KJPlayer

class BaseViewController: UIViewController {

    lazy var playerView: KJPlayerView = {
        let view = KJPlayerView.init(frame: .zero)
        //view.background = UIColor.red.cgColor
        view.backgroundColor = UIColor.green
        view.image = UIImage.init(named: "bear")
        return view
    }()
    
    lazy var backBarButton: UIBarButtonItem = {
        let barButton = UIBarButtonItem(image: UIImage.init(named: "base_black_back"),
                                        style: .plain,
                                        target: self,
                                        action: #selector(BaseViewController.backAction))
        barButton.imageInsets.left = 5
        return barButton
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = UIColor.white
        navigationItem.hidesBackButton = true
        navigationItem.leftBarButtonItem = backBarButton
        view.addSubview(playerView)
        playerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            playerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            playerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            playerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            playerView.heightAnchor.constraint(equalTo: playerView.widthAnchor, multiplier: 1),
        ])
    }
    
    @objc dynamic open func backAction() {
        if (navigationController?.children[0] == self) {
            dismiss(animated: true, completion:nil)
            return;
        }
        navigationController?.popViewController(animated: true)
    }
}
