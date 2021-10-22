//
//  SettingsViewController.swift
//  Verifier
//
//  Created by Emilio Apuzzo on 07/10/21.
//

import UIKit

protocol SettingsCoordinator: Coordinator {
    func dismissSettings(completion: (()->())?)
}

protocol SettingsDelegate {
    func goToFAQ()
    func goToPrivacy()
}

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var backButton: AppButton!
    @IBOutlet weak var tableView: UITableView!
    
    weak var coordinator: SettingsCoordinator?
    private var viewModel: SettingsViewModel
    
    private var pickerOptions = ["settings.mode.automatic".localized, "settings.mode.manual".localized]
    private var pickerView = UIPickerView()
    private var pickerToolBar = UIToolbar()
    
    private let informationsSettings = ["settings.faq".localized, "settings.privacy".localized]

    init(coordinator: SettingsCoordinator, viewModel: SettingsViewModel) {
        self.coordinator = coordinator
        self.viewModel = viewModel

        super.init(nibName: "SettingsViewController", bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        initializeBackButton()
        initializeTaleView()

    }
    
    private func initializeTaleView(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableHeaderView?.backgroundColor = .white
        tableView.tableHeaderView?.tintColor = .white
        tableView.separatorColor = .clear
        tableView.backgroundView?.backgroundColor = .white
        
        tableView.registerNibCell(ofType: SettingsCell.self, with: "settingsCell")
        tableView.register(UINib(nibName: "TableViewHeaderView", bundle: nil), forHeaderFooterViewReuseIdentifier: "TableViewHeaderViewTitle")
        tableView.register(UINib(nibName: "TableViewHeaderView", bundle: nil), forHeaderFooterViewReuseIdentifier: "TableViewHeaderView")
    }
    
    private func initializeBackButton() {
        backButton.style = .minimal
        backButton.setLeftImage(named: "icon_back")
    }
    
    @IBAction func goBack(_ sender: Any) {
        coordinator?.dismissSettings(completion: nil)
    }
    
    func modeViewDidTap() {
        PickerViewController.present(for: self, with: .init(
            doneButtonTitle: "label.done".localized,
            cancelButtonTitle: "label.cancel".localized,
            pickerOptions: self.pickerOptions,
            selectedOption: Store.get(key: .isTotemModeActive) == "0" ? 1 : 0,
            doneCallback: self.didTapDone,
            cancelCallback: nil
        ))
    }
    
    func faqDidTap() {
        guard let url = URL(string: Link.faq.url) else { return }
        UIApplication.shared.open(url)
    }
    
    func privacyPolicyDidTap() {
        guard let url = URL(string: Link.privacyPolicy.url) else { return }
        UIApplication.shared.open(url)
    }
    
    private func didTapDone(vc: PickerViewController) {
        let selectedRow: Int = vc.selectedRow()
        
        vc.selectRow(selectedRow, animated: false)
        Store.set(selectedRow == 0, for: .isTotemModeActive)
        tableView.reloadData()
    }
    
}

extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section{
        case 0:
            return 0
        case 1:
            return 1
        case 2:
            return 2
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "settingsCell", for: indexPath) as? SettingsCell else {return UITableViewCell()}
        
        switch indexPath.section{
        case 1:
            let value = Store.getBool(key: .isTotemModeActive)
            let valueString = value ? "settings.mode.automatic".localized : "settings.mode.manual".localized
            cell.fillCell(title: "settings.mode".localized, icon: "pencil", value: valueString)
        case 2:
            cell.fillCell(title: informationsSettings[indexPath.row], icon: "icon_arrow-right", value: nil)
        default:
            break
        }
        
        return cell
    }
        
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section{
        case 0:
            break
        case 1:
            switch indexPath.row{
            case 0:
                modeViewDidTap()
            default:
                break
            }
        case 2:
            switch indexPath.row{
            case 0:
                faqDidTap()
            case 1:
                privacyPolicyDidTap()
            default:
                break
            }
        default:
            break
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        guard let tableViewHeaderTitle = tableView.dequeueReusableHeaderFooterView(withIdentifier: "TableViewHeaderViewTitle") as? TableViewHeaderView else { return nil}
        
        guard let tableViewHeader = tableView.dequeueReusableHeaderFooterView(withIdentifier: "TableViewHeaderView") as? TableViewHeaderView else { return nil}
        
        switch section{
        case 0 :
            tableViewHeaderTitle.titleLabel.text = "settings.title".localized
            tableViewHeaderTitle.titleLabel.font = .boldSystemFont(ofSize: 24)
            return tableViewHeaderTitle

        case 1 :
            tableViewHeader.titleLabel.text = "settings.preferences".localized
            tableViewHeader.titleLabel.font = .boldSystemFont(ofSize: 14)
            tableViewHeader.separatorView?.removeFromSuperview()
            return tableViewHeader

        case 2 :
            tableViewHeader.titleLabel.text = "settings.informations".localized
            tableViewHeader.titleLabel.font = .boldSystemFont(ofSize: 14)
            tableViewHeader.separatorView?.removeFromSuperview()
            return tableViewHeader

        default:
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int){
        view.tintColor = UIColor.white
    }
}
