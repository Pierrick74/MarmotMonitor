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
    let oneSleepBabyActivity = BabyActivity(activity: .sleep(duration: 2400), date: .now)
    let  sleepBabyActivityBefore = BabyActivity(activity: .sleep(duration: 2400), date: Date(timeIntervalSinceNow: -86400))
    let oneSleepBabyActivityDuringOneHourAndHalf = BabyActivity(activity: .sleep(duration: 5400), date: .now)
    let  sleepBabyActivityBeforeOneHourDuringTwo = BabyActivity(activity: .sleep(duration: 7200), date: Date(timeIntervalSinceNow: -3600))

    // MARK: - Diaper Activities
    let oneDiaperBabyActivity = BabyActivity(activity: .diaper(state: .wet), date: .now)

    // MARK: - Bottle Activities
    let oneBottleBabyActivity = BabyActivity(activity: .bottle(volume: 120), date: .now)

    // MARK: - Growth Activities
    let oneGrowthBabyActivity = BabyActivity(activity: .growth(data: GrowthData(weight: 9.2, height: 70, headCircumference: 45)),
                                             date: .now)

    // MARK: - Breast Activities
    let oneBreastBabyActivity = BabyActivity(activity: .breast(duration:
                                                                    BreastDuration(leftDuration: 400,
                                                                                   rightDuration: 300),
                                                                                    lastBreast: .left),
                                             date: .now)

    // MARK: - Date Activities
    let nowActivity = BabyActivity(activity: .bottle(volume: 120), date: .now)
    let oneDayActivity = BabyActivity(activity: .bottle(volume: 120), date: Date(timeIntervalSinceNow: -86400))
    let twoDaysActivity = BabyActivity(activity: .bottle(volume: 120), date: Date(timeIntervalSinceNow: -172800))
    let oneMinuteActivity = BabyActivity(activity: .bottle(volume: 120), date: Date(timeIntervalSinceNow: -60))
    let twoMinutesActivity = BabyActivity(activity: .bottle(volume: 120), date: Date(timeIntervalSinceNow: -120))
    let oneHourActivity = BabyActivity(activity: .bottle(volume: 120), date: Date(timeIntervalSinceNow: -3600))
    let oneHourAndAndHalfActivity = BabyActivity(activity: .sleep(duration: 3600), date: Date(timeIntervalSinceNow: -5400))
    let twoHoursActivity = BabyActivity(activity: .bottle(volume: 120), date: Date(timeIntervalSinceNow: -7200))

    // MARK: - unit Imperials
    let oneBottleBabyActivityImperial = BabyActivity(activity: .bottle(volume: 4, measurementSystem: .imperial), date: .now)
    let oneGrowthBabyActivityImperial = BabyActivity(activity:
            .growth(data: GrowthData(weight: 6,
                                     height: 6,
                                     headCircumference: 6,
                                     measurementSystem: .imperial)),
                                                     date: .now)
}
