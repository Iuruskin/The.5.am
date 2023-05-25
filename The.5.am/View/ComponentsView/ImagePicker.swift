//
//  ImagePicker.swift
//  The.5.am
//
//  Created by Кирилл Юрушкин on 12.04.2023.
//

//import Foundation
//import SwiftUI
//
//struct ImagePicker: UIViewControllerRepresentable {
//    
//    @Environment (\.dismiss) private var dismiss
//    
//    var sourceType: UIImagePickerController.SourceType = .photoLibrary
//    @Binding var selectedImage: UIImage
//    
//    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) ->  UIImagePickerController {
//        let imagePicker = UIImagePickerController()
//        imagePicker.sourceType = sourceType
//        imagePicker.delegate = context.coordinator
//        return imagePicker
//    }
//    
//    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
//        
//    }
//    
//    func makeCoordinator() -> Coordinator {
//        Coordinator(self)
//    }
//    final class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
//        var parent: ImagePicker
//        
//        init(_ parent: ImagePicker) {
//            self.parent = parent
//        }
//        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//            if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
//                parent.selectedImage = image
//            }
//            
//            parent.dismiss.callAsFunction()
//        }
//    }
//    
//    
//}
//
