//
//  SalesReportService.swift
//  AppStats
//
//  Created by Alfred Lieth Årøe on 03/12/2023.
//

import Foundation
import Gzip
import SwiftCSV

class SalesReportService {
    let client: Client
    let vendorNumber: String
    let dateFormatter = DateFormatter()
    
    init(client: Client, vendorNumber: String) {
        self.client = client
        self.vendorNumber = vendorNumber
        dateFormatter.dateFormat = "yyyy-MM-dd"
    }
    
    func decodeSubscriptionTSVDataString(str: String, date: Date) throws -> [SubscriptionReport] {
        let tsv: CSV = try CSV<Named>(string: str, delimiter: .tab)
        let activeSubscribersRows = try tsv.rows.map { (element: Named.Row) -> SubscriptionReport in
            return try SubscriptionReport(reportRow: element, date: date)
        }
        return activeSubscribersRows
    }

    func decodeSubscriptionTSVData(tsv: CSV<Named>, date: Date) throws -> [SubscriptionReport] {
        let activeSubscribersRows = try tsv.rows.map { (element: Named.Row) -> SubscriptionReport in
            return try SubscriptionReport(reportRow: element, date: date)
        }
        return activeSubscribersRows
    }
    
    func getSubscriptions(date: Date) async throws -> [SubscriptionReport] {
        let userDefaultsKey = getUserDefaultsSubscriptionKey(forDate: date, andFrequency: .DAILY)
        if let storedValue = userDefaultsService.string(forKey: userDefaultsKey) {
            return try decodeSubscriptionTSVDataString(str: storedValue, date: date)
        }
        
        let reportDate = [dateFormatter.string(from: date)]
        
        print("Fetching for date: \(reportDate)")
        
        let response = try await client.salesReports_hyphen_get_collection(
            Operations.salesReports_hyphen_get_collection.Input(
                query:
                    Operations.salesReports_hyphen_get_collection.Input.Query(
                        filter_lbrack_frequency_rbrack_: [.DAILY],
                        filter_lbrack_reportDate_rbrack_: reportDate,
                        filter_lbrack_reportSubType_rbrack_: [.SUMMARY],
                        filter_lbrack_reportType_rbrack_: [.SUBSCRIPTION],
                        filter_lbrack_vendorNumber_rbrack_: [vendorNumber],
                        filter_lbrack_version_rbrack_: ["1_3"]
                    )
            )
        )
        
        
        
        switch response {
        case let .ok(okResponse):
            switch okResponse.body {
            case let .application_a_hyphen_gzip(body):
                let buffer = try await ArraySlice(collecting: body, upTo: 2 * 1024 * 1024)
                let data = Data(buffer)
                if data.isGzipped {
                    let unzipped = try! data.gunzipped()
                    let str = String(decoding: unzipped, as: Unicode.ASCII.self)
                    let tsv: CSV = try CSV<Named>(string: str, delimiter: .tab)
                    
                    // Store the TSV data as a string in UserDefaults, now that we know it can be decoded as a tsv
                    userDefaultsService.set(str, forKey: userDefaultsKey)
                    return try decodeSubscriptionTSVData(tsv: tsv, date: date)
                    
                } else {
                    print("data is not gzipped...")
                    throw SalesServiceError.dataNotGzipped
                }
                
            }
        case let .badRequest(res):
            print("Bad request...", res)
            
            throw SalesServiceError.badRequest
        case let .forbidden(res):
            print("Forbidden...", res)
            
            throw SalesServiceError.forbidden
        case .undocumented(statusCode: let statusCode, let res):
            print("Undowumented case for date...: \(reportDate)")
            if (statusCode == 401) {
                print("Result: \(res)")
                throw SalesServiceError.unauthorized
            }
            print("Undocumented case. Status code:", statusCode)
            print(res)
            
            throw SalesServiceError.unexpected(code: statusCode)
        }
    }
    
    func getSubscriptionsFromLastSevenDays() async throws -> [SubscriptionReport] {
        var dates: [Date] = []
        let currentDate = Date()
        let calendar = Calendar.current
        let year = calendar.component(.year, from: currentDate)
        let month = calendar.component(.month, from: currentDate)
        let day = calendar.component(.day, from: currentDate)
        
        // TODO: Find out when new report are avaliable. Only ask for them then.
        // TODO: Store all reports in UserData or something that widgets could also access
        // TODO: Handle 404.
        
        guard let theDate = calendar.date(from: DateComponents(year: year, month: month, day: day)) else {
            print("Could not create date from components")
            throw SalesServiceError.dateFormat
        }
        
        for i in 1...7 {
            guard let newDate = Calendar.current.date(byAdding: .day, value: -(9-i), to: theDate) else {
                print("Could not get date for i: \(i)")
                throw SalesServiceError.dateFormat
            }
            dates.append(newDate)
        }
        
        let constantDates = dates
        
        do {
            let subs = try await withThrowingTaskGroup(of: [SubscriptionReport].self) { group -> [SubscriptionReport] in
                for i in 1...7 {
                    guard let newDate = Calendar.current.date(byAdding: .day, value: -(9-i), to: theDate) else {
                        print("Could not get date for i: \(i)")
                        throw SalesServiceError.dateFormat
                    }
                    group.addTask {
                        let subs = try await self.getSubscriptions(date: newDate)
                        return subs
                    }
                }
                let allSubs = try await group.reduce(into: [SubscriptionReport]()) { $0 += $1 }
                return allSubs.sorted { $0.date > $1.date }
            }
            return subs
        } catch let err {
            print("rip... because: \(err)")
            throw err
        }
        
        
        async let subs1 = getSubscriptions(date: constantDates[0])
        async let subs2 = getSubscriptions(date: constantDates[1])
        async let subs3 = getSubscriptions(date: constantDates[2])
        async let subs4 = getSubscriptions(date: constantDates[3])
        async let subs5 = getSubscriptions(date: constantDates[4])
        async let subs6 = getSubscriptions(date: constantDates[5])
        async let subs7 = getSubscriptions(date: constantDates[6])
        
        do {
            let (
                subsData1,
                subsData2,
                subsData3,
                subsData4,
                subsData5,
                subsData6,
                subsData7
            ) = try await (
                subs1,
                subs2,
                subs3,
                subs4,
                subs5,
                subs6,
                subs7
            )
            
            return [
                subsData1,
                subsData2,
                subsData3,
                subsData4,
                subsData5,
                subsData6,
                subsData7
            ].flatMap { $0 }
        } catch let error {
            print("rip... because: \(error)")
            throw error
        }
    }
}


enum SalesServiceError: Error {
    case notInitialized
    
    case tsvFieldNotFound(fieldName: String)
    case dataNotGzipped

    case notFound
    case badRequest
    case forbidden
    case unauthorized
    
    case dateFormat

    case unexpected(code: Int)
}
