//
//  ViewModel.swift
//  SwiftUIAPICalls
//
//  Created by Shomil Singh on 07/12/23.
//

import Foundation
import SwiftUI
struct Course : Hashable , Codable {
    let name : String
    let image : String
}
class ViewModel: ObservableObject {
    @Published var courses: [Course] = []
    
    func fetch() {
        
        let useSampleDataForDebugging = true

        if useSampleDataForDebugging {
            
            let sampleJSONString = """
                [
                    {"name": "Sample Course 1", "image": "sample_image_1"},
                    {"name": "Sample Course 2", "image": "sample_image_2"}
                ]
            """
            
            guard let sampleData = sampleJSONString.data(using: .utf8) else {
                print("Error converting sample JSON string to data")
                return
            }

            do {
                let sampleCourses = try JSONDecoder().decode([Course].self, from: sampleData)
                DispatchQueue.main.async {
                    self.courses = sampleCourses
                }
            } catch {
                print("Error decoding sample data: \(error)")
            }
            
        } else {
            
            guard let url = URL(string: "https://iosacademy.io/api/v1/courses/index.php") else {
                return
            }

            let task = URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
                guard let data = data, error == nil else {
                    return
                }

                do {
                    let courses = try JSONDecoder().decode([Course].self, from: data)
                    DispatchQueue.main.async {
                        self?.courses = courses
                    }
                } catch {
                    print(error)
                }
            }

            task.resume()
        }
    }
}
