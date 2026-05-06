//
//  SectionHeaderButton.swift
//  Zebra
//
//  Created by Adam Demasi on 7/3/2022.
//  Copyright © 2022 Zebra Team. All rights reserved.
//

import UIKit

class SectionHeaderButton: UIButton {

	var normalBackgroundColor: UIColor? = .systemGray5 {
		didSet {
			backgroundColor = normalBackgroundColor
		}
	}

	var highlightBackgroundColor: UIColor? = .systemGray2

	convenience init(title: String, image: UIImage? = nil, target: Any? = nil, action: Selector? = nil) {
		self.init(frame: .zero)

		translatesAutoresizingMaskIntoConstraints = false
		backgroundColor = normalBackgroundColor
		clipsToBounds = true
		layer.cornerCurve = .continuous
		accessibilityLabel = title

		if let action = action {
			addTarget(target, action: action, for: .touchUpInside)
		}

		addTarget(self, action: #selector(didTouchDown), for: [.touchDown, .touchDragEnter])
		addTarget(self, action: #selector(didTouchUp), for: [.touchUpInside, .touchUpOutside, .touchDragExit, .touchCancel])

		let font = UIFont.preferredFont(forTextStyle: .footnote, weight: .bold)
		if let image = image {
			var config = UIButton.Configuration.plain()
			config.baseForegroundColor = tintColor
			config.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(
				pointSize: font.pointSize,
				weight: .bold,
				scale: .medium
			)
			config.image = image
			configuration = config
		} else {
			var titleAttribute = AttributeContainer()
			titleAttribute.font = font
			var config = UIButton.Configuration.plain()
			config.baseForegroundColor = tintColor
			config.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 12, bottom: 0, trailing: 12)
			config.attributedTitle = AttributedString(title.localizedUppercase, attributes: titleAttribute)
			configuration = config
		}

		// Background changes are handled via didTouchDown/didTouchUp;
		// the configuration update handler keeps the foreground colour in sync with tintColor.
		configurationUpdateHandler = { [weak self] button in
			var c = button.configuration ?? UIButton.Configuration.plain()
			c.baseForegroundColor = self?.tintColor
			button.configuration = c
		}

		NSLayoutConstraint.activate([
			self.widthAnchor.constraint(greaterThanOrEqualTo: self.heightAnchor),
			self.heightAnchor.constraint(equalToConstant: 30)
		])
	}

	private override init(frame: CGRect) {
		super.init(frame: frame)
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func layoutSubviews() {
		super.layoutSubviews()

		layer.cornerRadius = frame.size.height / 2
	}

	@objc private func didTouchDown() {
		guard let highlightBackgroundColor = highlightBackgroundColor else {
			return
		}
		backgroundColor = highlightBackgroundColor
	}

	@objc private func didTouchUp() {
		guard let normalBackgroundColor = normalBackgroundColor else {
			return
		}
		backgroundColor = normalBackgroundColor
	}

	override func tintColorDidChange() {
		super.tintColorDidChange()
		setNeedsUpdateConfiguration()
	}

}
