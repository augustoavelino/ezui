//
//  DocumentationMenuViewController.swift
//  EZUIExample
//
//  Created by Augusto Avelino on 18/07/23.
//  Copyright © 2023 Augusto Avelino. All rights reserved.
//

import EZUI
import UIKit

class DocumentationMenuViewController<ViewModel: DocumentationMenuViewModelProtocol>:
    DSViewController<ViewModel>,
    DSTableViewModelDelegate {
    
    // MARK: UI
    
    var isListEmpty: Bool { false }
    var emptyListView: DSEmptyListView?
    lazy var tableView: EZTableView = EZTableView()
    
    // MARK: - Life cycle
    
    override init(viewModel: ViewModel) {
        super.init(viewModel: viewModel)
        title = String.appString(.documentationMenu(.title))
        tabBarItem.image = UIImage(systemName: "doc.append")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    
    override func setupUI() {}
    
    // MARK: - UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int { 0 }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { 0 }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell { UITableViewCell() }
}
