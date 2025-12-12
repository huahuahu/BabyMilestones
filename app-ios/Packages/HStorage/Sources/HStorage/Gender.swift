//
//  Gender.swift
//  HStorage
//
//  Created by tigerguo on 2025/11/14.
//

public enum Gender: String, CaseIterable, Codable, Sendable { case male, female, unspecified }

public enum MeasurementType: String, CaseIterable, Codable, Sendable { case height, weight, headCircumference }
