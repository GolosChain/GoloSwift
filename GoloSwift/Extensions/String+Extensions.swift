//
//  String+Extensions.swift
//  GoloSwift
//
//  Created by msm72 on 04.05.2018.
//  Copyright © 2018 Golos.io. All rights reserved.
//

import Foundation

extension String {
    func convert(toDateFormat dateFormatType: DateFormatType) -> Date {
        let dateFormatter           =   DateFormatter()
        dateFormatter.dateFormat    =   dateFormatType.rawValue
        dateFormatter.timeZone      =   TimeZone(identifier: "UTC")
        
        return dateFormatter.date(from: self)!
    }
    
    func convert(toIntFromStartByte startIndex: Int, toEndByte endIndex: Int) -> UInt32 {
        // Test value "00ce18271e38c48379c4744702be5202d42b2d23"
        let selfString: [Character]         =   Array(self)
        let selfStringBytesArray: [UInt8]   =   stride(from: 0, to: count, by: 2).compactMap { UInt8(String(selfString[$0..<$0.advanced(by: 2)]), radix: 16) }.reversed()
        let selectedBytesArray: [UInt8]     =   Array(selfStringBytesArray[startIndex..<endIndex])
        let selectedBytesArrayData: Data    =   Data(bytes: selectedBytesArray)
        
        return UInt32(bigEndian: selectedBytesArrayData.withUnsafeBytes { $0.pointee })
    }

    var hexBytes: [Byte] {
        return stride(from: 0, to: count, by: 2).compactMap { Byte(String(Array(self)[$0..<$0.advanced(by: 2)]), radix: 16) }
    }
    
    
    /// Base58 decode
    public var base58EncodedString: String {
        return [Byte](utf8).base58EncodedString
    }
    
    
    /// Cyrillic -> Latin
    func transliterationInLatin() -> String {
        var newString: String = ""
        var latinChar: String
        
        for char in self {
            latinChar = transliterate(char: "\(char)")
            newString.append(latinChar)
        }
        
        return String(format: "ru-%@", newString)
    }
    
    func transliterate(char: String) -> String {
        let cyrillicChars   =   ["а", "б", "в", "г", "д", "е", "ё", "ж", "з", "и", "й", "к", "л", "м", "н", "о", "п", "р", "с", "т", "у", "ф", "х", "ц", "ч", "ш", "щ", "ъ", "ы", "ь", "э", "ю", "я"]
        
        // https://en.wikipedia.org/wiki/Romanization_of_Russian, Passport (2013), ICAO
        let latinChars      =   ["a", "b", "v", "g", "d", "e", "e", "zh", "z", "i", "i", "k", "l", "m", "n", "o", "p", "r", "s", "t", "u", "f", "kh", "ts", "ch", "sh", "shch", "ie", "y", "'", "e", "iu", "ia"]
        
        let convertDict     =   NSDictionary.init(objects: latinChars, forKeys: cyrillicChars as [NSCopying])
        
        return  convertDict.value(forKey: char.lowercased()) as! String
    }
}
