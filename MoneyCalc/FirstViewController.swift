//
//  FirstViewController.swift
//  MoneyCalc
//
//  Created by Mike Ovyan on 09/03/2018.
//  Copyright © 2018 Mike Ovyan. All rights reserved.
//

import UIKit
import QuartzCore

class FirstViewController: UIViewController, UITextFieldDelegate{



    @IBOutlet weak var flatPrice: UITextField!
    @IBOutlet var keepMoney: UITextField!
    @IBOutlet var spendMoney: UITextField!
    @IBOutlet var myMoney: UITextField!
    @IBOutlet var depositPercentLabel: UILabel!

    @IBOutlet weak var depositSlider: UISlider!
    
    @IBAction func depositSliderChanged(_ sender: Any) {
        depositSlider.value = round(depositSlider.value * 2)/2
        depositPercentLabel.text = "под \(depositSlider.value)%"
        updateMessage()
    }
    @IBOutlet weak var creditPercentLabel: UILabel!

    @IBOutlet weak var creditSlider: UISlider!
    @IBAction func creditSliderChange(_ sender: UISlider) {
        creditSlider.value = round(creditSlider.value * 2)/2
        creditPercentLabel.text = "под \(creditSlider.value)%"
        updateMessage()
    }
    @IBOutlet weak var endMessage: UITextView!
    
