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
    @IBOutlet weak var titleLabel: AppLabel!
    @IBOutlet weak var preferencesLabel: AppLabel!
    @IBOutlet weak var informationsLabel: AppLabel!
    @IBOutlet weak var modeView: AppShadowView!
    @IBOutlet weak var modeLabel: AppLabel!
    @IBOutlet weak var modeValueLabel: AppLabel!
    @IBOutlet weak var faqView: AppShadowView!
    @IBOutlet weak var faqLabel: AppLabel!
    @IBOutlet weak var privacyView: AppShadowView!
    @IBOutlet weak var privacyLabel: AppLabel!
    
    weak var coordinator: SettingsCoordinator?
    private var viewModel: SettingsViewModel
    
    private var pickerOptions = ["settings.mode.automatic".localized, "settings.mode.manual".localized]
    private var pickerView = UIPickerView()
    private var pickerToolBar = UIToolbar()
    
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
        setUpTitle()
        setUpModeView()
        setUpFAQView()
        setUpPrivacyView()
        setUpViewActions()
    }
    
    private func initializeBackButton() {
        backButton.style = .minimal
        backButton.setLeftImage(named: "icon_back")
    }
    
    private func setUpTitle(){
        titleLabel.text = "settings.title".localized
        titleLabel.font = .boldSystemFont(ofSize: 15)
        preferencesLabel.text = "settings.preferences".localized
        informationsLabel.text = "settings.informations".localized
    }
    
    private func setUpModeView(){
        modeLabel.text = "settings.mode".localized
        modeValueLabel.text = (Store.getBool(key: .isTotemModeActive)) ? "settings.mode.automatic".localized : "settings.mode.manual".localized
        modeLabel.font = .boldSystemFont(ofSize: 15)
    }
    
    private func setUpFAQView(){
        faqLabel.text = "settings.faq".localized
        faqLabel.font = .boldSystemFont(ofSize: 15)
    }
    
    private func setUpPrivacyView(){
        privacyLabel.text = "settings.privacy".localized
        privacyLabel.font = .boldSystemFont(ofSize: 15)
    }
    
    private func setUpViewActions(){
        let faqTapGesture = UITapGestureRecognizer(target: self, action: #selector(faqDidTap))
        faqView.addGestureRecognizer(faqTapGesture)
        let privacyTapGesture = UITapGestureRecognizer(target: self, action: #selector(privacyPolicyDidTap))
        privacyView.addGestureRecognizer(privacyTapGesture)
        let pickerModeTapGesture = UITapGestureRecognizer(target: self, action: #selector(modeViewDidTap))
        modeView.addGestureRecognizer(pickerModeTapGesture)

    }
    
    @IBAction func goBack(_ sender: Any) {
        coordinator?.dismissSettings(completion: nil)
    }
    
    @objc func faqDidTap(_ sender: UITapGestureRecognizer) {
        guard let url = URL(string: Link.faq.url) else { return }
        UIApplication.shared.open(url)
    }
    
    @objc func privacyPolicyDidTap(_ sender: UITapGestureRecognizer) {
        guard let url = URL(string: Link.privacyPolicy.url) else { return }
        UIApplication.shared.open(url)
    }
    
    @objc func modeViewDidTap(_ sender: UITapGestureRecognizer) {
        PickerViewController.present(for: self, with: .init(
            doneButtonTitle: "Done",
            cancelButtonTitle: "Cancel",
            pickerOptions: self.pickerOptions,
            selectedOption: Store.get(key: .isTotemModeActive) == "0" ? 1 : 0,
            doneCallback: self.didTapDone,
            cancelCallback: nil
        ))
    }
    
    private func didTapDone(vc: PickerViewController) {
        let selectedRow: Int = vc.selectedRow()
        
        vc.selectRow(selectedRow, animated: false)
        self.modeValueLabel.text = self.pickerOptions[selectedRow]
        Store.set(selectedRow == 0, for: .isTotemModeActive)
    }
    
}
