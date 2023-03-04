//
//  Population.swift
//  DesignApp
//
//  Created by Mac on 04/03/23.
//

import Foundation
struct Population: Decodable {
    var population: Int
    var year: String
    
    
    private enum CodingKeys: CodingKey{
        case data
    }
    private enum DataKeys: CodingKey{
        case population
        case year
    }
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let dataContainer = try container.nestedContainer(keyedBy: DataKeys.self, forKey: .data)
       
        self.population = try dataContainer.decode(Int.self, forKey: .population)
        self.year = try dataContainer.decode(String.self, forKey: .year)
    }
}
