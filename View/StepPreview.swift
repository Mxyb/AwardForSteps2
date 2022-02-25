//
//  StepPreview.swift
//  AwardForSteps2
//
//  Created by Max Baker on 25/02/2022.
//

import SwiftUI
import HealthKit



struct StepPreview: View {
    
    private var healthStore: HealthStore?
    
    @State private var steps: [Step] = [Step]()
    
    @State private var listSteps: [StepList] = [StepList]()
    
    @State private var awardSteps: [StepAward] = [StepAward]()
    
    
    init() {
        healthStore = HealthStore()
    }
    
    
    private func updateUIFromStatistics(_ statisticsCollection: HKStatisticsCollection) {
        
        let listStartDate = Calendar.current.date(byAdding: .day, value: -7, to: Date())!
        let startDate = Date()
        let endDate = Date()
        
        statisticsCollection.enumerateStatistics(from: startDate, to: endDate) { (statistics, stop) in
            
            let count = statistics.sumQuantity()?.doubleValue(for: .count())
            
            let step = Step(count: Int(count ?? 0), date: statistics.startDate)
            steps.append(step)
        }
            
            statisticsCollection.enumerateStatistics(from: listStartDate, to: endDate) { (statistics, stop) in
                
            let count2 = statistics.sumQuantity()?.doubleValue(for: .count())
            
            let stepList = StepList(count: Int(count2 ?? 0), date: statistics.startDate)
                listSteps.append(stepList)
            
            }
        
        statisticsCollection.enumerateStatistics(from: listStartDate, to: endDate) { (statistics, stop) in
            
            let count3 = statistics.sumQuantity()?.doubleValue(for: .count())
            
            let awardStep = StepAward(count: Int(count3 ?? 0), date: statistics.startDate)
            awardSteps.append(awardStep)
        }
    }
    
    var body: some View {
        
        
    NavigationView {
        
        ScrollView {
            
            LazyVStack{
                
            
            ForEach(steps, id: \.id) { step in
                
                VStack(spacing: 15){
                    Text("\(step.count)")
                        .font(.custom(customFont, size: 100))
                        .fontWeight(.semibold)
                        .multilineTextAlignment(.center)
                        .opacity(5)
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 200, height: 200)
                        .padding(.bottom, -45)

                    HStack{
                        
                        Text("Steps Today")
                            .font(.custom(customFont, size: 40))
                            .multilineTextAlignment(.center)
                    }
                    
                    .frame(maxWidth: .infinity, alignment: .center)
                   
            }
              
                        
        }
            
        .navigationTitle("Today's Steps")
        .padding([.horizontal,.bottom])
     
                
                
                CustomNavigationLink(title: "Steps (Last 7 Days)") {
                
                
                    
                    List(listSteps, id: \.id) { stepList in
                    VStack(alignment: .leading){
                        Text("\(stepList.count)")
                            .font(.custom(customFont, size: 40))
                            .fontWeight(.semibold)
                            
                        
                            
                        Text(stepList.date, style: .date)
                            .opacity(0.5)
                            .font(.custom(customFont, size: 20))
                            .foregroundColor(.cyan)
                            .padding(1)
                        
                    }
                    .listRowBackground(Color.clear)
                  
                }
                .background(Image("GreenBG"))
                .navigationTitle("Steps (last 7 days)")
                .padding()
            
                }
                
        }
            .padding()
        
            
            ForEach(steps, id: \.id) { awardStep in
                
                LazyVStack(spacing: 15) {
                    
                    let stepCoin = awardStep.count / 1000
                    Text("\(stepCoin)")
                        .font(.custom(customFont, size: 100))
                        .fontWeight(.semibold)
                        .multilineTextAlignment(.center)
                        .opacity(5)
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 200, height: 200)
                        .padding(.bottom, -45)
                    
                    HStack {
                        
                        Text("Coins earned")
                            .font(.custom(customFont, size: 40))
                            .multilineTextAlignment(.center)
                    }
                    
                    .frame(maxWidth: .infinity, alignment: .center)
                }
            }
        
    }
        .background(
        
            Image("GreenBG")
                .resizable()
                .ignoresSafeArea()
            
        )
        
    
    }

    .onAppear {
        if let healthStore = healthStore {
            healthStore.requestAuthorization { success in
                if success {
                    healthStore.calculateSteps { statisticsCollection in
                        if let statisticsCollection = statisticsCollection {
                            // update the UI
                            updateUIFromStatistics(statisticsCollection)
                        }
                    }
                }
            }
        }
    }
        
    }
    
}

// Avoiding New Structs...
@ViewBuilder
func CustomNavigationLink<Detail: View>(title: String,@ViewBuilder content: @escaping ()->Detail)->some View{
    
    
    NavigationLink {
        content()
    } label: {
        
        HStack{
            
            Text(title)
                .font(.custom(customFont, size: 17))
                .fontWeight(.semibold)
            
            Spacer()
            
            Image(systemName: "chevron.right")
        }
        .foregroundColor(.black)
        .padding()
        .background(
        
            Color.white
                .cornerRadius(12)
        )
        .padding(.horizontal)
        .padding(.top,10)
    }
}
