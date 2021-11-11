//
//  DetailVC.swift
//  Test_1_RentaTeam
//
//  Created by Maksim Ponomarev on 11.11.2021.
//

import UIKit

class DetailVC: UIViewController {

    static let reuseIdentifierOfVC = "detailVC"
    
    var cellViewModel: CellViewModel?
    
    @IBOutlet weak var downloadTimeLabel: UILabel!
    @IBOutlet weak var photographerNamelabel: UILabel!
    @IBOutlet weak var photoIdLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var baseView: UIView!
    @IBOutlet var backgroundView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        setDataInfo()
    }
    
    func configureUI() {
        baseView.layer.cornerRadius = 20
        baseView.layer.shadowRadius = 20
        baseView.layer.shadowColor = UIColor.black.cgColor
    }
    
    func setDataInfo() {
        guard let vm = cellViewModel else { return }
        imageView.image = vm.image
        photoIdLabel.text = vm.id
        photographerNamelabel.text = vm.photoGrapherName
        
        guard let secondsInt = Int(vm.downloadDate) else { return }
        let epocTime = TimeInterval(secondsInt)
        let myDate = Date(timeIntervalSince1970: epocTime)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm:SS"
        var convertedTime = dateFormatter.string(from: myDate)
        downloadTimeLabel.text = String("\(convertedTime)")
    }
    

    @IBAction func backButtonWasPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    

}


