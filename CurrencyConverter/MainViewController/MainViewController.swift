//
//  ViewController.swift
//  CurrencyConverter
//
//  Created by milan.mia on 5/16/20.
//  Copyright © 2020 fftsys. All rights reserved.
//

import UIKit
import RealmSwift

/// protocol Main View
protocol MainView: class {
    func didReceivedConversion(quote:String)
    func didReceivedQuotes(live: InfoRealm?, rates: Results<RateRealm>?)
    func onError(error: CurrencyError)
    func showPicker()
    func hidePicker()
}

/// Main Screen
internal final class MainViewController: UIViewController {

    //MARK: - Properties
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var textInputView: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var sourceBtn: UIButton!
    @IBOutlet weak var targetBtn: UIButton!
    @IBOutlet weak var convertedLabel: UILabel!
    
    lazy var pickerView: UIPickerView = {
       let tempPickerView = UIPickerView()
        tempPickerView.delegate = self
        tempPickerView.dataSource = self
        tempPickerView.frame = CGRect.init(x: 0, y: view.bounds.height-200, width: view.bounds.width, height: 200)
        tempPickerView.backgroundColor = .white
        return tempPickerView
    }()
    
    private var rates: Results<RateRealm>? = nil {
        didSet {
            self.updateQuotes()
        }
    }
    
    private var info: InfoRealm? = nil {
        didSet {
        }
    }
    
    var presenter: MainPresentation!

    // MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        presenter.viewDidLoad()
    }
    
    func setupView() {
        tableView.register(R.nib.currencyListCell)
    }
    
    func updateQuotes() {
        let dateString = info?.timestamp.toDateString()
        dateLabel.text = "Currency update time: \(dateString ?? "DDDDD")"
        textInputView.text = "1.0"
        sourceBtn.setTitle(info?.source, for: .normal)

        if let rate = rates?.first(where: {$0.target == "JPY"}) {
            convertedLabel.text = "= \(rate.value) JPY"
        }
        tableView.reloadData()
    }
    
    // MARK: - Actions
    
    @IBAction func sourceSelectAction(_ sender: UIButton) {
        presenter.showPicker()
    }
    
    @IBAction func targetBtnAction(_ sender: UIButton) {
        presenter.showPicker()
    }
    
    @IBAction func convertAction(_ sender: Button) {
        presenter.hidePicker()
        textInputView.resignFirstResponder()
        guard let from = sourceBtn.title(for: .normal) else {return}
        guard let to = targetBtn.title(for: .normal) else {return}
        guard let amount = Double(textInputView.text ?? "0.0") else {return}
        presenter.fetchRateFor(from: from, to: to, amount: amount)
    }
}

// MARK: - UITableViewDataSource

extension MainViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rates?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: R.nib.currencyListCell, for: indexPath) else { return UITableViewCell() }
        if let rate = rates?[indexPath.row] {
            cell.bind(rate: rate)
        }
        return cell
    }

}
// MARK: - UITableViewDelegate

extension MainViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

}

// MARK: - MainView

extension MainViewController: MainView {
    
    func didReceivedConversion(quote: String) {
        convertedLabel.text = quote
    }
    
    func showPicker() {
        view.addSubview(pickerView)
    }
    
    func hidePicker() {
        pickerView.removeFromSuperview()
    }
    
    func didReceivedQuotes(live: InfoRealm?, rates: Results<RateRealm>?) {
        self.info = live
        self.rates = rates
    }

    func onError(error: CurrencyError) {
        switch error {
        case .quotesJsonDecodeFailed:
            presenter.showAlert(title: error.localizedDescription.title, message: error.localizedDescription.message, actionHandler: {
                self.presenter.retryFetch()
            })
        default:
            presenter.showAlert(title: error.localizedDescription.title, message: error.localizedDescription.message, actionHandler: {
                self.updateQuotes()
            })
        }
        
    }
}

// MARK: - Picker delegate, Datasource

extension MainViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        var title = "USD"
        if row > 0 {
            if let rate = rates?[row-1] {
                title = rate.target
            }
        }
        if component == 0 {
            sourceBtn.setTitle(title, for: .normal)
        }else {
            targetBtn.setTitle(title, for: .normal)
        }
    }
}

extension MainViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        guard let count = rates?.count else {
            return 0
        }
        return count == 0 ? 0 : (count + 1)
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if row == 0 {
            return "USD"
        }
        if let rate = rates?[row-1] {
            return rate.target
        }
        return ""
    }
}

// MARK: - TextField delegate

extension MainViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        textField.keyboardType = .numbersAndPunctuation
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        self.convertAction(Button())
        return true
    }
}
