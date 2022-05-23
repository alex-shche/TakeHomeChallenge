//
//  FilterItem.swift
//  TechChallenge
//
//  Created by Alexander Shchegryaev on 17/05/2022.
//

import Foundation
import SwiftUI

struct FilterItem {
    let id: String
    let text: String
    let color: Color
    let onTap: () -> Void
}

extension FilterItem: Identifiable {}
