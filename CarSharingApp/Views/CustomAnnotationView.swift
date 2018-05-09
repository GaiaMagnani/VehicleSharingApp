//
//  CustomAnnotationView.swift
//  CarSharingApp
//
//  Created by gaia.magnani on 07/05/18.
//  Copyright © 2018 gaia.magnani. All rights reserved.
//

import UIKit


class CustomAnnotationView: UIView {
    @IBOutlet weak var modelLabel: UILabel!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var fuelLabel: UILabel!
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var address: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBAction func prenotaAction(_ sender: Any) {
        let alert = UIAlertController(title: "Conferma", message: "La tua prenotazione è avvenuta con successo", preferredStyle: .alert)
        
        let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
            print("Ok button tapped")
        })
        alert.addAction(ok)
        
        self.window?.rootViewController?.present(alert, animated: true, completion: nil)
    }

    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if let result = button.hitTest(convert(point, to: button), with: event) {
            return result
        }
        return nil
    }
}
