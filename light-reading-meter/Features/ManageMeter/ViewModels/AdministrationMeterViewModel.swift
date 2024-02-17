//
//  ManageMeterViewModel.swift
//  light-reading-meter
//
//  Created by Oscar Rivera Moreira on 15/2/24.
//

import Foundation

class AdministrationMeterViewModel: ObservableObject {
    @Published var meter: Meter
    @Published var showMessage: Bool = false
    @Published var messageTitle: String = ""
    @Published var messageBody: String = ""
    @Published var isLoading: Bool = false
    @Published var isSuccess: Bool = false
    
    init() {
        self.meter = Meter(name: "", tag: "", currentReading: 0, desiredMonthlyKWH: 150, lastReadings: [])
    }
    
    init(meter: Meter) {
        self.meter = meter
    }
    
    func manageMeter() {
        guard self.meter.isValid else {
           print("Invalid meter data")
           self.messageTitle = NSLocalizedString("error", comment: "")
           self.messageBody =  self.meter.showModelErrors
           self.showMessage = true
           
           return
        }
        
        self.isLoading = true
        
        MeterService.shared.saveMeter(meter: self.meter) { success, message in
            DispatchQueue.main.async {
                self.isLoading = false
                self.showMessage = true
                self.messageBody = message ?? ""
                
                self.isLoading = false
                self.showMessage = true
                self.messageBody = message ?? ""
                self.messageTitle = success ? NSLocalizedString("success", comment: "") : NSLocalizedString("error", comment: "")
                self.isSuccess = success
                
                if success {
                    print("Error: \(message ?? "Unknown error")")
                }
            }
        }
    }
}
