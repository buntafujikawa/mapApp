//
//  ViewController.swift
//  mapApp
//
//  Created by 藤川 文汰 on 2017/03/07.
//  Copyright © 2017年 藤川 文汰. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController {

    @IBOutlet var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 中心座標 日本
        let center = CLLocationCoordinate2DMake(35.690553, 139.699579)
        
        // 表示範囲
        let span = MKCoordinateSpanMake(0.001, 0.001)
        
        // 中心座標と表示範囲をマップに登録する
        MKCoordinateRegionMake(center, span)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
