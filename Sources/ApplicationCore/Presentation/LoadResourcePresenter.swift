//
//  Copyright © 2021 Jesús Alfredo Hernández Alarcón. All rights reserved.
//

import Foundation

public protocol ResourceView {
    associatedtype ResourceViewModel
    func display(_ viewModel: ResourceViewModel)
}

public final class LoadResourcePresenter<Resource, View: ResourceView> {
    public typealias Mapper = (Resource) throws -> View.ResourceViewModel
    private var resourceView: View
    private var loadingView: ResourceLoadingView?
    private var errorView: ResourceErrorView?
    private var mapper: Mapper

    public init(resourceView: View, loadingView: ResourceLoadingView?, errorView: ResourceErrorView?, mapper: @escaping Mapper) {
        self.resourceView = resourceView
        self.loadingView = loadingView
        self.errorView = errorView
        self.mapper = mapper
    }

    public static var loadError: String {
        NSLocalizedString(
            "generic_connection_error",
            tableName: "Shared",
            bundle: .module,
            comment: "Error message displayed when we can't load the resource."
        )
    }

    public func didStartLoading() {
        errorView?.display(.noError)
        loadingView?.display(ResourceLoadingViewModel(isLoading: true))
    }

    public func didFinishLoading(with resource: Resource) {
        do {
            resourceView.display(try mapper(resource))
            loadingView?.display(ResourceLoadingViewModel(isLoading: false))
        } catch {
            didFinishLoading(with: error)
        }
    }

    public func didFinishLoading(with _: Error) {
        errorView?.display(.error(message: Self.loadError))
        loadingView?.display(ResourceLoadingViewModel(isLoading: false))
    }
}
