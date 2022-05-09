//
//  ContentView.swift
//  OCRTest
//
//  Created by Harry on 2022/05/09.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            VStack {
                NavigationLink(destination: TesseractView(), label: {
                    Text("Tesseract")
                        .padding()
                })
                
                NavigationLink(destination: GoogleMLKitView(), label: {
                    Text("GoogleMLKit")
                        .padding()
                })
                
                NavigationLink(destination: SwiftOCRView(), label: {
                    Text("SwiftOCR")
                        .padding()
                })
                
                NavigationLink(destination: NativeView(), label: {
                    Text("Native")
                        .padding()
                })
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
