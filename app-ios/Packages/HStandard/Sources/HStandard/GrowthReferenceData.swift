/* 
 Generated from WS/T 423—2022 (附录 A: A.1/A.2/A.3/A.4/A.11/A.12)
 Source PDF: prc-wst-423-2022.pdf.  [oai_citation:1‡prc-wst-423-2022.pdf](sediment://file_0000000009047209af2491ee7f5e7e85)

 Notes:
 - ageDays = Int(Double(ageMonths) * 30.4375)
 - headCircumference is nil where the standard does not provide values (after 36 months)
 - Each PercentileValues uses the original 7 points from the standard:
   p3, p10, p25, p50, p75, p90, p97
*/

extension GrowthReference {
    static let male: [GrowthReference] = [
        GrowthReference(
            ageMonth: 0,
            gender: .male,
            height: HeightPercentiles(p3: 47.6, p10: 48.7, p25: 49.9, p50: 51.2, p75: 52.5, p90: 53.6, p97: 54.6),
            weight: WeightPercentiles(p3: 2.8, p10: 3.0, p25: 3.2, p50: 3.5, p75: 3.7, p90: 4.0, p97: 4.2),
            headCircumference: headCircumferencePercentile(p3: 31.9, p10: 32.7, p25: 33.4, p50: 34.3, p75: 35.2, p90: 36.0, p97: 36.8),
            bmi: BMIPercentiles(p3: 11.2, p10: 11.8, p25: 12.5, p50: 13.2, p75: 14.0, p90: 14.8, p97: 15.5)
        ),

               GrowthReference(
            ageMonth: 1,
            gender: .male,
            height: HeightPercentiles(p3: 47.6, p10: 48.7, p25: 49.9, p50: 51.2, p75: 52.5, p90: 53.6, p97: 54.6),
            
            weight: WeightPercentiles(p3: 3.7, p10: 3.9, p25: 4.2, p50: 4.6, p75: 4.9, p90: 5.2, p97: 5.6),
            headCircumference: headCircumferencePercentile(p3: 31.9, p10: 32.7, p25: 33.4, p50: 34.3, p75: 35.2, p90: 36.0, p97: 36.8),
            bmi: BMIPercentiles(p3: 11.2, p10: 11.8, p25: 12.5, p50: 13.2, p75: 14.0, p90: 14.8, p97: 15.5)
        ),
                      GrowthReference(
            ageMonth: 2,
            gender: .male,
            height: HeightPercentiles(p3: 47.6, p10: 48.7, p25: 49.9, p50: 51.2, p75: 52.5, p90: 53.6, p97: 54.6),
            weight: WeightPercentiles(p3: 4.7, p10: 5.0, p25: 5.4, p50: 5.8, p75: 6.2, p90: 6.7, p97: 7.1),
            headCircumference: headCircumferencePercentile(p3: 31.9, p10: 32.7, p25: 33.4, p50: 34.3, p75: 35.2, p90: 36.0, p97: 36.8),
            bmi: BMIPercentiles(p3: 11.2, p10: 11.8, p25: 12.5, p50: 13.2, p75: 14.0, p90: 14.8, p97: 15.5)
        ),
                      GrowthReference(
            ageMonth: 3,
            gender: .male,
            height: HeightPercentiles(p3: 47.6, p10: 48.7, p25: 49.9, p50: 51.2, p75: 52.5, p90: 53.6, p97: 54.6),
            // 3 月 5.5 5.9 6.3 6.8 7.3 7.8 8.3
            weight: WeightPercentiles(p3: 5.5, p10: 5.9, p25: 6.3, p50: 6.8, p75: 7.3, p90: 7.8, p97: 8.3),
            headCircumference: headCircumferencePercentile(p3: 31.9, p10: 32.7, p25: 33.4, p50: 34.3, p75: 35.2, p90: 36.0, p97: 36.8),
            bmi: BMIPercentiles(p3: 11.2, p10: 11.8, p25: 12.5, p50: 13.2, p75: 14.0, p90: 14.8, p97: 15.5)
        ),
                      GrowthReference(
            ageMonth: 1,
            gender: .male,
            height: HeightPercentiles(p3: 47.6, p10: 48.7, p25: 49.9, p50: 51.2, p75: 52.5, p90: 53.6, p97: 54.6),
            
            weight: WeightPercentiles(p3: 3.7, p10: 3.9, p25: 4.2, p50: 4.6, p75: 4.9, p90: 5.2, p97: 5.6),
            headCircumference: headCircumferencePercentile(p3: 31.9, p10: 32.7, p25: 33.4, p50: 34.3, p75: 35.2, p90: 36.0, p97: 36.8),
            bmi: BMIPercentiles(p3: 11.2, p10: 11.8, p25: 12.5, p50: 13.2, p75: 14.0, p90: 14.8, p97: 15.5)
        ),
                      GrowthReference(
            ageMonth: 1,
            gender: .male,
            height: HeightPercentiles(p3: 47.6, p10: 48.7, p25: 49.9, p50: 51.2, p75: 52.5, p90: 53.6, p97: 54.6),
            
            weight: WeightPercentiles(p3: 3.7, p10: 3.9, p25: 4.2, p50: 4.6, p75: 4.9, p90: 5.2, p97: 5.6),
            headCircumference: headCircumferencePercentile(p3: 31.9, p10: 32.7, p25: 33.4, p50: 34.3, p75: 35.2, p90: 36.0, p97: 36.8),
            bmi: BMIPercentiles(p3: 11.2, p10: 11.8, p25: 12.5, p50: 13.2, p75: 14.0, p90: 14.8, p97: 15.5)
        ),
                      GrowthReference(
            ageMonth: 1,
            gender: .male,
            height: HeightPercentiles(p3: 47.6, p10: 48.7, p25: 49.9, p50: 51.2, p75: 52.5, p90: 53.6, p97: 54.6),
            
            weight: WeightPercentiles(p3: 3.7, p10: 3.9, p25: 4.2, p50: 4.6, p75: 4.9, p90: 5.2, p97: 5.6),
            headCircumference: headCircumferencePercentile(p3: 31.9, p10: 32.7, p25: 33.4, p50: 34.3, p75: 35.2, p90: 36.0, p97: 36.8),
            bmi: BMIPercentiles(p3: 11.2, p10: 11.8, p25: 12.5, p50: 13.2, p75: 14.0, p90: 14.8, p97: 15.5)
        ),
                      GrowthReference(
            ageMonth: 1,
            gender: .male,
            height: HeightPercentiles(p3: 47.6, p10: 48.7, p25: 49.9, p50: 51.2, p75: 52.5, p90: 53.6, p97: 54.6),
            
            weight: WeightPercentiles(p3: 3.7, p10: 3.9, p25: 4.2, p50: 4.6, p75: 4.9, p90: 5.2, p97: 5.6),
            headCircumference: headCircumferencePercentile(p3: 31.9, p10: 32.7, p25: 33.4, p50: 34.3, p75: 35.2, p90: 36.0, p97: 36.8),
            bmi: BMIPercentiles(p3: 11.2, p10: 11.8, p25: 12.5, p50: 13.2, p75: 14.0, p90: 14.8, p97: 15.5)
        ),
                      GrowthReference(
            ageMonth: 1,
            gender: .male,
            height: HeightPercentiles(p3: 47.6, p10: 48.7, p25: 49.9, p50: 51.2, p75: 52.5, p90: 53.6, p97: 54.6),
            
            weight: WeightPercentiles(p3: 3.7, p10: 3.9, p25: 4.2, p50: 4.6, p75: 4.9, p90: 5.2, p97: 5.6),
            headCircumference: headCircumferencePercentile(p3: 31.9, p10: 32.7, p25: 33.4, p50: 34.3, p75: 35.2, p90: 36.0, p97: 36.8),
            bmi: BMIPercentiles(p3: 11.2, p10: 11.8, p25: 12.5, p50: 13.2, p75: 14.0, p90: 14.8, p97: 15.5)
        ),
                      GrowthReference(
            ageMonth: 1,
            gender: .male,
            height: HeightPercentiles(p3: 47.6, p10: 48.7, p25: 49.9, p50: 51.2, p75: 52.5, p90: 53.6, p97: 54.6),
            
            weight: WeightPercentiles(p3: 3.7, p10: 3.9, p25: 4.2, p50: 4.6, p75: 4.9, p90: 5.2, p97: 5.6),
            headCircumference: headCircumferencePercentile(p3: 31.9, p10: 32.7, p25: 33.4, p50: 34.3, p75: 35.2, p90: 36.0, p97: 36.8),
            bmi: BMIPercentiles(p3: 11.2, p10: 11.8, p25: 12.5, p50: 13.2, p75: 14.0, p90: 14.8, p97: 15.5)
        ),
                      GrowthReference(
            ageMonth: 1,
            gender: .male,
            height: HeightPercentiles(p3: 47.6, p10: 48.7, p25: 49.9, p50: 51.2, p75: 52.5, p90: 53.6, p97: 54.6),
            
            weight: WeightPercentiles(p3: 3.7, p10: 3.9, p25: 4.2, p50: 4.6, p75: 4.9, p90: 5.2, p97: 5.6),
            headCircumference: headCircumferencePercentile(p3: 31.9, p10: 32.7, p25: 33.4, p50: 34.3, p75: 35.2, p90: 36.0, p97: 36.8),
            bmi: BMIPercentiles(p3: 11.2, p10: 11.8, p25: 12.5, p50: 13.2, p75: 14.0, p90: 14.8, p97: 15.5)
        ),
                      GrowthReference(
            ageMonth: 1,
            gender: .male,
            height: HeightPercentiles(p3: 47.6, p10: 48.7, p25: 49.9, p50: 51.2, p75: 52.5, p90: 53.6, p97: 54.6),
            
            weight: WeightPercentiles(p3: 3.7, p10: 3.9, p25: 4.2, p50: 4.6, p75: 4.9, p90: 5.2, p97: 5.6),
            headCircumference: headCircumferencePercentile(p3: 31.9, p10: 32.7, p25: 33.4, p50: 34.3, p75: 35.2, p90: 36.0, p97: 36.8),
            bmi: BMIPercentiles(p3: 11.2, p10: 11.8, p25: 12.5, p50: 13.2, p75: 14.0, p90: 14.8, p97: 15.5)
        ),
                      GrowthReference(
            ageMonth: 1,
            gender: .male,
            height: HeightPercentiles(p3: 47.6, p10: 48.7, p25: 49.9, p50: 51.2, p75: 52.5, p90: 53.6, p97: 54.6),
            
            weight: WeightPercentiles(p3: 3.7, p10: 3.9, p25: 4.2, p50: 4.6, p75: 4.9, p90: 5.2, p97: 5.6),
            headCircumference: headCircumferencePercentile(p3: 31.9, p10: 32.7, p25: 33.4, p50: 34.3, p75: 35.2, p90: 36.0, p97: 36.8),
            bmi: BMIPercentiles(p3: 11.2, p10: 11.8, p25: 12.5, p50: 13.2, p75: 14.0, p90: 14.8, p97: 15.5)
        ),
                      GrowthReference(
            ageMonth: 1,
            gender: .male,
            height: HeightPercentiles(p3: 47.6, p10: 48.7, p25: 49.9, p50: 51.2, p75: 52.5, p90: 53.6, p97: 54.6),
            
            weight: WeightPercentiles(p3: 3.7, p10: 3.9, p25: 4.2, p50: 4.6, p75: 4.9, p90: 5.2, p97: 5.6),
            headCircumference: headCircumferencePercentile(p3: 31.9, p10: 32.7, p25: 33.4, p50: 34.3, p75: 35.2, p90: 36.0, p97: 36.8),
            bmi: BMIPercentiles(p3: 11.2, p10: 11.8, p25: 12.5, p50: 13.2, p75: 14.0, p90: 14.8, p97: 15.5)
        ),
                      GrowthReference(
            ageMonth: 1,
            gender: .male,
            height: HeightPercentiles(p3: 47.6, p10: 48.7, p25: 49.9, p50: 51.2, p75: 52.5, p90: 53.6, p97: 54.6),
            
            weight: WeightPercentiles(p3: 3.7, p10: 3.9, p25: 4.2, p50: 4.6, p75: 4.9, p90: 5.2, p97: 5.6),
            headCircumference: headCircumferencePercentile(p3: 31.9, p10: 32.7, p25: 33.4, p50: 34.3, p75: 35.2, p90: 36.0, p97: 36.8),
            bmi: BMIPercentiles(p3: 11.2, p10: 11.8, p25: 12.5, p50: 13.2, p75: 14.0, p90: 14.8, p97: 15.5)
        ),
                      GrowthReference(
            ageMonth: 1,
            gender: .male,
            height: HeightPercentiles(p3: 47.6, p10: 48.7, p25: 49.9, p50: 51.2, p75: 52.5, p90: 53.6, p97: 54.6),
            
            weight: WeightPercentiles(p3: 3.7, p10: 3.9, p25: 4.2, p50: 4.6, p75: 4.9, p90: 5.2, p97: 5.6),
            headCircumference: headCircumferencePercentile(p3: 31.9, p10: 32.7, p25: 33.4, p50: 34.3, p75: 35.2, p90: 36.0, p97: 36.8),
            bmi: BMIPercentiles(p3: 11.2, p10: 11.8, p25: 12.5, p50: 13.2, p75: 14.0, p90: 14.8, p97: 15.5)
        ),
                      GrowthReference(
            ageMonth: 1,
            gender: .male,
            height: HeightPercentiles(p3: 47.6, p10: 48.7, p25: 49.9, p50: 51.2, p75: 52.5, p90: 53.6, p97: 54.6),
            
            weight: WeightPercentiles(p3: 3.7, p10: 3.9, p25: 4.2, p50: 4.6, p75: 4.9, p90: 5.2, p97: 5.6),
            headCircumference: headCircumferencePercentile(p3: 31.9, p10: 32.7, p25: 33.4, p50: 34.3, p75: 35.2, p90: 36.0, p97: 36.8),
            bmi: BMIPercentiles(p3: 11.2, p10: 11.8, p25: 12.5, p50: 13.2, p75: 14.0, p90: 14.8, p97: 15.5)
        ),
                      GrowthReference(
            ageMonth: 1,
            gender: .male,
            height: HeightPercentiles(p3: 47.6, p10: 48.7, p25: 49.9, p50: 51.2, p75: 52.5, p90: 53.6, p97: 54.6),
            
            weight: WeightPercentiles(p3: 3.7, p10: 3.9, p25: 4.2, p50: 4.6, p75: 4.9, p90: 5.2, p97: 5.6),
            headCircumference: headCircumferencePercentile(p3: 31.9, p10: 32.7, p25: 33.4, p50: 34.3, p75: 35.2, p90: 36.0, p97: 36.8),
            bmi: BMIPercentiles(p3: 11.2, p10: 11.8, p25: 12.5, p50: 13.2, p75: 14.0, p90: 14.8, p97: 15.5)
        ),
                      GrowthReference(
            ageMonth: 1,
            gender: .male,
            height: HeightPercentiles(p3: 47.6, p10: 48.7, p25: 49.9, p50: 51.2, p75: 52.5, p90: 53.6, p97: 54.6),
            
            weight: WeightPercentiles(p3: 3.7, p10: 3.9, p25: 4.2, p50: 4.6, p75: 4.9, p90: 5.2, p97: 5.6),
            headCircumference: headCircumferencePercentile(p3: 31.9, p10: 32.7, p25: 33.4, p50: 34.3, p75: 35.2, p90: 36.0, p97: 36.8),
            bmi: BMIPercentiles(p3: 11.2, p10: 11.8, p25: 12.5, p50: 13.2, p75: 14.0, p90: 14.8, p97: 15.5)
        ),
                      GrowthReference(
            ageMonth: 1,
            gender: .male,
            height: HeightPercentiles(p3: 47.6, p10: 48.7, p25: 49.9, p50: 51.2, p75: 52.5, p90: 53.6, p97: 54.6),
            
            weight: WeightPercentiles(p3: 3.7, p10: 3.9, p25: 4.2, p50: 4.6, p75: 4.9, p90: 5.2, p97: 5.6),
            headCircumference: headCircumferencePercentile(p3: 31.9, p10: 32.7, p25: 33.4, p50: 34.3, p75: 35.2, p90: 36.0, p97: 36.8),
            bmi: BMIPercentiles(p3: 11.2, p10: 11.8, p25: 12.5, p50: 13.2, p75: 14.0, p90: 14.8, p97: 15.5)
        ),
                      GrowthReference(
            ageMonth: 1,
            gender: .male,
            height: HeightPercentiles(p3: 47.6, p10: 48.7, p25: 49.9, p50: 51.2, p75: 52.5, p90: 53.6, p97: 54.6),
            
            weight: WeightPercentiles(p3: 3.7, p10: 3.9, p25: 4.2, p50: 4.6, p75: 4.9, p90: 5.2, p97: 5.6),
            headCircumference: headCircumferencePercentile(p3: 31.9, p10: 32.7, p25: 33.4, p50: 34.3, p75: 35.2, p90: 36.0, p97: 36.8),
            bmi: BMIPercentiles(p3: 11.2, p10: 11.8, p25: 12.5, p50: 13.2, p75: 14.0, p90: 14.8, p97: 15.5)
        ),
                      GrowthReference(
            ageMonth: 1,
            gender: .male,
            height: HeightPercentiles(p3: 47.6, p10: 48.7, p25: 49.9, p50: 51.2, p75: 52.5, p90: 53.6, p97: 54.6),
            
            weight: WeightPercentiles(p3: 3.7, p10: 3.9, p25: 4.2, p50: 4.6, p75: 4.9, p90: 5.2, p97: 5.6),
            headCircumference: headCircumferencePercentile(p3: 31.9, p10: 32.7, p25: 33.4, p50: 34.3, p75: 35.2, p90: 36.0, p97: 36.8),
            bmi: BMIPercentiles(p3: 11.2, p10: 11.8, p25: 12.5, p50: 13.2, p75: 14.0, p90: 14.8, p97: 15.5)
        ),
                      GrowthReference(
            ageMonth: 1,
            gender: .male,
            height: HeightPercentiles(p3: 47.6, p10: 48.7, p25: 49.9, p50: 51.2, p75: 52.5, p90: 53.6, p97: 54.6),
            
            weight: WeightPercentiles(p3: 3.7, p10: 3.9, p25: 4.2, p50: 4.6, p75: 4.9, p90: 5.2, p97: 5.6),
            headCircumference: headCircumferencePercentile(p3: 31.9, p10: 32.7, p25: 33.4, p50: 34.3, p75: 35.2, p90: 36.0, p97: 36.8),
            bmi: BMIPercentiles(p3: 11.2, p10: 11.8, p25: 12.5, p50: 13.2, p75: 14.0, p90: 14.8, p97: 15.5)
        ),
                      GrowthReference(
            ageMonth: 1,
            gender: .male,
            height: HeightPercentiles(p3: 47.6, p10: 48.7, p25: 49.9, p50: 51.2, p75: 52.5, p90: 53.6, p97: 54.6),
            
            weight: WeightPercentiles(p3: 3.7, p10: 3.9, p25: 4.2, p50: 4.6, p75: 4.9, p90: 5.2, p97: 5.6),
            headCircumference: headCircumferencePercentile(p3: 31.9, p10: 32.7, p25: 33.4, p50: 34.3, p75: 35.2, p90: 36.0, p97: 36.8),
            bmi: BMIPercentiles(p3: 11.2, p10: 11.8, p25: 12.5, p50: 13.2, p75: 14.0, p90: 14.8, p97: 15.5)
        ),
                      GrowthReference(
            ageMonth: 1,
            gender: .male,
            height: HeightPercentiles(p3: 47.6, p10: 48.7, p25: 49.9, p50: 51.2, p75: 52.5, p90: 53.6, p97: 54.6),
            
            weight: WeightPercentiles(p3: 3.7, p10: 3.9, p25: 4.2, p50: 4.6, p75: 4.9, p90: 5.2, p97: 5.6),
            headCircumference: headCircumferencePercentile(p3: 31.9, p10: 32.7, p25: 33.4, p50: 34.3, p75: 35.2, p90: 36.0, p97: 36.8),
            bmi: BMIPercentiles(p3: 11.2, p10: 11.8, p25: 12.5, p50: 13.2, p75: 14.0, p90: 14.8, p97: 15.5)
        ),
                      GrowthReference(
            ageMonth: 1,
            gender: .male,
            height: HeightPercentiles(p3: 47.6, p10: 48.7, p25: 49.9, p50: 51.2, p75: 52.5, p90: 53.6, p97: 54.6),
            
            weight: WeightPercentiles(p3: 3.7, p10: 3.9, p25: 4.2, p50: 4.6, p75: 4.9, p90: 5.2, p97: 5.6),
            headCircumference: headCircumferencePercentile(p3: 31.9, p10: 32.7, p25: 33.4, p50: 34.3, p75: 35.2, p90: 36.0, p97: 36.8),
            bmi: BMIPercentiles(p3: 11.2, p10: 11.8, p25: 12.5, p50: 13.2, p75: 14.0, p90: 14.8, p97: 15.5)
        ),
                      GrowthReference(
            ageMonth: 1,
            gender: .male,
            height: HeightPercentiles(p3: 47.6, p10: 48.7, p25: 49.9, p50: 51.2, p75: 52.5, p90: 53.6, p97: 54.6),
            
            weight: WeightPercentiles(p3: 3.7, p10: 3.9, p25: 4.2, p50: 4.6, p75: 4.9, p90: 5.2, p97: 5.6),
            headCircumference: headCircumferencePercentile(p3: 31.9, p10: 32.7, p25: 33.4, p50: 34.3, p75: 35.2, p90: 36.0, p97: 36.8),
            bmi: BMIPercentiles(p3: 11.2, p10: 11.8, p25: 12.5, p50: 13.2, p75: 14.0, p90: 14.8, p97: 15.5)
        ),
                      GrowthReference(
            ageMonth: 1,
            gender: .male,
            height: HeightPercentiles(p3: 47.6, p10: 48.7, p25: 49.9, p50: 51.2, p75: 52.5, p90: 53.6, p97: 54.6),
            
            weight: WeightPercentiles(p3: 3.7, p10: 3.9, p25: 4.2, p50: 4.6, p75: 4.9, p90: 5.2, p97: 5.6),
            headCircumference: headCircumferencePercentile(p3: 31.9, p10: 32.7, p25: 33.4, p50: 34.3, p75: 35.2, p90: 36.0, p97: 36.8),
            bmi: BMIPercentiles(p3: 11.2, p10: 11.8, p25: 12.5, p50: 13.2, p75: 14.0, p90: 14.8, p97: 15.5)
        ),
                      GrowthReference(
            ageMonth: 1,
            gender: .male,
            height: HeightPercentiles(p3: 47.6, p10: 48.7, p25: 49.9, p50: 51.2, p75: 52.5, p90: 53.6, p97: 54.6),
            
            weight: WeightPercentiles(p3: 3.7, p10: 3.9, p25: 4.2, p50: 4.6, p75: 4.9, p90: 5.2, p97: 5.6),
            headCircumference: headCircumferencePercentile(p3: 31.9, p10: 32.7, p25: 33.4, p50: 34.3, p75: 35.2, p90: 36.0, p97: 36.8),
            bmi: BMIPercentiles(p3: 11.2, p10: 11.8, p25: 12.5, p50: 13.2, p75: 14.0, p90: 14.8, p97: 15.5)
        ),
                      GrowthReference(
            ageMonth: 1,
            gender: .male,
            height: HeightPercentiles(p3: 47.6, p10: 48.7, p25: 49.9, p50: 51.2, p75: 52.5, p90: 53.6, p97: 54.6),
            
            weight: WeightPercentiles(p3: 3.7, p10: 3.9, p25: 4.2, p50: 4.6, p75: 4.9, p90: 5.2, p97: 5.6),
            headCircumference: headCircumferencePercentile(p3: 31.9, p10: 32.7, p25: 33.4, p50: 34.3, p75: 35.2, p90: 36.0, p97: 36.8),
            bmi: BMIPercentiles(p3: 11.2, p10: 11.8, p25: 12.5, p50: 13.2, p75: 14.0, p90: 14.8, p97: 15.5)
        ),
                      GrowthReference(
            ageMonth: 1,
            gender: .male,
            height: HeightPercentiles(p3: 47.6, p10: 48.7, p25: 49.9, p50: 51.2, p75: 52.5, p90: 53.6, p97: 54.6),
            
            weight: WeightPercentiles(p3: 3.7, p10: 3.9, p25: 4.2, p50: 4.6, p75: 4.9, p90: 5.2, p97: 5.6),
            headCircumference: headCircumferencePercentile(p3: 31.9, p10: 32.7, p25: 33.4, p50: 34.3, p75: 35.2, p90: 36.0, p97: 36.8),
            bmi: BMIPercentiles(p3: 11.2, p10: 11.8, p25: 12.5, p50: 13.2, p75: 14.0, p90: 14.8, p97: 15.5)
        ),
                      GrowthReference(
            ageMonth: 1,
            gender: .male,
            height: HeightPercentiles(p3: 47.6, p10: 48.7, p25: 49.9, p50: 51.2, p75: 52.5, p90: 53.6, p97: 54.6),
            
            weight: WeightPercentiles(p3: 3.7, p10: 3.9, p25: 4.2, p50: 4.6, p75: 4.9, p90: 5.2, p97: 5.6),
            headCircumference: headCircumferencePercentile(p3: 31.9, p10: 32.7, p25: 33.4, p50: 34.3, p75: 35.2, p90: 36.0, p97: 36.8),
            bmi: BMIPercentiles(p3: 11.2, p10: 11.8, p25: 12.5, p50: 13.2, p75: 14.0, p90: 14.8, p97: 15.5)
        ),
                      GrowthReference(
            ageMonth: 1,
            gender: .male,
            height: HeightPercentiles(p3: 47.6, p10: 48.7, p25: 49.9, p50: 51.2, p75: 52.5, p90: 53.6, p97: 54.6),
            
            weight: WeightPercentiles(p3: 3.7, p10: 3.9, p25: 4.2, p50: 4.6, p75: 4.9, p90: 5.2, p97: 5.6),
            headCircumference: headCircumferencePercentile(p3: 31.9, p10: 32.7, p25: 33.4, p50: 34.3, p75: 35.2, p90: 36.0, p97: 36.8),
            bmi: BMIPercentiles(p3: 11.2, p10: 11.8, p25: 12.5, p50: 13.2, p75: 14.0, p90: 14.8, p97: 15.5)
        ),
                      GrowthReference(
            ageMonth: 1,
            gender: .male,
            height: HeightPercentiles(p3: 47.6, p10: 48.7, p25: 49.9, p50: 51.2, p75: 52.5, p90: 53.6, p97: 54.6),
            
            weight: WeightPercentiles(p3: 3.7, p10: 3.9, p25: 4.2, p50: 4.6, p75: 4.9, p90: 5.2, p97: 5.6),
            headCircumference: headCircumferencePercentile(p3: 31.9, p10: 32.7, p25: 33.4, p50: 34.3, p75: 35.2, p90: 36.0, p97: 36.8),
            bmi: BMIPercentiles(p3: 11.2, p10: 11.8, p25: 12.5, p50: 13.2, p75: 14.0, p90: 14.8, p97: 15.5)
        ),
                      GrowthReference(
            ageMonth: 1,
            gender: .male,
            height: HeightPercentiles(p3: 47.6, p10: 48.7, p25: 49.9, p50: 51.2, p75: 52.5, p90: 53.6, p97: 54.6),
            
            weight: WeightPercentiles(p3: 3.7, p10: 3.9, p25: 4.2, p50: 4.6, p75: 4.9, p90: 5.2, p97: 5.6),
            headCircumference: headCircumferencePercentile(p3: 31.9, p10: 32.7, p25: 33.4, p50: 34.3, p75: 35.2, p90: 36.0, p97: 36.8),
            bmi: BMIPercentiles(p3: 11.2, p10: 11.8, p25: 12.5, p50: 13.2, p75: 14.0, p90: 14.8, p97: 15.5)
        ),
                      GrowthReference(
            ageMonth: 1,
            gender: .male,
            height: HeightPercentiles(p3: 47.6, p10: 48.7, p25: 49.9, p50: 51.2, p75: 52.5, p90: 53.6, p97: 54.6),
            
            weight: WeightPercentiles(p3: 3.7, p10: 3.9, p25: 4.2, p50: 4.6, p75: 4.9, p90: 5.2, p97: 5.6),
            headCircumference: headCircumferencePercentile(p3: 31.9, p10: 32.7, p25: 33.4, p50: 34.3, p75: 35.2, p90: 36.0, p97: 36.8),
            bmi: BMIPercentiles(p3: 11.2, p10: 11.8, p25: 12.5, p50: 13.2, p75: 14.0, p90: 14.8, p97: 15.5)
        ),



        
    ]
}

