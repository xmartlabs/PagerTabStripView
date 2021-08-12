//
//  ContentView.swift
//  Shared
//
//  Copyright © 2021 Xmartlabs SRL. All rights reserved.
//

import SwiftUI
import PagerTabStripView

let primaryColor = Color(red: 237/255.0, green: 26/255.0, blue: 97/255.0)
let secondaryColor = Color(red: 234/255.0, green: 234/255.0, blue: 234/255.0, opacity: 0.8)

struct CustomButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        return configuration.label
            .frame(width: 250)
            .foregroundColor(.white)
            .padding()
            .background(primaryColor)
            .cornerRadius(8)
    }
}

struct ContentView: View {
    @State private var showingTwitter = false
    @State private var showingInstagram = false
    @State private var showingYoutube = false
    @State private var showingSegmented = false
    @State private var showingBar = false
    
    var body: some View {
        VStack(spacing: 50) {
            VStack{
                Button(action: { showingTwitter.toggle() }, label: {
                    VStack {
                        Text("Fixed style")
                            .font(.body)
                        Text("Only label")
                            .font(.subheadline)
                            .foregroundColor(secondaryColor)
                    }
                })
                .buttonStyle(CustomButtonStyle())
                .sheet(isPresented: $showingTwitter) {
                    TwitterView()
                }

                Button(action: { showingInstagram.toggle() }, label: {
                    VStack {
                        Text("Fixed style")
                            .font(.body)
                        Text("Only icon")
                            .font(.subheadline)
                            .foregroundColor(secondaryColor)
                    }
                })
                .buttonStyle(CustomButtonStyle())
                .sheet(isPresented: $showingInstagram) {
                    InstagramView()
                }

                Button(action: { showingYoutube.toggle() }, label: {
                    VStack {
                        Text("Fixed style")
                            .font(.body)
                        Text("Label and icon")
                            .font(.subheadline)
                            .foregroundColor(secondaryColor)
                    }
                })
                .buttonStyle(CustomButtonStyle())
                .sheet(isPresented: $showingYoutube) {
                    YoutubeView()
                }
            }
            Button(action: { showingSegmented.toggle() }, label: {
                VStack {
                    Text("Segmented style")
                        .font(.body)
                }
            })
            .buttonStyle(CustomButtonStyle())
            .sheet(isPresented: $showingSegmented) {
                SegmentedView()
            }

            Button(action: { showingBar.toggle() }, label: {
                VStack {
                    Text("Bar style")
                        .font(.body)
                }
            })
            .buttonStyle(CustomButtonStyle())
            .sheet(isPresented: $showingBar) {
                BarStyleView()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
