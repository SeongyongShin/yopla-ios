//
//  AWSDataManager.swift
//  yopla
//
//  Created by 신성용 on 2021/11/14.
//
import UIKit
import Alamofire
import PromiseKit
import AWSS3
import AWSCore

class AWSDataManager{
    
    typealias progressBlock = (_ progress: Double) -> Void //2
    typealias completionBlock = (_ response: Any?, _ error: Error?) -> Void //3
    let bucketName = "yopladatastorage"
    var contentUrl: URL!
    var s3Url: URL!
    func uploadImage(image: UIImage)->Promise<URL>{
        return Promise{resolver in
            
            let progressBlock: AWSS3TransferUtilityProgressBlock = {
                task, progress in print("image uploaded", progress.fractionCompleted)
            }
            
            let name = ProcessInfo.processInfo.globallyUniqueString+".jpg"
            let transferUtility = AWSS3TransferUtility.default()
            let imageData = image.jpegData(compressionQuality: 0.5)!
            let expression = AWSS3TransferUtilityUploadExpression()
            expression.progressBlock = progressBlock
            
            transferUtility.uploadData(imageData, bucket: self.bucketName, key: name, contentType: "image/jpeg", expression: expression, completionHandler: {task, error in
                if let error = error{
                    resolver.reject(error)
                }else{
                    let imageUrl = URL(string: "https://yopladatastorage.s3.ap-northeast-2.amazonaws.com/\(name)")
                    resolver.fulfill(imageUrl!)
                }
            })
            
        }
    }
//    @available(iOS, deprecated: 13.0)
    func uploadVideo(with resource: URL)->Promise<URL> {
        let credentialsProvider = AWSCognitoCredentialsProvider(regionType:.APNortheast2,
                                                                identityPoolId:"ap-northeast-2:666ae0e2-ad51-4e40-b734-74eecf0b0a98c")
        
        let configuration = AWSServiceConfiguration(region:.APNortheast2, credentialsProvider:credentialsProvider)
        
        AWSServiceManager.default().defaultServiceConfiguration = configuration
        s3Url = AWSS3.default().configuration.endpoint.url
        let key = "\(UUID().uuidString)\(resource)"
            let localImageUrl = resource
            let request = AWSS3TransferManagerUploadRequest()!
            request.bucket = self.bucketName
            request.key = key
            request.body = localImageUrl
            request.acl = .publicReadWrite
            
            let transferManager = AWSS3TransferManager.default()
        return Promise{resolver in
            transferManager.upload(request).continueWith(executor: AWSExecutor.mainThread()) { (task) -> Any? in
                if let error = task.error {
                    print(error)
                    resolver.reject(error)
                }
                if task.result != nil {
                    
                    let contentUrl = self.s3Url.appendingPathComponent(self.bucketName).appendingPathComponent(key)
                    self.contentUrl = contentUrl
                    resolver.fulfill(contentUrl)
                }
                
                return nil
            }
        }

        
        }
}
