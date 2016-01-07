//
//  DateUtilities.swift
//  ArtWhisper
//
//  Created by Axel Roest on 07/01/16.
//  Copyright © 2016 Phluxus. All rights reserved.
//

import Foundation
//+ (NSString*)durationInHoursMinutesAndSeconds:(NSTimeInterval)duration {
//    int hours = (int)floor(duration/3600);
//    int minutes = (int)floor((duration - hours * 3600) / 60);
//    int seconds = (int)round(duration - minutes * 60);
//    return [NSString stringWithFormat:@"%d:%02d:%02d",hours,minutes,seconds];
//}

class DateUtilities {
    
    class func durationInMinutesAndSeconds(duration: NSTimeInterval) -> String {
        let absdur = abs(duration)
        var timeStr = "00:00"
        if (!absdur.isNaN) {
            let minutes = Int(floor(absdur / 60))
            let seconds = Int(floor(absdur - Double(minutes) * 60))
            timeStr = duration < 0 ? String(format: "–%02d:%02d", minutes, seconds) : String(format: "%02d:%02d", minutes, seconds)
        }
        return timeStr
    }
}