//
//  RMSearchOptionPickerViewController.swift
//  RickAndMorty
//
//  Created by Yi Chun Chiu on 2024/3/8.
//

import UIKit

class RMSearchOptionPickerViewController: UIViewController {
    
    private let option: RMSearchInputViewViewModel.DynamicOption
    
    private let selectionBlock: ((String) -> Void)
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    }()
     // MARK: - Init
    
    init(option: RMSearchInputViewViewModel.DynamicOption, selection: @escaping (String) -> Void) {
        self.option = option
        self.selectionBlock = selection
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
     // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setUptable()
        
    }
    
     // MARK: - Private
    private func setUptable() {
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

 // MARK: - Table View Delegate
extension RMSearchOptionPickerViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return option.choices.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let choice = option.choices[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = choice.uppercased()
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let choice = option.choices[indexPath.row]
        tableView.deselectRow(at: indexPath, animated: true)
        self.selectionBlock(choice)
        dismiss(animated: true)
    }
    
}
