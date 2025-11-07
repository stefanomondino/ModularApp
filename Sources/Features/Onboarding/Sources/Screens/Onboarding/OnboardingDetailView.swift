//
//  OnboardingDetail.swift
//  Onboarding
//
//  Created by Renoy Chowdhury on 06/11/25.
//
import Components
import DesignSystem
import SwiftUI

public struct OnboardingDetailView: View {
    var item: OnboardingItem
    @Binding var next: Int
    let count: Int
    var reachEnd: (() -> Void)?
    
    var didActivateAction: (() -> Void)?
    
    @State private var didFirstTap = false
    
    public var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()
            VStack {
                Spacer()
                Image(systemName: item.image)
                Spacer()
                HStack {
                    ForEach(0..<count) { selectedOnb in
                        Circle()
                            .fill(selectedOnb == item.selectedPage ? Color.red : Color.gray)
                            .frame(width: 15)
                            .padding(.horizontal, 6)
                        
                    }
                }
                .padding(.vertical, 20)
                Text(item.title)
                    .font(.title)
                Text(item.subtitle)
                    .font(.title2)
                    .padding(.vertical, 20)
                Button {
                    withAnimation {
                        if !didFirstTap {
                            didActivateAction?()
                            didFirstTap = true
                        } else {
                            if item.selectedPage == count - 1 {
                                reachEnd?()
                            } else {
                                next += 1
                            }
                        }
                        
                    }
                } label: {
                    Text(item.buttonTitle)
                        .frame(height: 54)
                        .frame(maxWidth: .infinity)
                        .backgroundColor(Color.systemPink)
                        .cornerRadius(10)
                        .padding(.horizontal)
                }
                
            }
            .multilineTextAlignment(.center)
        }
    }
}
