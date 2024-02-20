//
//  ReadingViewModel.swift
//  meter-logger
//
//  Created by Oscar Rivera Moreira on 17/2/24.
//

import Foundation

class ManageReadingViewModel: ObservableObject {
    @Published var reading: Reading
    @Published var showMessage: Bool = false
    @Published var messageTitle: String = ""
    @Published var messageBody: String = ""
    @Published var isLoading: Bool = false
    @Published var isSuccess: Bool = false
    @Published var isSuccessDeleted: Bool = false

    // New Record
    init(meterId: UUID) {
        self.reading = Reading()
    }

    // Previous Record
    init(reading: Reading) {
        self.reading = reading
    }

    func manageReading(isNewRecord: Bool) {
        if isNewRecord {
            saveNewReading()
        }
        else {
            updateReading()
        }
    }

    func saveNewReading() {
        guard reading.isValid else {
            print("Invalid reading data")
            showMessage(isSuccessMessage: false, body: reading.showModelErrors)

            return
        }

        self.isLoading = true

        ReadingService.shared.saveReading(reading: reading) { success, message in
            DispatchQueue.main.async {
                self.isLoading = false
                self.isSuccess = success

                self.showMessage(isSuccessMessage: success, body: message ?? "")

                if !success {
                    print("Error: \(message ?? "Unknown error")")
                }
            }
       }
    }

    func updateReading() {
        guard self.reading.isValid else {
            print("Invalid reading data")
            self.showMessage(isSuccessMessage: false, body: self.reading.showModelErrors)

            return
        }

        self.isLoading = true

        ReadingService.shared.updateReading(reading: reading) { success, message in
            DispatchQueue.main.async {
                self.isLoading = false
                self.isSuccess = success

                self.showMessage(isSuccessMessage: success, body: message ?? "")

                if !success {
                    print("Error: \(message ?? "Unknown error")")
                }
            }
       }
    }

    func deleteMeter() {
        ReadingService.shared.deleteReading(id: self.reading.id) { [weak self] success, message in
            DispatchQueue.main.async {
                self?.isLoading = false
                self?.isSuccessDeleted = success

                self?.showMessage(isSuccessMessage: success, body: message ?? "")

                if !success {
                    print("Error: \(message ?? "Unknown error")")
                }
            }
        }
    }

    func showMessage(isSuccessMessage: Bool, body: String) {
        self.messageTitle = isSuccessMessage ? NSLocalizedString("success", comment: "") : NSLocalizedString("error", comment: "")
        self.messageBody = body
        self.showMessage = true
    }
}