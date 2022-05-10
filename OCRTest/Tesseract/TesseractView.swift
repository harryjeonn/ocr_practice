//
//  TesseractView.swift
//  OCRTest
//
//  Created by Harry on 2022/05/09.
//

import SwiftUI

struct TesseractView: View {
    @ObservedObject private var viewModel: TesseractViewModel
    
    init() {
        self.viewModel = TesseractViewModel()
    }
    
    var body: some View {
        VStack {
            Spacer()
            TesseractCameraView(viewModel: viewModel)
                .onAppear {
                    viewModel.session.startRunning()
                }
                .onDisappear {
                    viewModel.session.stopRunning()
                }
            Spacer()
            
            Text(viewModel.result)
            Spacer()
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
        .edgesIgnoringSafeArea(.all)
    }
}

struct TesseractView_Previews: PreviewProvider {
    static var previews: some View {
        TesseractView()
    }
}
