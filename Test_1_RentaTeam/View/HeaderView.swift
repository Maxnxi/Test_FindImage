//
//  HeaderView.swift
//  Test_1_RentaTeam
//
//  Created by Maksim Ponomarev on 19.11.2021.
//

import UIKit

class HeaderView: UICollectionViewCell {
    
    static let reuseIdentifier = "HeaderView"
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    func configureView() {
        searchBar.tintColor = UIColor.white
        let placeHolderAttributes = NSAttributedString(string: "place text here to find photos of kind ...", attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray,
                                                                                                                          NSAttributedString.Key.strikethroughColor : UIColor.white,
                                                                                                                          NSAttributedString.Key.underlineColor: UIColor.red,
                                                                                                                          NSAttributedString.Key.strokeColor: UIColor.red])
        searchBar.searchTextField.attributedPlaceholder = placeHolderAttributes
        searchBar.tintColor = UIColor.white
        searchBar.searchTextField.textColor = UIColor.white
        searchBar.searchTextField.autocapitalizationType = .none
        //searchBar.enablesReturnKeyAutomatically = true
        searchBar.barTintColor = UIColor.white
        searchBar.autocorrectionType = .no
        searchBar.searchTextField.addCancelButtonOnKeyboard()
    }
}
