//
//  BannerCardView.swift
//  CheffDelivery
//
//  Created by Rafael Seron on 26/04/24.
//

import SwiftUI

//ImageItem Model
struct ImageItem: Identifiable{
    let id: Int
    let photo: String
}

// ImageItemList
let imageList: [ImageItem] = [ImageItem(id: 1, photo: "barbecue-banner"), ImageItem(id: 2, photo: "brazilian-meal-banner"),
                              ImageItem(id: 3, photo: "pokes-banner")]


struct BannerItem: View {
    let image: ImageItem
        var body: some View {
            Image(image.photo)
                .resizable()
                .scaledToFit()
                .clipShape(RoundedRectangle(cornerRadius: 3))
                }
    }

struct CarouselBanners: View {
    @State private var currentImage: Int = 1
    
    let bannerList: [ImageItem]
    
        var body: some View {
            TabView(selection: $currentImage) {
                ForEach(imageList){ image in
                    BannerItem(image: image)
                        .tag(image.id)
                }
            }.frame(height: 180)
                .tabViewStyle(.page(indexDisplayMode: .always))
                .onAppear{
                    Timer.scheduledTimer(withTimeInterval: 3, repeats: true) { Timer in
                        
                        if currentImage > imageList.count {
                            withAnimation(.easeInOut(duration: 0.5)){
                                currentImage = 1
                            }
                        } else {
                            withAnimation(.easeInOut(duration: 0.5)){
                                currentImage += 1
                            }
                        }
                    }
                }
    }
}

#Preview {
    CarouselBanners(bannerList: imageList)
}
