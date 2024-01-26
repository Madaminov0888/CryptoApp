//
//  MarketDataModel.swift
//  CryptoApp
//
//  Created by Muhammadjon Madaminov on 28/10/23.
//

import Foundation
import SwiftUI

/*
URL: https://api.coingecko.com/api/v3/global
 
 response: {
    "data":{
        "active_cryptocurrencies":10641,
        "upcoming_icos":0,
        "ongoing_icos":49,
        "ended_icos":3376,
        "markets":911,
        "total_market_cap":{
            "btc":38173044.4132782,
            "eth":733448881.1437758,
            "ltc":19152278617.14399,
            "bch":5351324535.64339,
            "bnb":5800062249.268426,
            "eos":2086882103513.1372,
            "xrp":2364757120343.617,"xlm":11375410654540.906,"link":117683914568.01286,"dot":305361021217.45593,"yfi":218931551.38059467,"usd":1311002463833.7383,"aed":4815312049661.31,"ars":458482308085165.44,"aud":2063919044828.2332,"bdt":144432791402904.94,"bhd":493954264313.41974,"bmd":1311002463833.7383,"brl":6523890431679.734,"cad":1817563327839.3843,"chf":1184359625827.3958,"clp":1191820421547850.8,"cny":9593522729596.148,"czk":30596962102430.05,"dkk":9266459078928.75,"eur":1241558663324.465,"gbp":1081891673254.1539,"hkd":10254206354252.541,"huf":476562505628200.75,"idr":2.086901590694606e+16,"ils":5315092408924.008,"inr":109143971730827.97,"jpy":196070906486045.97,"krw":1773336208737104.5,"kwd":405034211201.4342,"lkr":428731236236460.94,"mmk":2750671720119534.5,"mxn":23729625733294.867,"myr":6238405224152.836,"ngn":1034289173792348.5,"nok":14647897389540.002,"nzd":2250584819638.736,"php":74639953530668.34,"pkr":363476348177623.44,"pln":5543608004385.03,"rub":122880255691126.45,"sar":4918094642825.882,"sek":14624518282602.459,"sgd":1794140957820.5278,"thb":47229519260842.234,"try":37032542097143.46,"twd":42498764248093.234,"uah":47702232663236.5,"vef":131270676703.6722,"vnd":3.2195543784275052e+16,"zar":24664787388791.832,"xdr":998955035387.1024,"xag":56762329466.33844,"xau":655252141.4487411,"bits":38173044413278.2,"sats":3.81730444132782e+15},"total_volume":{"btc":4317999.700339312,"eth":82965141.96523975,"ltc":2166437982.6324873,"bch":605322894.6363252,"bnb":656082516.8447614,"eos":236060718659.3359,"xrp":267492957241.50226,"xlm":1286746198855.9282,"link":13311987965.588552,"dot":34541358133.165665,"yfi":24764762.354856793,"usd":148295959439.09253,"aed":544691059019.7856,"ars":51861896250381.01,"aud":233463218720.7195,"bdt":16337726256383.635,"bhd":55874358413.62343,"bmd":148295959439.09253,"brl":737959399414.337,"cad":205596331798.68237,"chf":133970569757.2758,"clp":134814508567511.52,"cny":1085185342387.4476,"czk":3461020078965.2007,"dkk":1048189059610.4192,"eur":140440722467.6038,"gbp":122379757567.5167,"hkd":1159919536034.6553,"huf":53907064215704.35,"idr":2360629229803439.5,"ils":601224444677.1565,"inr":12345979852307.12,"jpy":22178847101791.77,"krw":200593516593194.44,"kwd":45816036668.707726,"lkr":48496560283549.04,"mmk":311146251124694.4,"mxn":2684211290464.686,"myr":705666322990.9209,"ngn":116995131280282.95,"nok":1656918317906.911,"nzd":254578190609.49527,"php":8443007413541.743,"pkr":41115158265068.06,"pln":627073320183.1492,"rub":13899779685042.307,"sar":556317462239.8113,"sek":1654273756062.2341,"sgd":202946876187.34323,"thb":5342436086773.016,"try":4188990114255.7593,"twd":4807309820545.128,"uah":5395907754051.794,"vef":14848874418.636332,"vnd":3.641845981883586e+15,"zar":2789993467659.8623,"xdr":112998258581.48064,"xag":6420753843.278861,"xau":74119803.48725288,"bits":4317999700339.3115,"sats":431799970033931.2},"market_cap_percentage":{"btc":51.1563363628586,"eth":16.397444755499464,"usdt":6.454057406978958,"bnb":2.6528572208202426,"xrp":2.2648733909760432,"usdc":1.911444217598008,"steth":1.198609332436865,"sol":1.051698023434063,"ada":0.7848683414224816,"doge":0.7440477370084062},
    "market_cap_change_percentage_24h_usd":1.1423324168047915,
    "updated_at":1698641026
    }
 }
 
*/



struct MarketDataModel: Codable {
    let data: DataClass
}

struct DataClass: Codable {
    let totalMarketCap, totalVolume, marketCapPercentage: [String: Double]
    let marketCapChangePercentage24HUsd: Double

    enum CodingKeys: String, CodingKey {
        case totalMarketCap = "total_market_cap"
        case totalVolume = "total_volume"
        case marketCapPercentage = "market_cap_percentage"
        case marketCapChangePercentage24HUsd = "market_cap_change_percentage_24h_usd"
    }
    
    
    var marketCap: String {
        if let item = totalMarketCap.first(where: { key, value in
            return key == "usd"
        }) {
            return "$" + item.value.formattedWithAbbreviations()
        }
        return ""
    }
    
    var volume: String {
        if let volume = totalVolume.first(where: { $0.key == "usd" }) {
            return "$" + volume.value.formattedWithAbbreviations()
        }
        return ""
    }
    
    var btcDominance: String {
        if let item = marketCapPercentage.first(where: { $0.key == "btc" }) {
            return item.value.asNumberForPercentage()
        }
        return ""
    }
}
