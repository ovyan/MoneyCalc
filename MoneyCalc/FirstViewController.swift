//
//  FirstViewController.swift
//  MoneyCalc
//
//  Created by Mike Ovyan on 09/03/2018.
//  Copyright © 2018 Mike Ovyan. All rights reserved.
//

import UIKit

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
    
    func getNum(s: String) -> Int {
        var res:Int = 0
        for i in s {
            res = res*10 + (Int(String(i)))!
        }
        return res
    }
    

    func countCredit() -> Int {
        let s1 = flatPrice.text!
        let s2 = myMoney.text!
        let s3 = keepMoney.text!
        let s4 = spendMoney.text!
        var t:Float = 0.0
        var k:Float = 0.0
        var p:Float = 0.0
        var p4:Float = 0.0
        for i in s1 {
            t = t*10 + Float((Int(String(i)))!)
        }
        for i in s2 {
            k = k*10 + Float((Int(String(i)))!)
        }
        for i in s3 {
            p = p*10 + Float((Int(String(i)))!)
        }
        for i in s4 {
            p4 = p4*10 + Float((Int(String(i)))!)
        }
        t -= k
        t *= creditSlider.value/100
        t /= 12*(p+p4)
        t = 1 - t
        let b = 1 + creditSlider.value/12/100
        if (t <= 0) {
            return -1
        }
        let res = logC(val: Double(t), forBase: Double(b))
        return Int(res)*(-1) + 1
    }
    
    func countDeposit() -> Int {
        var j = 0
        var res:Double = 0
        let s1 = keepMoney.text!
        var keep:Double = 0
        for i in s1 {
            keep = keep*10 + Double(Int(String(i))!)
        }
        let s2 = myMoney.text!
        var my:Double = 0
        for i in s2 {
            my = my*10 + Double(Int(String(i))!)
        }
        let s3 = flatPrice.text!
        var price:Double = 0
        for i in s3 {
            price = price*10 + Double(Int(String(i))!)
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
        endMessage.text = "Итог ипотеки: \(countCredit()*(getNum(s: keepMoney.text!) + getNum(s: spendMoney.text!)) + getNum(s: myMoney.text!))₽ \nИтог кредита: \((countDeposit()-1)*(getNum(s: keepMoney.text!)) + (countDeposit()*(getNum(s: spendMoney.text!))))₽\nИпотека: Потрачу \(myMoney.text!)₽ на первоначальный взнос, а \(getNum(s: flatPrice.text!) - getNum(s: myMoney.text!))₽ возьму в кредит и буду каждый месяц отдавать банку по \(getNum(s: keepMoney.text!) + getNum(s: spendMoney.text!))₽. За \(countCredit()/12) лет и \(countCredit() % 12) месяцев потрачу на покупку квартиры и погашение ипотеки \(countCredit()*(getNum(s: keepMoney.text!) + getNum(s: spendMoney.text!)) + getNum(s: myMoney.text!))₽, включая \(countCredit()*(getNum(s: keepMoney.text!) + getNum(s: spendMoney.text!)) + getNum(s: myMoney.text!) - getNum(s: flatPrice.text!))₽ переплаты по процентам." + "\nВклад: открою вклад под \(depositSlider.value)% годовых, внесу \(myMoney.text!)₽, буду каждый месяц пополнять вклад на \(keepMoney.text!)₽ и снимать жилье за \(spendMoney.text!)₽. За \(countDeposit()/12) лет и \(countDeposit()%12) месяцев потрачу \((countDeposit()-1)*(getNum(s: keepMoney.text!)))₽ на пополнение вклада и \((countDeposit()*(getNum(s: spendMoney.text!))))₽ на аренду жилья, в сумме \((countDeposit()-1)*(getNum(s: keepMoney.text!)) + (countDeposit()*(getNum(s: spendMoney.text!))))₽. За это же время на вкладе накопится стоимость квартиры: \(flatPrice.text!)₽, включая \(getNum(s: flatPrice.text!) - (countDeposit()-1)*(getNum(s: keepMoney.text!)))₽, которые начислит банк в виде процентов."
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

