//
//  File.swift
//  
//
//  Created by Nicolas Bush on 21/02/2023.
//

import Foundation

enum ExportProjectType : String {
    
    case arb = "arb" // [Flutter ARB],
    case csv = "csv" // [CSV],
    case ini = "ini" // [INI],
    case keyValueJson = "key_value_json" // [Key-Value JSON],
    case json = "json" // [JSON],
    case po = "po" // [Gettext PO],
    case pot = "pot" // [Gettext POT],
    case mo = "mo" // [Gettext MO],
    case properties = "properties" // [Java Properties],
    case resw = "resw" // [.NET RESW], resx [.NET RESX],
    case ts = "ts" // [Qt TS],
    case appleStrings = "apple_strings" // [iOS Strings],
    case xliff = "xliff" // [iOS XLIFF],
    case xliff_1_2 = "xliff_1_2" // [XLIFF 1.2],
    case xlf = "xlf" // [Angular XLIFF],
    case xmb = "xmb" // [Angular XMB],
    case xtb = "xtb" // [Angular XTB],
    case rise360Xliff = "rise_360_xliff" // [Rise 360 XLIFF],
    case xls = "xls" // [Microsoft Excel],
    case xlsx = "xlsx" // [Microsoft Excel],
    case androidStrings = "android_strings" // [Android String Resources],
    case yml = "yml" // [YAML]
}
