//
//  testViewController.swift
//  asoviva
//
//  Created by 田中千洋 on 2017/08/18.
//  Copyright © 2017年 田中 颯. All rights reserved.
//

import UIKit
import Alamofire

class testViewController: UIViewController {

    var button:UIButton!
    var myTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.blue
        button = UIButton()

        button.frame = CGRect(x: 30, y: 50, width: self.view.frame.width - 60, height: 100)
        
        // ボタンの背景色を設定.
        button.backgroundColor = UIColor.red
        
        // ボタンの枠を丸くする.
        button.layer.masksToBounds = true
        
        // コーナーの半径を設定する.
        button.layer.cornerRadius = 20.0
        
        // タイトルを設定する(通常時).
        button.setTitle("ボタン(通常)", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        
        // タイトルを設定する(ボタンがハイライトされた時).
        button.setTitle("ボタン(押された時)", for: .highlighted)
        button.setTitleColor(UIColor.black, for: .highlighted)
        
        // ボタンにタグをつける.
        button.tag = 1
        
        // イベントを追加する
        //button.addTarget(self, action: #selector(tap(sender:UIButton)), for: .touchUpInside)
        button.addTarget(self, action: #selector(tap), for: .touchUpInside)
        
        // ボタンをViewに追加.
        self.view.addSubview(button)
        // Do any additional setup after loading the view.
        
        myTextView = UITextView()
        
        myTextView.frame = CGRect(x:10, y:200, width:self.view.frame.width - 20, height:300)
        
        // TextViewの背景を黃色に設定する.
        myTextView.backgroundColor = UIColor(red: 0.9, green: 0.9, blue: 1, alpha: 1.0)
        
        // 表示させるテキストを設定する.
        myTextView.text = "1234567890abcdefghijklmnopqrstuwxyz 1234567890 abcdefghijklmnopqrstuwxyz \na\nb\nc\ndefghijklmnopqrstuwxyz \n http://www.gclue.com\n"
        
        // 角に丸みをつける.
        myTextView.layer.masksToBounds = true
        
        // 丸みのサイズを設定する.
        myTextView.layer.cornerRadius = 20.0
        
        // 枠線の太さを設定する.
        myTextView.layer.borderWidth = 1
        
        // 枠線の色を黒に設定する.
        myTextView.layer.borderColor = UIColor.black.cgColor
        
        // フォントの設定をする.
        
        myTextView.font = UIFont.systemFont(ofSize: 20.0)
        
        // フォントの色の設定をする.
        myTextView.textColor = UIColor.black
        
        // 左詰めの設定をする.
        myTextView.textAlignment = NSTextAlignment.left
        
        // リンク、日付などを自動的に検出してリンクに変換する.
        myTextView.dataDetectorTypes = UIDataDetectorTypes.all
        
        // 影の濃さを設定する.
        myTextView.layer.shadowOpacity = 0.5
        
        // テキストを編集不可にする.
        myTextView.isEditable = false
        
        // TextViewをViewに追加する.
        self.view.addSubview(myTextView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func tap(){
        print("hello")
        
        let memo = Memo()
        memo.text = myTextView.text
        
        StockMemos.postMemo(memo: memo)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
