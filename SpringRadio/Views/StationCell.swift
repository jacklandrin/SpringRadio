//
//  StationCell.swift
//  SpringRadio
//
//  Created by jack on 2020/4/7.
//  Copyright © 2020 jack. All rights reserved.
//

import SwiftUI

struct StationCell: View {
    @EnvironmentObject var item : RadioStationPlayable
    
    var body: some View {
        HStack{
            Image(item.radioItem.imageName).resizable().frame(width:40,height:40).fixedSize()
            Text(item.radioItem.title)
            Spacer()
            Text("▶️").opacity(item.isPlaying ?  1 : 0)
        }
    }
}

struct StationCell_Previews: PreviewProvider {
    static let items = RadioItems()
    static var previews: some View {
        StationCell().environmentObject(items.values[0]).previewLayout(.fixed(width: UIScreen.main.bounds.width, height: 44))
    }
}
