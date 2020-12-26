//
//  CustomMultilineTextField.swift
//  Recex
//
//  Created by Pulkith Paruchuri on 12/26/20.
//

import Foundation
import SwiftUI

struct CustomMultilineTF : UIViewRepresentable {
    
    @Binding var text : String
    @Binding var height: CGFloat
    var placeholder : String
    
    func makeCoordinator() -> Coordinator {
        return CustomMultilineTF.Coordinator(par: self)
    }
    
    func makeUIView(context: Context) -> UITextView {
        let view = UITextView()
        view.isEditable = true
        view.isScrollEnabled = true
        view.text = placeholder
        view.font = .systemFont(ofSize: 18)
        view.textColor = .gray
        view.delegate = context.coordinator
        view.backgroundColor = UIColor.gray.withAlphaComponent(0.05)
        return view
    }
    func updateUIView(_ uiView: UITextView, context: Context) {
        DispatchQueue.main.async {
            self.height = uiView.contentSize.height
        }
    }
    class Coordinator : NSObject, UITextViewDelegate {
        var parent : CustomMultilineTF
        init(par : CustomMultilineTF) {
            parent = par
        }
        
        func textViewDidBeginEditing(_ textView: UITextView) {
            if self.parent.text == "" {
                textView.text = ""
                textView.textColor = .black
            }
        }
        func textViewDidChange(_ textView: UITextView) {
            DispatchQueue.main.async {
                self.parent.height = textView.contentSize.height
                self.parent.text = textView.text
            }
        }
    }
}
