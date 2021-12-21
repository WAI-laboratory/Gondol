//
//  MorseTableViewController.swift
//  Gondol
//
//  Created by 이용준 on 2021/12/21.
//

import Foundation
import UIKit

class MorseTableViewController: UISearchController {
    var morse = morseDictionary.sorted { $0.key < $1.key}
    
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
        tableView.backgroundColor = .clubhouseBackground
        
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
        navigationItem.largeTitleDisplayMode = .automatic

        view.add(tableView) {
            $0.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
        }
    }
}

extension MorseTableViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.isFiltering ? self.filteredArr.count : self.morse.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell
        if let c = tableView.dequeueReusableCell(withIdentifier: "morseCell") {
            cell = c
        } else {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: "morseCell")
        }
        if self.isFiltering {
            cell.textLabel?.text = filteredArr[indexPath.row].value
            cell.textLabel?.font = .preferredFont(forTextStyle: .title1)
            cell.detailTextLabel?.text = filteredArr[indexPath.row].key
            cell.detailTextLabel?.font = .preferredFont(forTextStyle: .title1)
        } else {
            cell.textLabel?.text = morse[indexPath.row].value
            cell.textLabel?.font = .preferredFont(forTextStyle: .title1)
            cell.detailTextLabel?.text = morse[indexPath.row].key
            cell.detailTextLabel?.font = .preferredFont(forTextStyle: .title1)
        }
        return cell
    }
}

extension MorseTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        if self.searchController.searchBar.selectedScopeButtonIndex == 0 {
            guard let text = searchController.searchBar.text else {return}
            self.filteredArr = morseDictionary.filter({ elem in
                elem.key.localizedCaseInsensitiveContains(text) == true
                || elem.value.localizedCaseInsensitiveContains(text)
            })
        } else if self.searchController.searchBar.selectedScopeButtonIndex == 1 {
            guard let text = searchController.searchBar.text else {return}
            self.filteredArr = englishToMorse.filter { $0.key.localizedCaseInsensitiveContains(text) == true}
        } else {
            guard let text = searchController.searchBar.text else {return}
            self.filteredArr = koreanToMorse.filter { $0.key.localizedCaseInsensitiveContains(text) == true}
        }
        updateView()
    }
    
    private func updateView() {
        tableView.reloadData()
    }
}
