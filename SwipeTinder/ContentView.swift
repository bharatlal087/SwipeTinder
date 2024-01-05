//
//  ContentView.swift
//  SwipeTinder
//
//  Created by Bharat Lal on 04/01/24.
//

import SwiftUI

struct ContentView: View {
    @GestureState private var dragState: DragState = .inactive
    @State private var lastIndex = 1
    @State private var removalTransition = AnyTransition.trailingBottom

    private let dragThreshold: CGFloat = 80.0

    var body: some View {
        VStack {
            TopBarView()

            ZStack {
                ForEach(cardViews) { view in
                    view
                        .zIndex(isTopCard(cardView: view) ? 1 : 0)
                        .overlay {
                            actionImage(for: view)
                        }
                        .offset(
                            x: isTopCard(cardView: view) ? dragState.translation.width : 0,
                            y: isTopCard(cardView: view) ? dragState.translation.height : 0
                        )
                        .scaleEffect(
                            dragState.isDragging && isTopCard(cardView: view) ? 0.95 : 1.0
                        )
                        .rotationEffect(
                            Angle(degrees: isTopCard(cardView: view) ? Double(dragState.translation.width / 10) : 0)
                        )
                        .animation(.interpolatingSpring(stiffness: 180, damping: 100), value: dragState.translation)
                        .transition(removalTransition)
                        .gesture(LongPressGesture(minimumDuration: 0.01)
                            .sequenced(before: DragGesture())
                            .updating($dragState, body: { value, state, _ in
                                switch value {
                                case .first(true):
                                    state = .pressing
                                case .second(true, let drag):
                                    state = .dragging(translation: drag?.translation ?? .zero)
                                default:
                                    break
                                }

                            })
                            .onChanged { value in
                                guard case .second(true, let drag?) = value else {
                                    return
                                }

                                if drag.translation.width < -dragThreshold {
                                    removalTransition = .leadingBottom
                                }

                                if drag.translation.width > dragThreshold {
                                    removalTransition = .trailingBottom
                                }
                            }
                            .onEnded { value in
                                guard case .second(true, let drag?) = value else {
                                    return
                                }

                                if drag.translation.width < -dragThreshold ||
                                    drag.translation.width > dragThreshold
                                {
                                    self.moveCard()
                                }
                            }
                        )
                }
            }

            Spacer(minLength: 20)
            BottomBarView()
                .opacity(dragState.isDragging ? 0.0 : 1.0)
                .animation(.default, value: dragState.isDragging)
        }
        .padding()
    }

    @State private var cardViews: [CardView] = {
        var views = [CardView]()

        for index in 0 ..< 2 {
            views.append(CardView(image: trips[index].image, title: trips[index].destination))
        }

        return views
    }()
    
    private func actionImage(for view: CardView) -> some View {
        ZStack {
            Image(systemName: "x.circle")
                .foregroundStyle(Color.white)
                .font(.system(size: 100))
                .opacity(
                    dragState.translation.width < -dragThreshold && isTopCard(cardView: view) ? 1.0 : 0
                )

            Image(systemName: "heart.circle")
                .foregroundStyle(Color.white)
                .font(.system(size: 100))
                .opacity(
                    dragState.translation.width > dragThreshold && isTopCard(cardView: view) ? 1.0 : 0
                )
        }
    }
    
    private func isTopCard(cardView: CardView) -> Bool {
        guard let index = cardViews.firstIndex(where: { $0.id == cardView.id }) else {
            return false
        }

        return index == 0
    }

    private func moveCard() {
        cardViews.removeFirst()

        lastIndex += 1
        let trip = trips[lastIndex % trips.count]

        let newCardView = CardView(image: trip.image, title: trip.destination)

        cardViews.append(newCardView)
    }
}

#Preview {
    ContentView()
}
