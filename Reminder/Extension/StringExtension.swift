extension String {
    var localized: String {
        Localizer.localizedString(for: self)
    }
}
