//
//  ProfilesView.swift
//  AudioCaptureandPlaybackwithProfiles
//
//  Created by Dayton Steffeny on 10/11/19.
//  Copyright © 2019 Dayton Steffeny. All rights reserved.
//

import Foundation

struct profile{
    let title: String
    let body: [String : Any]
    let filename: String
    
    init(title: String, body: [String : Any], filename: String){
        self.title = title
        self.body = body
        self.filename = filename
    }
}
