//
//  TableViewSingleSectionLoadMoreDataImpl.swift
//  TableView
//
//  Created by Vadym Zhydenko on 25.10.2020.
//

import UIKit

class TableViewLoadMoreDataImpl: NSObject, TableViewLoadMoreData {

    let header: UIView?
    let footer: UIView?
    private(set) var sectionModels: [TableViewSectionModel]

    let onLoadMore: (TableViewData, @escaping ([TableViewSectionModel]?) -> Void) -> Void
    private(set) var state: TableViewDataState = .normal(.yes)

    init(
        header: UIView? = nil,
        footer: UIView? = nil,
        sectionModels: [TableViewSectionModel],
        onLoadMore: @escaping (TableViewData, @escaping ([TableViewSectionModel]?) -> Void) -> Void
    ) {
        self.header = header
        self.footer = footer
        self.sectionModels = sectionModels
        self.onLoadMore = onLoadMore
        super.init()
    }

    func beginLoadMore(_ tableView: UITableView) -> Bool {
        state = .loadingMore
        tableView.tableFooterView = UIView.loadingFooterView(width: tableView.bounds.size.width, height: 44)
        return true
    }

    func endLoadMore(_ tableView: UITableView, sectionModels: [TableViewSectionModel]?) {
        tableView.beginUpdates()
        tableView.tableFooterView = nil

        let state: TableViewDataState
        defer {
            tableView.endUpdates()
            self.state = state
        }
        
        guard let sectionModel = sectionModels?.first else { return state = .normal(.no) }
        let insertSection = self.sectionModels.count
        self.sectionModels.append(sectionModel)
        tableView.insertSections(IndexSet(integer: insertSection), with: .left)
        state = .normal(.yes)
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        sectionModels.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        sectionModels[section].cellModels.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableView.dequeueConfigured(cellModel: sectionModels[indexPath.section].cellModels[indexPath.row], for: indexPath)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        sectionModels[indexPath.section].cellModels[indexPath.row].viewHeight.value
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard case .some(let closure) = sectionModels[indexPath.section].cellModels[indexPath.row].selection else { return }
        closure()
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard indexPath.section == sectionModels.count - 1,
            indexPath.row == sectionModels[indexPath.section].cellModels.count - 1,
            state.canLoadMore
            else { return }

        guard beginLoadMore(tableView) else { return }

        onLoadMore(self) { [weak tableView, weak self] sections in
            guard let tableView = tableView else { return }
            self?.endLoadMore(tableView, sectionModels: sections)
        }
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let model = sectionModels[section].headerModel else { return nil }
        return tableView.dequeueConfigured(headerFooterViewModel: model)
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        sectionModels[section].headerModel?.viewHeight.value ?? 0
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard let model = sectionModels[section].footerModel else { return nil }
        return tableView.dequeueConfigured(headerFooterViewModel: model)
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        sectionModels[section].footerModel?.viewHeight.value ?? 0
    }

}
