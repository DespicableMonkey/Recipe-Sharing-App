//
//  ImagePickerView.swift
//  Recex
//
//  Created by Pulkith Paruchuri on 12/26/20.
//

import Foundation
import SwiftUI

struct ImagePickerView : UIViewControllerRepresentable {
    
    @Binding var isPresented : Bool
    @Binding var image : UIImage
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePickerView>) -> UIViewController{
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: ImagePickerView.UIViewControllerType, context: UIViewControllerRepresentableContext<ImagePickerView>) {
        
    }
    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }
    class Coordinator : NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        
        let parent : ImagePickerView
        init(parent : ImagePickerView) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let selectedImage = info[.originalImage] as? UIImage {
                self.parent.image = selectedImage
            }
            self.parent.isPresented = false
        }
        
    }
}
