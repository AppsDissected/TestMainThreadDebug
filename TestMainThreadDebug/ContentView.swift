//
//  ContentView.swift
//  TestMainThreadDebug
//
//  Created by Evan Deaubl on 7/29/19.
//  Copyright © 2019 Evan Deaubl. All rights reserved.
//

import SwiftUI
import Combine

struct ContentView: View {
    @ObjectBinding var viewModel = ContentViewModel()
    
    var body: some View {
        VStack {
            Button(action: {self.viewModel.calculateResult()}) {
                Text("Calculate Result")
            }
            Text(viewModel.result)
        }
    }
}

class ContentViewModel: BindableObject {
    var result: String = "" {
        willSet {
            willChange.send()
        }
    }
    var willChange = PassthroughSubject<Void, Never>()
    var calculate = PassthroughSubject<String, Never>()
    
    init() {
        calculate.delay(for: 1.0, scheduler: DispatchQueue.global(qos: .background)).sink(receiveValue: { value in self.result = value })
        //calculate.delay(for: 1.0, scheduler: DispatchQueue.global(qos: .background)).receive(on: RunLoop.main).sink(receiveValue: { value in self.result = value })
    }

    func calculateResult() {
        calculate.send("The result is: 5")
    }
}

#if DEBUG
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif
