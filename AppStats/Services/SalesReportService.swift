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
    
    func getSubscriptions(date: Date) async throws -> [SubscriptionReport] {
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
                    // print(str)
                    let tsv: CSV = try CSV<Named>(string: str, delimiter: .tab)
                    // print(tsv.header)
                    // print(tsv.rows.filter { $0["SKU"] == "blur_premium_monthly" || $0["SKU"] == "blur_premium_three_months" })
                    // print(tsv.columns?["Subscribers"] ?? "No column named that")
                    
                    print(str)
                    
                    // Store the TSV data as a string in UserDefaults, now that we know it can be decoded as a tsv
                    let userDefaultsKey = getUserDefaultsSubscriptionKey(forDate: date, andFrequency: .DAILY)
                    print("userDefaultsKey", userDefaultsKey)
                    userDefaultsService.set(str, forKey: userDefaultsKey)
                    
                    let activeSubscribersRows = try tsv.rows.map { (element: Named.Row) -> SubscriptionReport in
                        
                        return try SubscriptionReport(reportRow: element, date: date)
                        /*
                        let subscribersFieldName = SalesReportSubscriptionFields.subscribers.rawValue
                        guard let subscribers = element[subscribersFieldName] else {
                            print("Cound not get \(subscribersFieldName)")
                            throw SalesServiceError.tsvFieldNotFound(fieldName: subscribersFieldName)
                        }
                        
                        let countryFieldName = SalesReportSubscriptionFields.country.rawValue
                        guard let country = element[countryFieldName] else {
                            print("Cound not get \(countryFieldName)")
                            throw SalesServiceError.tsvFieldNotFound(fieldName: countryFieldName)
                        }
                        
                        let subscriptionNameFieldName = SalesReportSubscriptionFields.subscriptionName.rawValue
                        guard let subscriptionName = element[subscriptionNameFieldName] else {
                            print("Cound not get \(subscriptionNameFieldName)")
                            throw SalesServiceError.tsvFieldNotFound(fieldName: subscriptionNameFieldName)
                        }
                        
                        var subs = 0.0
                        if !subscribers.isEmpty {
                            subs = try Double(value: subscribers)
                        }
                        
                        return ActiveSubscribers(
                            subscribers: Int(subs),
                            date: date,
                            country: country,
                            subscriptionName: subscriptionName
                        )*/
                    }
                    return activeSubscribersRows
                    
//                    if let subs = tsv.columns?["Subscribers"] {
//                        let sum = subs
//                            .filter { !$0.isEmpty }
//                            .compactMap { Double($0) }
//                            .reduce(0.0, +)
//                        print("Count nr: \(count) has this many subs: \(sum)")
//                        return DailySubscribers(
//                            subscribers: Int(sum),
//                            date: date,
//                            country: "NOK",
//                            subscriptionName: "premium"
//                        )
//                    } else {
//                        throw SalesServiceError.tsvFieldNotFound(fieldName: "Subscribers")
//                    }
                    
                } else {
                    print("data is not gzipped...")
                    
                    throw SalesServiceError.dataNotGzipped
                }
                // print(buffer)
                
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
