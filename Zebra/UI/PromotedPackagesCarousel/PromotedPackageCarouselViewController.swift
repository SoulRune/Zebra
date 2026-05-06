//
//  PromotedPackageCarouselViewController.swift
//  Zebra
//
//  Created by MidnightChips on 3/8/22.
//  Copyright © 2022 Zebra Team. All rights reserved.
//

import UIKit
import Plains

class PromotedPackagesCarouselViewController: CarouselViewController {

	var bannerItems = [PromotedPackageBanner]() {
		didSet { updateBannerItems() }
	}

	private var packages = [Package]()
	private var databaseObserver: NSObjectProtocol?

	override init() {
		super.init()
		errorText = .localize("Featured Unavailable")

		// Retry banner resolution once the package database is loaded.
		databaseObserver = NotificationCenter.default.addObserver(
			forName: PackageManager.databaseDidRefreshNotification,
			object: nil,
			queue: .main
		) { [weak self] _ in
			guard let self = self, !self.bannerItems.isEmpty else { return }
			self.updateBannerItems()
		}
	}

	deinit {
		if let observer = databaseObserver {
			NotificationCenter.default.removeObserver(observer)
		}
	}

	@available(*, unavailable)
	required init?(coder _: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	private func updateBannerItems() {
		let bannerItems = self.bannerItems

		Task.detached {
			// Guard: if the package database hasn't been loaded yet, wait for databaseDidRefreshNotification.
			guard !PackageManager.shared.packages.isEmpty else {
				return
			}
			let packages = bannerItems.map { PackageManager.shared.package(withIdentifier: $0.package) }
			let items = zip(bannerItems, packages).compactMap { item, package -> CarouselItem? in
				guard let package = package else {
					return nil
				}
				return CarouselItem(title: item.title,
														subtitle: nil,
														displayTitle: item.displayText ?? true,
														url: package.depictionURL ?? package.homepageURL,
														imageURL: item.url)
			}

			await MainActor.run {
				if items.isEmpty {
					// Always stop the spinner when we have a definitive empty result.
					self.isLoading = false
					if !bannerItems.isEmpty {
						// Had banners but none matched known packages.
						self.errorText = .localize("No Featured Packages")
						self.isError = true
					}
				}
				self.packages = packages.compact()
				self.items = items
			}
		}
	}

}

extension PromotedPackagesCarouselViewController {

	override func collectionView(_: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		let item = bannerItems[indexPath.item]
		Task.detached {
			if let viewController = await PackageMenuCommands.packageViewController(identifier: item.package, sender: self) {
				await self.parent?.navigationController?.pushViewController(viewController, animated: true)
			}
		}
	}

	override func collectionView(_: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point _: CGPoint) -> UIContextMenuConfiguration? {
		let package = packages[indexPath.item]
		let cell = collectionView.cellForItem(at: indexPath)!
		return PackageMenuCommands.contextMenuConfiguration(for: package,
																								 identifier: indexPath as NSCopying,
																								 viewController: self,
																								 sourceView: cell)
	}

}
