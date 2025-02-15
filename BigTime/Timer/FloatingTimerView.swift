//
//  FloatingTimerView.swift
//  BigTime
//
//  Created by ash on 2/15/25.
//


import SwiftUI
import Luminare

struct FloatingTimerView: View {
    @ObservedObject var timerViewModel: TimerViewModel
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(timerViewModel.currentTask.isEmpty ? "Unlabeled Session" : timerViewModel.currentTask)
                    .lineLimit(1)
                
                Text(timerViewModel.formattedTime)
                    .font(.system(size: 18, design: .monospaced))
            }
            Spacer()
            
            Button(action: timerViewModel.toggleTimer) {
                Label("doneLabel", systemImage: "checkmark")
            }
            .frame(width: 100, height: 40)
        }
        .buttonStyle(LuminareCompactButtonStyle())
        .padding(10)
        .frame(width: 300, alignment: .leading)
        .background(VisualEffectView(material: .hudWindow, blendingMode: .behindWindow))
        .overlay(RoundedRectangle(cornerRadius: 18).stroke(.tertiary, lineWidth: 1))
        .mask(RoundedRectangle(cornerRadius: 18))
    }
}

class FloatingTimerController: ObservableObject {
    private var window: FloatingTimerWindow?
    private var hostingView: NSHostingView<FloatingTimerView>?
    
    func showFloatingTimer(with timerViewModel: TimerViewModel) {
        if window == nil {
            window = FloatingTimerWindow()
            let floatingView = FloatingTimerView(timerViewModel: timerViewModel)
            hostingView = NSHostingView(rootView: floatingView)
            window?.contentView = hostingView
            window?.makeKeyAndOrderFront(nil)
        }
    }
    
    func hideFloatingTimer() {
        window?.close()
        window = nil
        hostingView = nil
    }
}
