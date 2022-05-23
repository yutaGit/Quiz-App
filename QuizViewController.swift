//
//  QuizViewController.swift
//  zatugaku_Quiz
//
//  Created by Ky on 2022/05/21.
//

import UIKit

class QuizViewController: UIViewController {
    @IBOutlet weak var quizNumberLabel: UILabel!
    @IBOutlet weak var quizTextView: UITextView!
    @IBOutlet weak var answerButton1: UIButton!
    @IBOutlet weak var answerButton2: UIButton!
    @IBOutlet weak var answerButton3: UIButton!
    @IBOutlet weak var answerButton4: UIButton!
    @IBOutlet weak var judgeImageview: UIImageView!
    
    var csvArray:[String] = []
    var quizArray:[String] = []
    var quizCount = 0
    var correctCount = 0

    override func viewDidLoad() {
        super.viewDidLoad()

//      読み込んだcsvファイルを配列に代入
        csvArray = loadCSV(fileName: "quiz")
        quizArray = csvArray[quizCount].components(separatedBy: ",")

//      オブジェクトに代入
        quizNumberLabel.text = "第\(quizCount + 1)問"
        quizTextView.text = quizArray[0]
        answerButton1.setTitle(quizArray[2], for: .normal)
        answerButton2.setTitle(quizArray[3], for: .normal)
        answerButton3.setTitle(quizArray[4], for: .normal)
        answerButton4.setTitle(quizArray[5], for: .normal)
        
        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let scoreVC = segue.destination as! ScoreViewController
        scoreVC.correct = correctCount
    }
    
//    正誤判定
    @IBAction func binAction(sender: UIButton){
        if sender.tag == Int(quizArray[1]){
            print("正解")
            correctCount += 1
            judgeImageview.image = UIImage(named: "correct")
        }else{
            print("不正解")
            judgeImageview.image = UIImage(named: "incorrect")
        }
        judgeImageview.isHidden = false
        answerButton1.isEnabled = false
        answerButton2.isEnabled = false
        answerButton3.isEnabled = false
        answerButton4.isEnabled = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
            self.answerButton1.isEnabled = true
            self.answerButton2.isEnabled = true
            self.answerButton3.isEnabled = true
            self.answerButton4.isEnabled = true
            self.judgeImageview.isHidden = true
            self.nextQuiz()
        }
    }
    
//    次の問題をセット
    func nextQuiz(){
        quizCount += 1

        if quizCount < csvArray.count{
//          次の問題がある場合
            quizArray = csvArray[quizCount].components(separatedBy: ",")
    //      オブジェクトに代入
            quizNumberLabel.text = "第\(quizCount + 1)問"
            quizTextView.text = quizArray[0]
            answerButton1.setTitle(quizArray[2], for: .normal)
            answerButton2.setTitle(quizArray[3], for: .normal)
            answerButton3.setTitle(quizArray[4], for: .normal)
            answerButton4.setTitle(quizArray[5], for: .normal)
        }else{
//          次の問題がない場合
            performSegue(withIdentifier: "toScoreVC", sender: nil)
        }
    }
    
//    CSVを読み込み配列に変換する
    func loadCSV(fileName: String) -> [String]{
        let csvBundle = Bundle.main.path(forResource: fileName, ofType: "csv")!
        do {
            let csvData = try String(contentsOfFile: csvBundle, encoding: String.Encoding.utf8)
            let lineCange = csvData.replacingOccurrences(of: "\r", with: "\n")
            csvArray = lineCange.components(separatedBy: "\n")
            csvArray.removeLast()
        }catch{
            print("エラー")
        }
        return csvArray
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
