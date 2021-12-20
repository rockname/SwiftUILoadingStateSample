import SwiftUI

struct TimelineView: View {
    @StateObject private var viewModel: TimelineViewModel
    @Environment(\.refresh) private var refresh

    init(viewModel: TimelineViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        Group {
            switch viewModel.loadingAtFirstState {
            case .idle: VStack {}
            case .loading:
                List {
                    ForEach(viewModel.placeholder) { post in
                        PostView(post: post)
                            .padding(.vertical, 8)
                            .listRowSeparator(.hidden)
                    }
                }
                .listStyle(.plain)
                .redacted(reason: .placeholder)
                .modifier(EaseInOutAnimation())
                .disabled(true)

            case .failed:
                HStack {
                    Spacer()
                    VStack(spacing: 8) {
                        Text("Failed to load your timeline")
                            .font(.body)
                            .foregroundColor(Color(uiColor: .secondaryLabel))
                        Button {
                            viewModel.onLoadingAtFirstRetry()
                        } label: {
                            Text("Try again")
                                .foregroundColor(Color(uiColor: .link))
                        }
                    }
                    Spacer()
                }

            case .loaded:
                if viewModel.timeline.isEmpty {
                    HStack {
                        Spacer()
                        VStack(spacing: 8) {
                            Text("There are no posts yet")
                                .font(.body)
                                .foregroundColor(Color(uiColor: .secondaryLabel))
                            Button {
                                viewModel.onPostButtonTapped()
                            } label: {
                                Text("Let's post!")
                                    .foregroundColor(Color(uiColor: .link))
                            }
                        }
                        Spacer()
                    }
                } else {
                    List {
                        ForEach(viewModel.timeline) { post in
                            PostView(post: post)
                                .padding(.vertical, 8)
                                .listRowSeparator(.hidden)
                                .onAppear {
                                    viewModel.onPostAppear(post: post)
                                }
                        }

                        switch viewModel.loadingOlderState {
                        case .idle, .loaded: EmptyView()
                        case .loading:
                            HStack {
                                Spacer()
                                ProgressView()
                                Spacer()
                            }
                        case .failed:
                            HStack {
                                Spacer()
                                VStack(spacing: 8) {
                                    Text("Failed to load your timeline")
                                        .font(.body)
                                        .foregroundColor(Color(uiColor: .secondaryLabel))
                                    Button {
                                        viewModel.onLoadingOlderRetry()
                                    } label: {
                                        Text("Try again")
                                            .foregroundColor(Color(uiColor: .link))
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                }
                                Spacer()
                            }
                        }
                    }
                    .listStyle(.plain)
                    .refreshable {
                        await viewModel.onRefresh()
                    }
                    .snackbar(configuration: $viewModel.snackbarConfiguration)
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            viewModel.onAppear()
        }
    }
}
