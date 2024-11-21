//
//  MockActivities.swift
//  MarmotMonitorTests
//
//  Created by pierrick viret on 21/11/2024.
//

import Foundation
@testable import MarmotMonitor

class MockActivities {
    // MARK: - Sleep Activities
    let oneSleepBabyActivity = BabyActivity(activity: Activity(type: .sleep(duration: 2400)), date: .now)
    let  sleepBabyActivityBefore = BabyActivity(activity: Activity(type: .sleep(duration: 2400)), date: Date(timeIntervalSinceNow: 86400))

    // MARK: - Diaper Activities
    let oneDiaperBabyActivity = BabyActivity(activity: Activity(type: .diaper(state: .wet)), date: .now)

    // MARK: - Bottle Activities
    let oneBottleBabyActivity = BabyActivity(activity: Activity(type: .bottle(volume: 120)), date: .now)

    // MARK: - Growth Activities
    let oneGrowthBabyActivity = BabyActivity(activity:
                                                Activity(type: .growth(data: GrowthData(weight: 9.2, height: 70, headCircumference: 45))),
                                             date: .now)

    // MARK: - Breast Activities
    let oneBreastBabyActivity = BabyActivity(activity:
                                                Activity(type:
                                                        .breast(duration:
                                                                    BreastDuration(leftDuration: 400,
                                                                                   rightDuration: 300),
                                                                                    lastBreast: .left)),
                                             date: .now)

    // MARK: - Solid Activities
    let oneSolidBabyActivity = BabyActivity(activity: Activity(type: .solid(composition:
                                                                            SolidQuantity(vegetable: 20,
                                                                                          meat: 20,
                                                                                          fruit: 20,
                                                                                          dairyProduct: 20,
                                                                                          cereal: 20,
                                                                                          other: 20))),
                                            date: .now)
}
