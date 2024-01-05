//
//  TopBarView.swift
//  SwipeTinder
//
//  Created by Bharat Lal on 04/01/24.
//

import SwiftUI

struct TopBarView: View {
    var body: some View {
        HStack {
            Image(systemName: "line.horizontal.3")
                .font(.system(size: 30))
            Spacer()
            Image(systemName: "mappin.and.ellipse")
                .font(.system(size: 35))
            Spacer()
            Image(systemName: "heart.circle.fill")
                .font(.system(size: 30))
        }
        .padding()
    }

}

#Preview {
    TopBarView()
}


struct BottomBarView: View {
    var body: some View {
        HStack {
            Image(systemName: "xmark")
                .font(.system(size: 30))
                .foregroundStyle(Color.black)
            
            Spacer()
            
            Button {
                // Book the trip
            } label: {
                Text("BOOK TRIP")
                    .font(.system(.subheadline, design: .rounded))
                    .bold()
                    .foregroundColor(.white)
                    .padding(.horizontal, 35)
                    .padding(.vertical, 15)
                    .background(.black)
                    .cornerRadius(10)
            }
            .padding(.horizontal, 20)
            
            Spacer()
            Image(systemName: "heart")
                .font(.system(size: 30))
                .foregroundStyle(Color.black)
        }
        .padding()
    }

}

#Preview {
    BottomBarView()
}
