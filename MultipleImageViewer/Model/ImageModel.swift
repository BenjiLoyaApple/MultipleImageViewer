//
//  ImageModel.swift
//  MultipleImageViewer
//
//  Created by Benji Loya on 22.12.2024.
//

import SwiftUI

struct ImageModel: Identifiable {
    var id: String = UUID().uuidString
    var altText: String
    // going to use Live URL via AsyncImage foe this effect
    var link: String
}

let sampleImages: [ImageModel] = [
    .init(altText: "Mo Eid", link: "https://w0.peakpx.com/wallpaper/944/975/HD-wallpaper-building-city-new-york-skyscraper-sunset-usa-travel.jpg"),
    .init(altText: "Codioful", link: "https://p4.wallpaperbetter.com/wallpaper/710/382/540/new-york-city-cityscape-united-states-skyline-wallpaper-preview.jpg"),
    .init(altText: "Fanny Hagan", link: "https://i.pinimg.com/736x/01/b3/8d/01b38d4f2730bc20d3744057d9f30f51.jpg"),
    .init(altText: "Mo Eid", link: "https://avatars.mds.yandex.net/i?id=97a3e2c73f8f71646917f5f2f51ff644_l-7045468-images-thumbs&n=13"),
    .init(altText: "Codioful", link: "https://i.pinimg.com/736x/19/e9/03/19e90312a1b6cb8103ac8a1f47b75056.jpg"),
    .init(altText: "Fanny Hagan", link: "https://www.google.com"),
    .init(altText: "Mo Eid", link: "https://i.pinimg.com/550x/8e/f3/b3/8ef3b3df1c2df6588a0eb73d352fea13.jpg"),
    .init(altText: "Codioful", link: "https://ae01.alicdn.com/kf/HTB15ZShKpXXXXcdXVXXq6xXFXXXm/2-5-W-x4-5-H-m-Crowded-Busy-City-Street-Background-Hot-Selling-Freedom-Photography.jpg")
]
