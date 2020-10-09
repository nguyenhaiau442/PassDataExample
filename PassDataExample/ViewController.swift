//
//  ViewController.swift
//  PassDataExample
//
//  Created by Nguyễn Hải Âu on 10/8/20.
//  Copyright © 2020 Nguyễn Hải Âu. All rights reserved.
//

import UIKit

// MARK:- Protocol
protocol ActionOnCell: class {
    
    func didTapInfoWithClosureButton(userInfo: User)
    
}

// MARK:- Model
struct User {
    
    var id: Int?
    var name: String?
    var age: Int?
    
}

// MARK:- ViewController
class ViewController: UIViewController {
    
    private let cellId = "cellId"
    var users: [User] = [User(id: 1, name: "Nguyễn Hải Âu", age: 22),
                         User(id: 2, name: "Phạm Phương Toán", age: 22),
                         User(id: 3, name: "Đào Thanh Huy", age: 22),
                         User(id: 4, name: "Danh Thái Bình", age: 23),
                         User(id: 5, name: "Trần Trân", age: 21)
                        ]
    
    lazy var tableView: UITableView = {
        let tbv = UITableView()
        tbv.translatesAutoresizingMaskIntoConstraints = false
        tbv.delegate = self
        tbv.dataSource = self
        tbv.register(UserCell.self, forCellReuseIdentifier: cellId)
        return tbv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "List User"
        view.backgroundColor = .white
        view.addSubview(tableView)
        let constraints = [
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    func showAlert(id: Int, name: String, age: Int) {
        let alertController = UIAlertController(title: "User Infomation", message: "Id: \(id)\nName: \(name)\nAge: \(age)", preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(alertAction)
        present(alertController, animated: true, completion: nil)
    }
    
}

// MARK:- Cell
class UserCell: UITableViewCell {
    
    var user: User? {
        didSet {
            if let name = user?.name {
                textLabel?.text = name
            }
        }
    }
    
    // delegate
    weak var delegate: ActionOnCell?
    
    // closure
    var didTapWithClosureButton: ((User?) -> Void)?
    
    lazy var infoWithDelegateButton: UIButton = {
        let b = UIButton()
        b.translatesAutoresizingMaskIntoConstraints = false
        b.setTitle("Delegate", for: .normal)
        b.backgroundColor = .brown
        b.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        b.setTitleColor(.white, for: .normal)
        b.addTarget(self, action: #selector(handleDidTapDelegateButton), for: .touchUpInside)
        return b
    }()
    
    lazy var infoWithClosureButton: UIButton = {
        let b = UIButton()
        b.translatesAutoresizingMaskIntoConstraints = false
        b.setTitle("Closure", for: .normal)
        b.backgroundColor = .purple
        b.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        b.setTitleColor(.white, for: .normal)
        b.addTarget(self, action: #selector(handleDidTapClosureButton), for: .touchUpInside)
        return b
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        contentView.addSubview(infoWithDelegateButton)
        contentView.addSubview(infoWithClosureButton)
        let constraints = [
            infoWithDelegateButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            infoWithDelegateButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            infoWithDelegateButton.widthAnchor.constraint(equalToConstant: 70),
            infoWithDelegateButton.heightAnchor.constraint(equalToConstant: 44),
            infoWithClosureButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            infoWithClosureButton.trailingAnchor.constraint(equalTo: infoWithDelegateButton.leadingAnchor, constant: -8),
            infoWithClosureButton.widthAnchor.constraint(equalToConstant: 70),
            infoWithClosureButton.heightAnchor.constraint(equalToConstant: 44)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func handleDidTapDelegateButton() {
        if let delegate = delegate {
            if let user = user {
                delegate.didTapInfoWithClosureButton(userInfo: user)
            }
        }
    }
    
    @objc func handleDidTapClosureButton() {
        if let didTapWithClosureButton = didTapWithClosureButton {
            didTapWithClosureButton(user)
        }
    }
    
}

// MARK:- Extension
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! UserCell
        cell.user = users[indexPath.row]
        cell.delegate = self
        cell.didTapWithClosureButton = { [weak self] (userInfo) in
            guard let self = self else { return }
            if let userInfo = userInfo {
                self.showAlert(id: userInfo.id!, name: userInfo.name!, age: userInfo.age!)
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
}

extension ViewController: ActionOnCell {
    
    func didTapInfoWithClosureButton(userInfo: User) {
        showAlert(id: userInfo.id!, name: userInfo.name!, age: userInfo.age!)
    }
    
}

