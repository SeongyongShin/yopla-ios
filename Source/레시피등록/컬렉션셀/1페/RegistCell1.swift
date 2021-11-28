//
//  RegistCell1.swift
//  yopla
//
//  Created by 신성용 on 2021/11/11.
//

import UIKit
import Photos

class RegistCell1: UICollectionViewCell {

    @IBOutlet weak var thumbNailIV: UIImageView!
    @IBOutlet weak var myGalleryCV: UICollectionView!
    let imageManager: PHCachingImageManager = PHCachingImageManager()
    var fetchResult: PHFetchResult<PHAsset>?
    var delegate : CellDelegate?
    var delegate2: RegistCellDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        myGalleryCV.register(UINib(nibName: "RegistCell1_1", bundle: nil), forCellWithReuseIdentifier: "RegistCell1_1")
        myGalleryCV.dataSource = self
        myGalleryCV.delegate = self
        requestPhotosPermission()
        checkCameraPermission()
    }

}

extension RegistCell1: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RegistCell1_1", for: indexPath) as! RegistCell1_1
        
        guard let asset: PHAsset = self.fetchResult?.object(at: indexPath.row) else {
            return cell
        }
        imageManager.requestImage(for: asset, targetSize: CGSize(width: cell.frame.width, height: cell.frame.height), contentMode: .aspectFill, options: nil) {
            image, _ in
            cell.myImage?.image = image
        }
        return cell
    }
    // 셀 크기 화면 꽉차게
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width/3 , height: collectionView.frame.height/2.5)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let asset: PHAsset = self.fetchResult?.object(at: indexPath.row) else {
            return
        }
        imageManager.requestImage(for: asset, targetSize: CGSize(width: thumbNailIV.frame.width, height: thumbNailIV.frame.height), contentMode: .aspectFill, options: nil) {
            image, _ in
            self.thumbNailIV.image = image
            self.thumbNailIV.alpha = 1
            self.delegate?.setimageInfo(image: image!)
            DispatchQueue.global().async {
                Thread.sleep(forTimeInterval: 0.3)
                self.delegate2?.didSelectedImage()
            }
        }
        
    }
    
}


//MARK: 사진 바로 띄우기 허가
extension RegistCell1{
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
