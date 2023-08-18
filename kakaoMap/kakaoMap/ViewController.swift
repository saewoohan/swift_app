//
//  ViewController.swift
//  kakaoMap
//
//  Created by 한승우 on 2023/03/01.
//

import UIKit
#import <DaumMap/MTMapView.h>

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
            _mapView = [[MTMapView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
            _mapView.delegate = self;
            _mapView.baseMapType = MTMapTypeHybrid;
            [self.view addSubview:_mapView];
    }


}

