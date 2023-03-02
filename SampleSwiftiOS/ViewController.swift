//
//  ViewController.swift
//  SampleSwiftiOS
//
//  Created by Pallab Maiti on 24/01/23.
//

import UIKit
import OTPublishersHeadlessSDK
import Rudder

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        OTPublishersHeadlessSDK.shared.setupUI(self, UIType: .preferenceCenter)
    }

    @IBAction func onTrack(_ sender: UIButton) {
        RSClient.sharedInstance()?.track("Test OneTrust Track_Braze_Disabled")
    }
}

