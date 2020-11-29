//
//  BindingBool.swift
//  Recex
//
//  Created by Pulkith Paruchuri on 11/28/20.
//

import Foundation
import SwiftUI

prefix func ! (value: Binding<Bool>) -> Binding<Bool> {
    Binding<Bool>(
        get: { !value.wrappedValue },
        set: { value.wrappedValue = !$0 }
    )
}

//extension Binding where Value == String {
//    var not: Binding<Value> {
//        Binding<Value>(
//            get: { !self.wrappedValue },
//            set: { self.wrappedValue = !$0 }
//        )
//    }
//}

    func compare(_ value: Binding<String>, compareTo: String) -> Binding<Bool>{
        Binding<Bool>(
            get: { value.wrappedValue == compareTo },
            set: { _ in _ = value.wrappedValue == compareTo }
        )
    }
