//
//  ViewController.swift
//  CurrencyConverter
//
//  Created by milan.mia on 5/16/20.
//  Copyright © 2020 fftsys. All rights reserved.
//

import UIKit
import SVProgressHUD

/// protocol Main View
protocol MainView: class {
    func didReceivedConversion(quote:String)
    func didReceivedQuotes(currency:Currency)
    func onError(error: CurrencyError)
    func showHud()
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
    
    private var currencyData: Currency? = nil {
        didSet {
            self.updateQuotes()
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
        title = "Currency"
        tableView.register(R.nib.currencyListCell)
    }
    
    func updateQuotes() {
        let dateString = currencyData?.timestamp.toDateString()
        dateLabel.text = "Currency update time: \(dateString ?? "DDDDD")"
        textInputView.text = "1.0"
        sourceBtn.setTitle(currencyData?.source, for: .normal)

        if let rate = currencyData?.quotes.first(where: {$0.target == "JPY"}) {
            convertedLabel.text = "= \(rate.value) JPY"
        }
        tableView.reloadData()
    }
    
    // MARK: - Actions
    @IBAction func sourceSelectAction(_ sender: UIButton) {
        textInputView.resignFirstResponder()
        presenter.showPicker()
    }
    
    @IBAction func targetBtnAction(_ sender: UIButton) {
        textInputView.resignFirstResponder()
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
        return currencyData?.quotes.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: R.nib.currencyListCell, for: indexPath) else { return UITableViewCell() }
        let rate = currencyData?.quotes[indexPath.row] ?? Rate.init(source: "XXX", target: "XXX", value: 0.0)
        cell.bind(rate: rate)
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
        SVProgressHUD.dismiss()
        convertedLabel.text = quote
    }
    
    func showPicker() {
        view.addSubview(pickerView)
    }
    
    func hidePicker() {
        pickerView.removeFromSuperview()
    }
    
    func didReceivedQuotes(currency: Currency) {
        SVProgressHUD.dismiss()
        currencyData = currency
    }

    func onError(error: CurrencyError) {
        SVProgressHUD.dismiss()
        presenter.showAlert(title: error.localizedDescription.title,
                                message: error.localizedDescription.message,
                                actionHandler: { [weak self] in
                    self?.presenter.retryFetch()
            })
    }
    
    func showHud() {
        SVProgressHUD.show(withStatus: R.string.localizable.commonFetchProgress())
    }
}

// MARK: - Picker delegate, Datasource

extension MainViewController: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        var title = "USD"
        if row > 0 {
            if let rate = currencyData?.quotes[row-1] {
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
        guard let count = currencyData?.quotes.count else { return 0 }
        return count == 0 ? 0 : (count + 1)
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if row == 0 { return "USD" }
        if let rate = currencyData?.quotes[row-1] {
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
