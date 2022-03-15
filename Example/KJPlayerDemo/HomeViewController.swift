//
//  HomeViewController.swift
//  KJPlayerDemo
//
//  Created by aba on 12/14/2021.
//  Copyright (c) 2021 aba. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    private static let identifier = "HomeCellIdentifier"
    private let viewModel: HomeViewModel = HomeViewModel()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView.init(frame: .zero, style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 44
        tableView.sectionHeaderHeight = 0.00001
        tableView.sectionFooterHeight = 0.00001
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: HomeViewController.identifier)
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.setupInit()
        self.setupUI()
    }
    
    func setupInit() {
        self.title = "🎷测试用例"
        self.view.backgroundColor = UIColor.white
    }
    
    func setupUI() {
        self.view.addSubview(self.tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
        ])
    }
}

// MARK: - UITableViewDataSource,UITableViewDelegate
extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.datas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let element = self.viewModel.datas[indexPath.row]
        let cell = UITableViewCell(style: .value1, reuseIdentifier: HomeViewController.identifier)
        cell.selectionStyle = .none
        cell.accessoryType = .disclosureIndicator
        cell.textLabel?.textColor = UIColor.blue
        cell.textLabel?.text = "\(indexPath.row + 1). " + String(describing: type(of: element.viewController()))
        cell.textLabel?.font = UIFont.systemFont(ofSize: 14)
        cell.detailTextLabel?.textColor = UIColor.blue.withAlphaComponent(0.5)
        cell.detailTextLabel?.text = element.rawValue
        cell.detailTextLabel?.font = UIFont.systemFont(ofSize: 13)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let element = self.viewModel.datas[indexPath.row]
        let vc: BaseViewController = element.viewController()
        vc.title = element.rawValue
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
