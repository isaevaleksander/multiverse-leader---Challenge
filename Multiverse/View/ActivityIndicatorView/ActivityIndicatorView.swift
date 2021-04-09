//
//  ActivityIndicatorView.swift
//  Multiverse
//
//  Created by Alex Isaev on 09.04.2021.
//

import SwiftUI

struct ActivityIndicatorView: UIViewRepresentable {
    
    @Binding var isAnimating: Bool
    
    func makeUIView(context: Context) -> UIActivityIndicatorView {
        return UIActivityIndicatorView()
    }
    
    func updateUIView(_ uiView: UIActivityIndicatorView, context: Context) {
        isAnimating == true ? uiView.startAnimating() : uiView.stopAnimating()
    }
}
