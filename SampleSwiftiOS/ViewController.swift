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
        let option = RSOption()
        option.putIntegration("Firebase", isEnabled: false)
        option.putIntegration("Adjust", isEnabled: true)
        RSClient.sharedInstance()?.track("Test Track", properties: [:], options: option)
    }
}