extension GrowthReference {
    static let female: [GrowthReference] = [
        GrowthReference(
            ageMonth: 0,
            gender: .female,
            height: HeightPercentiles(p3: 47.1, p10: 48.1, p25: 49.2, p50: 50.4, p75: 51.6, p90: 52.8, p97: 54.0),
            weight: WeightPercentiles(p3: 2.7, p10: 2.9, p25: 3.1, p50: 3.3, p75: 3.5, p90: 3.8, p97: 4.0),
            headCircumference: headCircumferencePercentile(p3: 31.5, p10: 32.3, p25: 33.1, p50: 33.9, p75: 34.8, p90: 35.6, p97: 36.3),
            bmi: BMIPercentiles(p3: 11.1, p10: 11.7, p25: 12.3, p50: 13.1, p75: 13.8, p90: 14.5, p97: 15.3)
        ),
    ]
}





/*
 男童体重百分位原始数据 (WS/T 423—2022) 顺序: p3 p10 p25 p50 p75 p90 p97
 每行按年龄(月 / 岁)分行。仅整理格式，尚未结构化进代码。
 0 月 2.8 3.0 3.2 3.5 3.7 4.0 4.2
 1 月 3.7 3.9 4.2 4.6 4.9 5.2 5.6
 2 月 4.7 5.0 5.4 5.8 6.2 6.7 7.1
 3 月 5.5 5.9 6.3 6.8 7.3 7.8 8.3
 4 月 6.1 6.5 7.0 7.5 8.1 8.6 9.2
 5 月 6.6 7.0 7.5 8.0 8.6 9.2 9.8
 6 月 6.9 7.4 7.9 8.4 9.1 9.7 10.3
 7 月 7.2 7.7 8.2 8.8 9.5 10.1 10.8
 8 月 7.5 8.0 8.5 9.1 9.8 10.4 11.1
 9 月 7.7 8.2 8.7 9.4 10.1 10.8 11.5
 10 月 7.9 8.4 9.0 9.6 10.3 11.0 11.8
 11 月 8.1 8.6 9.2 9.8 10.6 11.3 12.0
 1 岁 8.3 8.8 9.4 10.1 10.8 11.5 12.3
 1 岁 1 月 8.4 9.0 9.6 10.3 11.0 11.7 12.5
 1 岁 2 月 8.6 9.2 9.7 10.5 11.2 12.0 12.8
 1 岁 3 月 8.8 9.3 9.9 10.7 11.4 12.2 13.0
 1 岁 4 月 9.0 9.5 10.1 10.9 11.7 12.4 13.3
 1 岁 5 月 9.1 9.7 10.3 11.1 11.9 12.7 13.5
 1 岁 6 月 9.3 9.9 10.5 11.3 12.1 12.9 13.8
 1 岁 7 月 9.5 10.1 10.7 11.5 12.3 13.2 14.0
 1 岁 8 月 9.7 10.3 10.9 11.7 12.6 13.4 14.3
 1 岁 9 月 9.8 10.5 11.1 11.9 12.8 13.7 14.6
 1 岁 10 月 10.0 10.6 11.3 12.2 13.0 13.9 14.8
 1 岁 11 月 10.2 10.8 11.5 12.4 13.3 14.2 15.1
 2 岁 10.4 11.0 11.7 12.6 13.5 14.4 15.4
 2 岁 3 月 10.8 11.5 12.2 13.1 14.1 15.1 16.1
 2 岁 6 月 11.2 12.0 12.7 13.7 14.7 15.7 16.7
 2 岁 9 月 11.6 12.4 13.2 14.2 15.2 16.3 17.4
 3 岁 12.0 12.8 13.6 14.6 15.8 16.9 18.0
 3 岁 3 月 12.4 13.2 14.1 15.2 16.3 17.5 18.7
 3 岁 6 月 12.8 13.7 14.6 15.7 16.9 18.1 19.4
 3 岁 9 月 13.2 14.1 15.1 16.2 17.5 18.7 20.1
 4 岁 13.6 14.5 15.5 16.7 18.1 19.4 20.8
 4 岁 3 月 14.0 15.0 16.0 17.3 18.7 20.1 21.6
 4 岁 6 月 14.5 15.4 16.5 17.9 19.3 20.8 22.4
 4 岁 9 月 14.9 15.9 17.1 18.4 20.0 21.6 23.3
 5 岁 15.3 16.4 17.6 19.1 20.7 22.4 24.2
 5 岁 3 月 15.8 16.9 18.1 19.7 21.4 23.2 25.1
*/