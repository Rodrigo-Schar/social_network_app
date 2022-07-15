//
//  ImagePickerHelperViewController.swift
//  social_network_app
//
//  Created by admin on 7/12/22.
//

import UIKit
import Photos

class ImagePickerHelperViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func showAddImageOptionAlert() {
        
        DispatchQueue.main.async {
            
            
            let sheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            
            sheet.addAction(UIAlertAction(title: "Photo Library", style: .default) { _ in
                // show image library of the device
                self.showDeviceImageLibrary()
            })
            
            sheet.addAction(UIAlertAction(title: "Camera", style: .default) { _ in
                // show image library of the device
                self.didTapCamera()
            })
            
            sheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            
            self.navigationController?.present(sheet, animated: true, completion: nil)
            
        }
        
    }
    
    // MARK: - DEVICE IMAGES
    func showDeviceImageLibrary() {
        let status = PHPhotoLibrary.authorizationStatus()
        
        DispatchQueue.main.async {
            switch status {
            case .notDetermined:
                self.requestAccess()
            case .restricted:
                self.presentErrorAlert(title: "Error", message: "Permissin is needed. Please add the permission from settings.")
            case .denied:
                self.presentErrorAlert(title: "Error", message: "Permissin is needed. Please add the permission from settings.")
            case .authorized, .limited:
                self.presentDeviceImageViewController()
            @unknown default:
                break
            }
        }
        

        
    }
    
    func requestAccess() {
        PHPhotoLibrary.requestAuthorization { status in
            self.showDeviceImageLibrary()
        }
    }
    
    func presentDeviceImageViewController() {
        let vc = DeviceImageLibraryViewController()
        vc.delegate = self
        navigationController?.present(vc, animated: true, completion: nil)
    }
    
    
    // MARK: - CAMERA
    func didTapCamera() {
        
        let auth = AVCaptureDevice.authorizationStatus(for: .video)
        
        switch auth {
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                DispatchQueue.main.async {
                    if granted {
                        self.presentCamera()
                    } else {
                        self.presentErrorAlert(title: "Error", message: "Camera permission is needed. Please add the permission from settings.")
                    }
                }

            }
            
        case .restricted, .denied:
            self.presentErrorAlert(title: "Error", message: "Camera permission is needed. Please Add the permission from settings.")
        case .authorized:
            self.presentCamera()
        @unknown default:
            return
        }
 
    }
    
    func presentCamera() {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else { return }
        
        let cameraVC = UIImagePickerController()
        cameraVC.delegate = self
        cameraVC.sourceType = .camera
        cameraVC.cameraDevice = .rear
        
        navigationController?.present(cameraVC, animated: true)
        
    }
    
    private func presentErrorAlert(title: String, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Go settings", style: .default, handler:  { action in
            
            guard let settingsURL = URL(string: UIApplication.openSettingsURLString) else { return }
            UIApplication.shared.open(settingsURL)

                
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        
        present(alert, animated: true, completion: nil)
        
    }
    
    func showAddImageConfirmation(withName: String, withExtension: String, data: Data) {
        let alert = UIAlertController(title: "Save Image", message: "Image name: \(withName)", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Save", style: .default, handler: { action in
            self.saveSelectedImageInFirebase(withExtension: withExtension, data: data)
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        
        present(alert, animated: true, completion: nil)
    }
    
    // OVERRIDE THIS FUNCTION
    func saveSelectedImageInFirebase(withExtension: String, data: Data) {
        print("Save image")
    }

}


// CAMERA DELEGATES
extension ImagePickerHelperViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let formater = DateFormatter()
        formater.dateFormat = "MMM_d_yyyy"
        formater.locale = Locale(identifier: Locale.current.identifier)
        let dateStr = formater.string(from: Date())
        
        print("h")
        let name = "Photo_\(dateStr)"
        
        if let image = info[.originalImage] as? UIImage,
           let data = image.jpegData(compressionQuality: 0.5) {
            
            picker.dismiss(animated: true) {
                
                self.showAddImageConfirmation(withName: name, withExtension: "jpg", data: data)
            }
            
        }
        
        
    }
    
}

// DEVICE DELEGATES
extension ImagePickerHelperViewController: DeviceImageLibraryViewControllerDelegate {
    
    func onDevicePhotoSelected(selectedAsset: PHAsset) {
        let formater = DateFormatter()
        formater.dateFormat = "MMM_d_yyyy"
        formater.locale = Locale(identifier: Locale.current.identifier)
        let dateStr = formater.string(from: Date())
        
        let name = "Image_\(dateStr)"
        
        
        selectedAsset.image(isSynchronous: true) { image in
            if let data = image?.jpegData(compressionQuality: 0.5) {
                self.showAddImageConfirmation(withName: name, withExtension: "jpg", data: data)
            }
        }
    }
    
    
}
