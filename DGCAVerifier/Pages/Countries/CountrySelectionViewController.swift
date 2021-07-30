//
//  CountrySelectionViewController.swift
//  VerificaC19
//
//  Created by Andrea Prosseda on 27/07/21.
//

import UIKit
import SwiftDGC

protocol CountrySelectionCoordinator: Coordinator {
    func showCamera(selectedCountry: CountryModel)
}

class CountrySelectionViewController: UIViewController {
    
    weak var coordinator: CountrySelectionCoordinator?
    private var viewModel: CountrySelectionViewModel
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var backButton: AppButton!
    @IBOutlet weak var movementsView: UIView!

    init(coordinator: CountrySelectionCoordinator, viewModel: CountrySelectionViewModel) {
        self.coordinator = coordinator
        self.viewModel = viewModel
        
        super.init(nibName: "CountrySelectionViewController", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        initialize()
    }
    
    func initialize() {
        view.backgroundColor = Palette.gray
        [CountryCell.self].forEach { tableView.registerNibCell(ofType: $0) }
        initializeTableView()
        initializeBackButton()
        initializeMovementsView()
        tableView.reloadData()
    }
    
    func initializeTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.estimatedRowHeight = 44
        tableView.tintColor = Palette.blue
        tableView.backgroundColor = Palette.gray
    }
    
    private func initializeBackButton() {
        backButton.style = .minimal
        backButton.setLeftImage(named: "icon_back")
    }
    
    private func initializeMovementsView() {
        movementsView.backgroundColor = Palette.grayDark
        let tap = UIGestureRecognizer(target: self, action: #selector(movementsDidTap))
        movementsView.addGestureRecognizer(tap)
    }
    
    @objc func movementsDidTap() {
        
    }
    
    @IBAction func back(_ sender: Any) {
        coordinator?.dismiss()
    }
    
}

extension CountrySelectionViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let country = viewModel.getCountry(at: indexPath.row) else { return }
        coordinator?.showCamera(selectedCountry: country)
    }
    
}

extension CountrySelectionViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.countries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(ofType: CountryCell.self, for: indexPath)
        let country = viewModel.getCountry(at: indexPath.row)
        cell.fillCell(with: country?.name ?? "")
        return cell
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        viewModel.countries.initials.distinct().flatMap { [$0, ""] }
    }
    
    func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        let idx = (title == "") ? index+1 : index
        let firstLetter = sectionIndexTitles(for: tableView)?.get(idx) ?? ""
        let value = viewModel.getIndexOfCountry(startingWith: firstLetter) ?? 0
        tableView.scrollToRow(at: .init(row: value, section: 0), at: .top, animated: false)
        return value
    }
    
}
