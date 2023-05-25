//
//  TabViewModel.swift
//  The.5.am
//
//  Created by Кирилл Юрушкин on 30.03.2023.
//

import Foundation

struct TabItemModel {
    var image : String
    var selectedImage : String {
        image + ".selected"
    }
    var title : String
}
