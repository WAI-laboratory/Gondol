//
//  BrailleTableViewController.swift
//  Gondol
//
//  Created by JYG on 2021/11/13.
//

import Foundation
import UIKit

class BrailleTableViewController: UISearchController {
    var braille = Braille
    private var filteredArr: [String:String] = [:]
    
    private let tableView = UITableView(frame: .zero, style: .insetGrouped)
    private let searchController = UISearchController(searchResultsController: nil)
    private var isFiltering: Bool {
        let searchCon = self.navigationItem.searchController
        let isActive = searchCon?.isActive ?? false
        let isSearchBarHasText = searchCon?.searchBar.text?.isEmpty == false
        let isContentButton = searchCon?.searchBar.showsScopeBar == false
        return (isActive && isSearchBarHasText) || (isActive && isContentButton)
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        initView()
    }
    
    private func initView() {
        searchController.searchBar.placeholder = "search"
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.scopeButtonTitles = ["All", "English", "Korean"]
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.hidesSearchBarWhenScrolling = false        
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = true
        navigationItem.largeTitleDisplayMode = .automatic

        view.add(tableView) {
            $0.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
        }
    }
}

extension BrailleTableViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.isFiltering ? self.filteredArr.count : self.braille.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell
        if let c = tableView.dequeueReusableCell(withIdentifier: "cell") {
            cell = c
        } else {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        }
        if self.isFiltering {
            cell.textLabel?.text = filteredArr[indexPath.row].value
            cell.detailTextLabel?.text = filteredArr[indexPath.row].key
        } else {
            cell.textLabel?.text = braille[indexPath.row].value
            cell.detailTextLabel?.text = braille[indexPath.row].key
        }
        return cell
    }
}

extension BrailleTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        if self.searchController.searchBar.selectedScopeButtonIndex == 0 {
            guard let text = searchController.searchBar.text else {return}
            self.filteredArr = self.braille.filter({ elem in
                elem.key.localizedCaseInsensitiveContains(text) == true
                || elem.value.localizedCaseInsensitiveContains(text)
            })
        } else if self.searchController.searchBar.selectedScopeButtonIndex == 1 {
            guard let text = searchController.searchBar.text else {return}
            self.filteredArr = englishToBraille.filter { $0.key.localizedCaseInsensitiveContains(text) == true}
        } else {
            guard let text = searchController.searchBar.text else {return}
            self.filteredArr = koreanToBraile.filter { $0.key.localizedCaseInsensitiveContains(text) == true}
        }
        updateView()
    }
    
    private func updateView() {
        tableView.reloadData()
    }
}
