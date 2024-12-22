//
//  Imageviewer.swift
//  MultipleImageViewer
//
//  Created by Benji Loya on 22.12.2024.
//

import SwiftUI

struct ImageViewer<Content: View, Overlay: View>: View { // , Overlay: View
    /// Config
    var config = Config()
    @ViewBuilder var content: Content
    @ViewBuilder var overlay: Overlay
    /// Giving updates to the main view
    var updates: (Bool, AnyHashable?) -> () = { _, _ in }
    /// View Properties
    @State private var isPresented: Bool = false
    @State private var activeTabID: Subview.ID?
    @State private var transitionSource: Int = 0
    @Namespace private var animation
    
    var body: some View {
        Group(subviews: content) { collection in
            LazyVGrid(columns: Array(repeating: GridItem(spacing: config.spacing), count: 2), spacing: config.spacing) {
                /// Only displaying the first four images, and the remaining ones showing a count (like + 4) at the fourth image, similar to the X (twitter) app
                let remainingCount = max(collection.count - 4, 0)
                ForEach(collection.prefix(4)) { item in
                    let index = collection.index(item.id)
                    GeometryReader {
                        let size = $0.size
                        
                        item
                            .aspectRatio(contentMode: .fill)
                            .frame(width: size.width, height: size.height)
                            .clipShape(.rect(cornerRadius: config.cornerRadius))
                        
                        // && remainingCount > 0
                        if collection.prefix(4).last?.id == item.id {
                            RoundedRectangle(cornerRadius: config.cornerRadius)
                                .fill(.black.opacity(0.33))
                                .overlay {
                                    Text("+\(remainingCount)")
                                        .font(.largeTitle)
                                        .fontWeight(.semibold)
                                        .foregroundStyle(.white)
                                }
                        }
                    }
                    .frame(height: config.height)
                    .onTapGesture {
                        /// For opening the selected image in the detail tab view
                        activeTabID = item.id
                        /// For opening navigation detail view
                        isPresented = true
                        /// For Zoom Transition
                        transitionSource = index
                    }
                    .matchedTransitionSource(id: index, in: animation) { config in
                        config
                            .clipShape(.rect(cornerRadius: self.config.cornerRadius))
                    }
                    
                }
            }
            .navigationDestination(isPresented: $isPresented) {
                TabView(selection: $activeTabID) {
                    ForEach(collection) { item in
                        item
                            .aspectRatio(contentMode: .fit)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .tag(item.id)
                    }
                }
                .tabViewStyle(.page)
                .background {
                    Rectangle()
                        .fill(.black)
                        .ignoresSafeArea()
                }
                .overlay {
                    overlay
                }
                .navigationTransition(.zoom(sourceID: transitionSource, in: animation))
                .toolbarVisibility(.hidden, for: .navigationBar)
              
            }
            /// Updating transitionSource when tab item get's changed
            .onChange(of: activeTabID) { oldValue, newValue in
                /// Consider this example: ehn the tab view at detail view is at index 6 or 7 and when it dismisses, the zoom transition won't have any effect because there's no matchedTransitionSource for that index. therefore, indexes greater than 3 will always have a transition ID of 3
                transitionSource = min(collection.index(newValue), 3)
                sendUpdate(collection, id: newValue)
            }
            .onChange(of: isPresented) { oldValue, newValue in
                sendUpdate(collection, id: activeTabID)
            }
        }
    }
    
    private func sendUpdate(_ collection: SubviewsCollection, id: Subview.ID?) {
        if let viewID = collection.first(where: { $0.id == id })?.containerValues.activeViewID {
            updates(isPresented, viewID)
        }
    }
    
    struct Config {
        var height: CGFloat = 150
        var cornerRadius: CGFloat = 15
        var spacing: CGFloat = 10
    }
}

/// To retrieve the current active ID, we can utilize container values to pass the ID to the view and then extract it from the subview
extension ContainerValues {
    @Entry var activeViewID: AnyHashable?
}

#Preview {
    ContentView()
}

extension SubviewsCollection {
    func index(_ id: SubviewsCollection.Element.ID?) -> Int {
        firstIndex(where: { $0.id == id }) ?? 0
    }
}
