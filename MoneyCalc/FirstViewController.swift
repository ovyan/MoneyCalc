//
//  FirstViewController.swift
//  MoneyCalc
//
//  Created by Mike Ovyan on 09/03/2018.
//  Copyright © 2018 Mike Ovyan. All rights reserved.
//

import QuartzCore
import UIKit

final class FirstViewController: UIViewController {
    @IBOutlet var flatPrice: UITextField!
    @IBOutlet var keepMoney: UITextField!
    @IBOutlet var spendMoney: UITextField!
    @IBOutlet var myMoney: UITextField!
    @IBOutlet var depositPercentLabel: UILabel!
    @IBOutlet var depositSlider: UISlider!
    @IBAction func depositSliderChanged(_ sender: Any) {
        depositSlider.value = round(depositSlider.value * 2) / 2
        depositPercentLabel.text = "под \(depositSlider.value)%"
        updateMessage()
    }

    @IBOutlet var creditPercentLabel: UILabel!

    @IBOutlet var creditSlider: UISlider!
    @IBAction func creditSliderChange(_ sender: UISlider) {
        creditSlider.value = round(creditSlider.value * 2) / 2
        creditPercentLabel.text = "под \(creditSlider.value)%"
        updateMessage()
    }

    @IBOutlet var endMessage: UITextView!
    @IBOutlet var totalCredit: UILabel!
    @IBOutlet var totalDeposit: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        myMoney.keyboardType = UIKeyboardType.numberPad
        myMoney.text = "1000000"
        spendMoney.keyboardType = UIKeyboardType.numberPad
        spendMoney.text = "30000"
        keepMoney.keyboardType = UIKeyboardType.numberPad
        keepMoney.text = "20000"
        flatPrice.keyboardType = UIKeyboardType.numberPad
        flatPrice.text = "3050000"
        creditPercentLabel.text = "под \(creditSlider.value)%"
        depositPercentLabel.text = "под \(depositSlider.value)%"
        updateMessage()
        setBackgroundColor()
    }

    private func setBackgroundColor() {
        view.backgroundColor = #colorLiteral(red: 0.20170632, green: 0.737088263, blue: 0.599953115, alpha: 1)
    }

    func getNum(s: String) -> Int {
        let s = s.stripped
        var res: Int = 0
        for i in s {
            res = res * 10 + (Int(String(i)))!
        }
        return res
    }

    func countCredit() -> Int {
        var t: Float = Float(getNum(s: flatPrice.text!))
        let k: Float = Float(getNum(s: myMoney.text!))
        let p: Float = Float(getNum(s: keepMoney.text!))
        let p4: Float = Float(getNum(s: spendMoney.text!))

        t -= k
        t *= creditSlider.value / 100
        t /= 12 * (p + p4)
        t = 1 - t
        let b = 1 + creditSlider.value / 12 / 100
        if t <= 0 {
            return -1
        }
        let res = logC(val: Double(t), forBase: Double(b))
        return Int(res) * (-1) + 1
    }

    func countDeposit() -> Int {
        var j = 0
        var res: Double = 0
        let keep: Double = Double(getNum(s: keepMoney.text!))
        let my: Double = Double(getNum(s: myMoney.text!))
        let price: Double = Double(getNum(s: flatPrice.text!))
        res = my
        while res < price {
            res = (res + keep) * (1 + Double(depositSlider.value) / 100 / 12)
            j += 1
        }
        return j
    }

    // Tap on screen
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
        updateMessage()
    }

    // log
    func logC(val: Double, forBase base: Double) -> Double {
        return log(val) / log(base)
    }

    func updateMessage() {
        totalDeposit.layer.cornerRadius = 5
        totalCredit.layer.cornerRadius = 5
        if getNum(s: myMoney.text!) >= getNum(s: flatPrice.text!) {
            totalCredit.text = "Недоступно"
            totalDeposit.text = "Недоступно"
            endMessage.text = "У вас уже есть достаточно денег!"
            return
        }
        if getNum(s: spendMoney.text!) + getNum(s: keepMoney.text!) <= 0 {
            totalCredit.text = "Недоступно"
            totalDeposit.text = "Недоступно"
            endMessage.text = "Вам не на чем копить!"
        }
        if countCredit() == -1 {
            totalCredit.text = "Недоступно"
            totalCredit.layer.backgroundColor = UIColor(red: 180, green: 0, blue: 0, alpha: 1).cgColor

            let totalDepSum = (countDeposit() - 1) * (getNum(s: keepMoney.text!)) + getNum(s: myMoney.text!) + (countDeposit() * (getNum(s: spendMoney.text!)))

            totalDeposit.text = "\(totalDepSum.prettyNumber)₽"
            totalDeposit.layer.backgroundColor = UIColor(red: 0, green: 160, blue: 0, alpha: 1).cgColor

            let totalCreditSum = (countDeposit() - 1) * (getNum(s: keepMoney.text!)) + getNum(s: myMoney.text!) + (countDeposit() * (getNum(s: spendMoney.text!)))

            let totalSpendSum = (countDeposit() - 1) * (getNum(s: keepMoney.text!)) + getNum(s: myMoney.text!)

            endMessage.text = "Итог ипотеки: Ипотека при таких условиях недоступна!\nИтог кредита: \(totalCreditSum.prettyNumber) ₽\n" +
                "Ипотека: Ипотека при таких условиях недоступна!" +
                "\nВклад: открою вклад под \(depositSlider.value)% годовых, внесу \(myMoney.text!)₽, буду каждый месяц пополнять вклад на \(keepMoney.text!)₽ и снимать жилье за \(spendMoney.text!)₽." +
                "За \(countDeposit() / 12) лет и \(countDeposit() % 12) месяцев потрачу \(totalSpendSum.prettyNumber)₽ на пополнение вклада и \((countDeposit() * (getNum(s: spendMoney.text!))))₽ на аренду жилья, в сумме \((countDeposit() - 1) * (getNum(s: keepMoney.text!)) + getNum(s: myMoney.text!) + (countDeposit() * (getNum(s: spendMoney.text!))))₽. За это же время на вкладе накопится стоимость квартиры: \(flatPrice.text!)₽, включая \(getNum(s: flatPrice.text!) - (countDeposit() - 1) * (getNum(s: keepMoney.text!)) - getNum(s: myMoney.text!))₽, которые начислит банк в виде процентов."
        } else {
            if countCredit() * (getNum(s: keepMoney.text!) + getNum(s: spendMoney.text!)) + getNum(s: myMoney.text!) >= (countDeposit() - 1) * (getNum(s: keepMoney.text!)) + getNum(s: myMoney.text!) + (countDeposit() * (getNum(s: spendMoney.text!))) {
                totalCredit.text = "\(countCredit() * (getNum(s: keepMoney.text!) + getNum(s: spendMoney.text!)) + getNum(s: myMoney.text!))₽"
                totalCredit.layer.backgroundColor = UIColor(red: 180, green: 0, blue: 0, alpha: 1).cgColor
                totalDeposit.text = "\((countDeposit() - 1) * (getNum(s: keepMoney.text!)) + getNum(s: myMoney.text!) + (countDeposit() * (getNum(s: spendMoney.text!))))₽"
                totalDeposit.layer.backgroundColor = UIColor(red: 0, green: 160, blue: 0, alpha: 1).cgColor
            } else {
                totalCredit.text = "\(countCredit() * (getNum(s: keepMoney.text!) + getNum(s: spendMoney.text!)) + getNum(s: myMoney.text!))₽"
                totalCredit.layer.backgroundColor = UIColor(red: 0, green: 160, blue: 0, alpha: 1).cgColor
                totalDeposit.text = "\((countDeposit() - 1) * (getNum(s: keepMoney.text!)) + getNum(s: myMoney.text!) + (countDeposit() * (getNum(s: spendMoney.text!))))₽"
                totalDeposit.layer.backgroundColor = UIColor(red: 180, green: 0, blue: 0, alpha: 1).cgColor
            }

            endMessage.text = "Итог ипотеки: \(countCredit() * (getNum(s: keepMoney.text!) + getNum(s: spendMoney.text!)) + getNum(s: myMoney.text!))₽ \nИтог кредита: \((countDeposit() - 1) * (getNum(s: keepMoney.text!)) + getNum(s: myMoney.text!) + (countDeposit() * (getNum(s: spendMoney.text!))))₽ \nИпотека: Потрачу \(myMoney.text!)₽ на первоначальный взнос, а \(getNum(s: flatPrice.text!) - getNum(s: myMoney.text!))₽ возьму в кредит и буду каждый месяц отдавать банку по \(getNum(s: keepMoney.text!) + getNum(s: spendMoney.text!))₽. За \(countCredit() / 12) лет и \(countCredit() % 12) месяцев потрачу на покупку квартиры и погашение ипотеки \(countCredit() * (getNum(s: keepMoney.text!) + getNum(s: spendMoney.text!)) + getNum(s: myMoney.text!))₽, включая \(countCredit() * (getNum(s: keepMoney.text!) + getNum(s: spendMoney.text!)) + getNum(s: myMoney.text!) - getNum(s: flatPrice.text!))₽ переплаты по процентам." + "\nВклад: открою вклад под \(depositSlider.value)% годовых, внесу \(myMoney.text!)₽, буду каждый месяц пополнять вклад на \(keepMoney.text!)₽ и снимать жилье за \(spendMoney.text!)₽. За \(countDeposit() / 12) лет и \(countDeposit() % 12) месяцев потрачу \((countDeposit() - 1) * (getNum(s: keepMoney.text!)) + getNum(s: myMoney.text!))₽ на пополнение вклада и \((countDeposit() * (getNum(s: spendMoney.text!))))₽ на аренду жилья, в сумме \((countDeposit() - 1) * (getNum(s: keepMoney.text!)) + getNum(s: myMoney.text!) + (countDeposit() * (getNum(s: spendMoney.text!))))₽. За это же время на вкладе накопится стоимость квартиры: \(flatPrice.text!)₽, включая \(getNum(s: flatPrice.text!) - (countDeposit() - 1) * (getNum(s: keepMoney.text!)) - getNum(s: myMoney.text!))₽, которые начислит банк в виде процентов."
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        [flatPrice, keepMoney, spendMoney, myMoney].forEach { format($0) }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        endMessage.setContentOffset(CGPoint.zero, animated: false)
    }

    private func format(_ textField: UITextField) {
        let t = textField.text?.stripped
        textField.text = t?.prettyNumber
    }
}

extension FirstViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        format(textField)
        updateMessage()
    }
}
