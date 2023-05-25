//
//  PhotosPicker.swift
//  The.5.am
//
//  Created by Кирилл Юрушкин on 13.05.2023.
//

import Foundation
import PhotosUI
import _PhotosUI_SwiftUI



class Photos : ObservableObject {
    @Published var selectedItems = [PhotosPickerItem]()
    @Published var selectedPhotoData = [Data?]()
}
