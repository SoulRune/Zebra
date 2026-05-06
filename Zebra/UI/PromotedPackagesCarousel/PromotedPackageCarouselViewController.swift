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
	// Set to true on the main thread when PLDatabaseRefreshNotification fires.
	// updateBannerItems() will not spawn any Tasks until this is true, which
	// prevents concurrent APT-cache access before PLPackageManager.import() completes.
	private var isDatabaseLoaded = false

	override init() {
		super.init()
		errorText = .localize("Featured Unavailable")

		// Listen for the database-ready notification so we can populate banners
		// exactly once the APT cache has been fully loaded on the main thread.
		databaseObserver = NotificationCenter.default.addObserver(
			forName: PackageManager.databaseDidRefreshNotification,
			object: nil,
			queue: .main
		) { [weak self] _ in
			guard let self = self else { return }
			self.isDatabaseLoaded = true
			if !self.bannerItems.isEmpty {
				self.updateBannerItems()
			}
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

		// Do not access the APT cache until the database has been fully loaded.
		// isDatabaseLoaded is set on the main thread by the databaseDidRefreshNotification
		// observer above, which fires only after PLPackageManager.import() completes.
		// Accessing PackageManager.shared.packages before that point would race with
		// the main-thread import call and cause a use-after-free inside pkgDepCache.
		guard isDatabaseLoaded, !bannerItems.isEmpty else { return }

		Task.detached {
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
