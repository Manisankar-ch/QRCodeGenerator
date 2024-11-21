//
//  ContentView.swift
//  QRCodeGenerator
//
//  Created by Mani Sankar on 05/11/24.
//

import SwiftUI
import CoreImage
import CoreImage.CIFilterBuiltins

struct QRGenerator: View {
    
    @State private var text = ""
    @State private var imageData: Data?
    
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    TextField("Enter code", text: $text)
                        .textFieldStyle(.roundedBorder)
                        .padding()
                    Button(action:   {
                        
                        if !text.trimmingCharacters(in: .whitespaces).isEmpty {
                            imageData = generateQR(text: text)
                        }
                    }) {
                        Text("Generate QR")
                            .padding(.horizontal, 20)
                            .padding(.vertical, 2)
                            .foregroundColor(text.trimmingCharacters(in: .whitespaces).isEmpty ? .black : .white)
                            .background(text.trimmingCharacters(in: .whitespaces).isEmpty ? .gray : .blue)
                    }
                    .disabled(text.trimmingCharacters(in: .whitespaces).isEmpty)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    
                    
                }
                .padding(.horizontal, 20)
                if let imageData, let uiImage = UIImage(data: imageData) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .frame(width: 200, height: 200)
                } else {
                    Text("Enter text to generate image")
                }
                
            }
        }
    }
    
    func generateQR(text: String) -> Data? {
        let filter = CIFilter.qrCodeGenerator()
        guard let data = text.data(using: .ascii, allowLossyConversion: false) else { return nil }
        filter.message = data
        guard let ciimage = filter.outputImage else { return nil }
        let transform = CGAffineTransform(scaleX: 10, y: 10)
        let scaledCIImage = ciimage.transformed(by: transform)
        let uiimage = UIImage(ciImage: scaledCIImage)
        return uiimage.pngData()!
    }
}

#Preview {
    QRGenerator()
}
