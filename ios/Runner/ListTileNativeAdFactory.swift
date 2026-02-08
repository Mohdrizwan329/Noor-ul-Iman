import google_mobile_ads

class ListTileNativeAdFactory: FLTNativeAdFactory {

    func createNativeAd(
        _ nativeAd: GADNativeAd,
        customOptions: [String: Any]? = nil
    ) -> GADNativeAdView {

        let nativeAdView = GADNativeAdView()
        nativeAdView.translatesAutoresizingMaskIntoConstraints = false

        // Container stack
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 12
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.layoutMargins = UIEdgeInsets(top: 12, left: 16, bottom: 12, right: 16)
        stackView.isLayoutMarginsRelativeArrangement = true

        // Icon
        let iconView = UIImageView()
        iconView.translatesAutoresizingMaskIntoConstraints = false
        iconView.contentMode = .scaleAspectFit
        iconView.clipsToBounds = true
        iconView.widthAnchor.constraint(equalToConstant: 48).isActive = true
        iconView.heightAnchor.constraint(equalToConstant: 48).isActive = true

        // Text stack
        let textStack = UIStackView()
        textStack.axis = .vertical
        textStack.spacing = 4

        // Headline
        let headlineLabel = UILabel()
        headlineLabel.font = UIFont.boldSystemFont(ofSize: 14)
        headlineLabel.textColor = UIColor(red: 0.04, green: 0.36, blue: 0.21, alpha: 1.0)
        headlineLabel.numberOfLines = 1

        // Body
        let bodyLabel = UILabel()
        bodyLabel.font = UIFont.systemFont(ofSize: 12)
        bodyLabel.textColor = UIColor(red: 0.42, green: 0.50, blue: 0.45, alpha: 1.0)
        bodyLabel.numberOfLines = 2

        // Ad badge
        let adBadge = UILabel()
        adBadge.text = "Ad"
        adBadge.font = UIFont.systemFont(ofSize: 10)
        adBadge.textColor = .white
        adBadge.backgroundColor = UIColor(red: 0.04, green: 0.36, blue: 0.21, alpha: 1.0)
        adBadge.textAlignment = .center
        adBadge.translatesAutoresizingMaskIntoConstraints = false
        adBadge.widthAnchor.constraint(equalToConstant: 24).isActive = true

        textStack.addArrangedSubview(headlineLabel)
        textStack.addArrangedSubview(bodyLabel)

        stackView.addArrangedSubview(iconView)
        stackView.addArrangedSubview(textStack)
        stackView.addArrangedSubview(adBadge)

        nativeAdView.addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: nativeAdView.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: nativeAdView.bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: nativeAdView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: nativeAdView.trailingAnchor),
        ])

        // Set ad views
        nativeAdView.headlineView = headlineLabel
        nativeAdView.bodyView = bodyLabel
        nativeAdView.iconView = iconView

        headlineLabel.text = nativeAd.headline
        bodyLabel.text = nativeAd.body

        if let icon = nativeAd.icon {
            iconView.image = icon.image
            iconView.isHidden = false
        } else {
            iconView.isHidden = true
        }

        nativeAdView.nativeAd = nativeAd
        return nativeAdView
    }
}
