//
//  PHAsset.swift
//  yopla
//
//  Created by 신성용 on 2021/11/15.
//

import Foundation
import Photos

extension PHAsset {

func getURL() -> Void{
    
    let options: PHVideoRequestOptions = PHVideoRequestOptions()
    options.version = .original
    PHImageManager.default().requestAVAsset(forVideo: self, options: options, resultHandler: {(asset: AVAsset?, audioMix: AVAudioMix?, info: [AnyHashable : Any]?) -> Void in
        if let urlAsset = asset as? AVURLAsset {
            let localVideoUrl: URL = urlAsset.url as URL
            Constant.videoUrls.append(localVideoUrl)
        } else {
//                completionHandler(nil)
        }
    })
    }
  }