    @IBOutlet weak var totalCredit: UILabel!
    @IBOutlet weak var totalDeposit: UILabel!
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

    }
    
    func getNum(s: String) -> Int64 {
        var res:Int64 = 0
        for i in s {
            res = res*10 + (Int64(String(i)))!
        }
        return res
    }
    

    func countCredit() -> Int64 {
        let s1 = flatPrice.text!
        let s2 = myMoney.text!
        let s3 = keepMoney.text!
        let s4 = spendMoney.text!
        var t:Double = 0
        var k:Double = 0
        var p:Double = 0
        var p4:Double = 0
        for i in s1 {
            t = t*10 + Double((Int64(String(i)))!)
        }
        for i in s2 {
            k = k*10 + Double((Int64(String(i)))!)
        }
        for i in s3 {
            p = p*10 + Double((Int64(String(i)))!)
        }
        for i in s4 {
            p4 = p4*10 + Double((Int64(String(i)))!)
        }
        t -= k
        t *= Double(creditSlider.value/100)
        t /= 12*(p+p4)
        t = 1 - t
        let b = 1 + Double(creditSlider.value/12/100)
        if (t <= 0) {
            return -1
        }
        let res = logC(val: Double(t), forBase: Double(b))
        return Int64(res)*(-1) + 1
    }
    
    func countDeposit() -> Int64 {
        var j:Int64 = 0
        var res:Double = 0
        let s1 = keepMoney.text!
        var keep:Double = 0
        for i in s1 {
            keep = keep*10 + Double(Int64(String(i))!)
        }
        let s2 = myMoney.text!
        var my:Double = 0
        for i in s2 {
            my = my*10 + Double(Int64(String(i))!)
        }
        let s3 = flatPrice.text!
        var price:Double = 0
        for i in s3 {
            price = price*10 + Double(Int64(String(i))!)
        }
        res = my
        while res < price {
            res = (res + keep)*(1+Double(depositSlider.value)/100/12)
            j += 1
        }
        return j
    }
    //Tap on screen
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        updateMessage()
    }
    //log
    func logC(val: Double, forBase base: Double) -> Double {
        return log(val)/log(base)
    }
    func updateMessage() -> Void {
        totalDeposit.layer.cornerRadius = 5
        totalCredit.layer.cornerRadius = 5
        if (getNum(s: myMoney.text!) >= getNum(s: flatPrice.text!)) {
            totalCredit.text = "Недоступно"
            totalDeposit.text = "Недоступно"
            endMessage.text = "У вас уже есть достаточно денег!"
            return
        }
        if (getNum(s: spendMoney.text!) + getNum(s: keepMoney.text!) <= 0) {
            totalCredit.text = "Недоступно"
            totalDeposit.text = "Недоступно"
            endMessage.text = "Вам не на чем копить!"
        }
        if countCredit() == -1 {
            totalCredit.text = "Недоступно"
            //totalCredit.textColor = UIColor.red
            totalCredit.layer.backgroundColor = UIColor.init(red: 180, green: 0, blue: 0, alpha: 1).cgColor
            totalDeposit.text = "\((countDeposit()-1)*(getNum(s: keepMoney.text!)) + getNum(s: myMoney.text!) + (countDeposit()*(getNum(s: spendMoney.text!))))₽"
            //totalDeposit.backgroundColor = UIColor.init(red: 0, green: 153  , blue: 0, alpha: 1)
            totalDeposit.layer.backgroundColor = UIColor.init(red: 0, green: 160, blue: 0, alpha: 1).cgColor

            endMessage.text = "Итог ипотеки: Ипотека при таких условиях недоступна!\nИтог кредита: \((countDeposit()-1)*(getNum(s: keepMoney.text!)) + getNum(s: myMoney.text!) + (countDeposit()*(getNum(s: spendMoney.text!))))₽\nИпотека: Ипотека при таких условиях недоступна!" + "\nВклад: открою вклад под \(depositSlider.value)% годовых, внесу \(myMoney.text!)₽, буду каждый месяц пополнять вклад на \(keepMoney.text!)₽ и снимать жилье за \(spendMoney.text!)₽. За \(countDeposit()/12) лет и \(countDeposit()%12) месяцев потрачу \((countDeposit()-1)*(getNum(s: keepMoney.text!)) + getNum(s: myMoney.text!))₽ на пополнение вклада и \((countDeposit()*(getNum(s: spendMoney.text!))))₽ на аренду жилья, в сумме \((countDeposit()-1)*(getNum(s: keepMoney.text!)) + getNum(s: myMoney.text!) + (countDeposit()*(getNum(s: spendMoney.text!))))₽. За это же время на вкладе накопится стоимость квартиры: \(flatPrice.text!)₽, включая \(getNum(s: flatPrice.text!) - (countDeposit()-1)*(getNum(s: keepMoney.text!)) - getNum(s: myMoney.text!))₽, которые начислит банк в виде процентов."
        } else {
            if countCredit()*(getNum(s: keepMoney.text!) + getNum(s: spendMoney.text!)) + getNum(s: myMoney.text!) >= (countDeposit()-1)*(getNum(s: keepMoney.text!)) + getNum(s: myMoney.text!) + (countDeposit()*(getNum(s: spendMoney.text!))) {
                totalCredit.text = "\(countCredit()*(getNum(s: keepMoney.text!) + getNum(s: spendMoney.text!)) + getNum(s: myMoney.text!))₽"
                totalCredit.layer.backgroundColor = UIColor.init(red: 180, green: 0, blue: 0, alpha: 1).cgColor
                totalDeposit.text = "\((countDeposit()-1)*(getNum(s: keepMoney.text!)) + getNum(s: myMoney.text!) + (countDeposit()*(getNum(s: spendMoney.text!))))₽"
                totalDeposit.layer.backgroundColor = UIColor.init(red: 0, green: 160, blue: 0, alpha: 1).cgColor
                } else {
                    totalCredit.text = "\(countCredit()*(getNum(s: keepMoney.text!) + getNum(s: spendMoney.text!)) + getNum(s: myMoney.text!))₽"
                    //totalCredit.textColor = UIColor.green
                    totalCredit.layer.backgroundColor = UIColor.init(red: 0, green: 160, blue: 0, alpha: 1).cgColor
                    totalDeposit.text = "\((countDeposit()-1)*(getNum(s: keepMoney.text!)) + getNum(s: myMoney.text!) + (countDeposit()*(getNum(s: spendMoney.text!))))₽"
                    //totalDeposit.textColor = UIColor.red
                    totalDeposit.layer.backgroundColor = UIColor.init(red: 180, green: 0, blue: 0, alpha: 1).cgColor

                }
            
        endMessage.text = "Итог ипотеки: \(countCredit()*(getNum(s: keepMoney.text!) + getNum(s: spendMoney.text!)) + getNum(s: myMoney.text!))₽ \nИтог кредита: \((countDeposit()-1)*(getNum(s: keepMoney.text!)) + getNum(s: myMoney.text!) + (countDeposit()*(getNum(s: spendMoney.text!))))₽ \nИпотека: Потрачу \(myMoney.text!)₽ на первоначальный взнос, а \(getNum(s: flatPrice.text!) - getNum(s: myMoney.text!))₽ возьму в кредит и буду каждый месяц отдавать банку по \(getNum(s: keepMoney.text!) + getNum(s: spendMoney.text!))₽. За \(countCredit()/12) лет и \(countCredit() % 12) месяцев потрачу на покупку квартиры и погашение ипотеки \(countCredit()*(getNum(s: keepMoney.text!) + getNum(s: spendMoney.text!)) + getNum(s: myMoney.text!))₽, включая \(countCredit()*(getNum(s: keepMoney.text!) + getNum(s: spendMoney.text!)) + getNum(s: myMoney.text!) - getNum(s: flatPrice.text!))₽ переплаты по процентам." + "\nВклад: открою вклад под \(depositSlider.value)% годовых, внесу \(myMoney.text!)₽, буду каждый месяц пополнять вклад на \(keepMoney.text!)₽ и снимать жилье за \(spendMoney.text!)₽. За \(countDeposit()/12) лет и \(countDeposit()%12) месяцев потрачу \((countDeposit()-1)*(getNum(s: keepMoney.text!)) + getNum(s: myMoney.text!))₽ на пополнение вклада и \((countDeposit()*(getNum(s: spendMoney.text!))))₽ на аренду жилья, в сумме \((countDeposit()-1)*(getNum(s: keepMoney.text!)) + getNum(s: myMoney.text!) + (countDeposit()*(getNum(s: spendMoney.text!))))₽. За это же время на вкладе накопится стоимость квартиры: \(flatPrice.text!)₽, включая \(getNum(s: flatPrice.text!) - (countDeposit()-1)*(getNum(s: keepMoney.text!)) - getNum(s: myMoney.text!))₽, которые начислит банк в виде процентов."
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        endMessage.setContentOffset(CGPoint.zero, animated: false)
    }

}

