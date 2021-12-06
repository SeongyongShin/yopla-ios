//
//  RegistDetailCell1.swift
//  yopla
//
//  Created by 신성용 on 2021/11/15.
//

import UIKit
import Photos
import MapKit

class RegistDetailCell1: UICollectionViewCell {
    
    let bcf = ByteCountFormatter()
    
    var videoCount = 0
    var contentType = "video"
    var currentDetailPage = 0
    @IBOutlet weak var thumnailV: UIView!
    @IBOutlet weak var thumNailLabel: UILabel!
    @IBOutlet weak var thumbNailIV: UIImageView!
    let imageManager: PHCachingImageManager = PHCachingImageManager()
    var fetchResult: PHFetchResult<PHAsset>?
    var delegate: RegistRecipeDetailCellDelegate?
    var delegate2: RegistCellDelegate?
    var documentDirectory: String?
    var videoDirectory: URL?
    lazy var awsDataManager: AWSDataManager = AWSDataManager()
    
    @IBOutlet weak var myGalleryCV: UICollectionView!
    override func awakeFromNib() {
        super.awakeFromNib()
        Constant.videoUrls.removeAll()
        
        requestPhotosPermission()
        myGalleryCV.register(UINib(nibName: "RegistRecipeImageCell", bundle: nil), forCellWithReuseIdentifier: "RegistRecipeImageCell")
        myGalleryCV.register(UINib(nibName: "RegistRecipeVideoCell", bundle: nil), forCellWithReuseIdentifier: "RegistRecipeVideoCell")
        myGalleryCV.dataSource = self
        myGalleryCV.delegate = self
        requestPhotosPermission()
//        checkCameraPermission()
        documentDirectory = NSSearchPathForDirectoriesInDomains(.picturesDirectory, .userDomainMask, true).first
    }

}

extension RegistDetailCell1: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let counts = self.fetchResult?.count ?? 0
        if counts >= 100{
            return 100
        }else{
            return counts
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let asset: PHAsset = self.fetchResult?.object(at: indexPath.row) else {
            return UICollectionViewCell()
        }
        if asset.mediaType.rawValue == 1{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RegistRecipeImageCell", for: indexPath) as! RegistRecipeImageCell
            imageManager.requestImage(for: asset, targetSize: CGSize(width: cell.frame.width, height: cell.frame.height), contentMode: .aspectFill, options: nil) {
                image, _ in
                cell.myImage?.image = image
            }
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RegistRecipeVideoCell", for: indexPath) as! RegistRecipeVideoCell
            imageManager.requestImage(for: asset, targetSize: CGSize(width: cell.frame.width, height: cell.frame.height), contentMode: .aspectFill, options: nil) {
                image, _ in
                cell.myImage?.image = image
            }
            asset.getURL()
            cell.tag = videoCount + 1
            videoCount += 1
            cell.fileSize = Float(getSize(asset: asset).split(separator: " ")[0])
            return cell
        }

    }
    // 셀 크기 화면 꽉차게
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width/3 , height: collectionView.frame.height/2.5)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        var tempurl: URL? = nil
        if let tags = collectionView.cellForItem(at: indexPath)?.tag{
            if tags > 0{
                
                self.contentType = "video"
                let cell = collectionView.cellForItem(at: indexPath) as! RegistRecipeVideoCell
                if cell.fileSize! > 10.0{
                    delegate2?.presentAlertMessage(msg: "10MB 이하만 등록 가능합니다.\n \(String(describing: cell.fileSize!))MB / 10MB")
                    return
                }
                tempurl = Constant.videoUrls[tags-1]
                videoDirectory = tempurl
            }else{
                self.contentType = "image"
            }
        }
        
        guard let asset: PHAsset = self.fetchResult?.object(at: indexPath.row) else {
            return
        }
        
        
        imageManager.requestImage(for: asset, targetSize: CGSize(width: thumbNailIV.frame.width, height: thumbNailIV.frame.height), contentMode: .aspectFill, options: nil) {
            image, _ in
            self.thumbNailIV.image = image
            self.thumbNailIV.alpha = 1
            self.delegate?.setimageInfo(image: image!)
            self.delegate?.setTempDetail(title: nil, content: nil,fileType: self.contentType, ingredient: nil, image: image, videoURL: self.videoDirectory)
            DispatchQueue.global().async {
                Thread.sleep(forTimeInterval: 0.3)
                self.delegate2?.didSelectedImage()
            }
        }
    }
    
}


//MARK: 사진 바로 띄우기 허가
extension RegistDetailCell1{
    private func requestPhotosPermission() {
            let photoAuthorizationStatusStatus = PHPhotoLibrary.authorizationStatus()

            switch photoAuthorizationStatusStatus {
            case .authorized:
                print("Photo Authorization status is authorized.")
                self.requestCollection()

            case .denied:
                print("Photo Authorization status is denied.")

            case .notDetermined:
                print("Photo Authorization status is not determined.")
                PHPhotoLibrary.requestAuthorization() {
                    (status) in
                    switch status {
                    case .authorized:
                        print("User permiited.")
                        self.requestCollection()
                    case .denied:
                        print("User denied.")
                        break
                    default:
                        break
                    }
                }

            case .restricted:
                print("Photo Authorization status is restricted.")
            default:
                break
            }
        }
    private func requestCollection() {
            let cameraRoll: PHFetchResult<PHAssetCollection> = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .smartAlbumUserLibrary, options: nil)

            guard let cameraRollCollection = cameraRoll.firstObject else {
                return
            }

            let fetchOption = PHFetchOptions()
            fetchOption.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
            self.fetchResult = PHAsset.fetchAssets(in: cameraRollCollection, options: fetchOption)
        
            OperationQueue.main.addOperation {
                Constant.videoUrls.removeAll()
                self.videoCount = 0
                self.myGalleryCV.reloadData()
            }
        
        }
    func checkCameraPermission(){
       AVCaptureDevice.requestAccess(for: .video, completionHandler: { (granted: Bool) in
           if granted {
               print("Camera: 권한 허용")
           } else {
               print("Camera: 권한 거부")
           }
       })
    }
}
extension RegistDetailCell1{
    func clear(){
        self.thumbNailIV.image = UIImage()
        self.thumNailLabel.isHidden = false
    }
    func getSize(asset: PHAsset) -> String {
        let resources = PHAssetResource.assetResources(for: asset)

        guard let resource = resources.first,
              let unsignedInt64 = resource.value(forKey: "fileSize") as? CLong else {
                  return "Unknown"
              }

        let sizeOnDisk = Int64(bitPattern: UInt64(unsignedInt64))
        self.bcf.allowedUnits = [.useMB]
        self.bcf.countStyle = .file
        return self.bcf.string(fromByteCount: sizeOnDisk)
    }

}
