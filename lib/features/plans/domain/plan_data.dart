/// The 3 UI tabs. Note: per your confirmation, "moderate" merges the PDF's
/// "Health Plus" tier AND its separate "Health Advance" tier into one tab
/// (3 cards) — there's no 4th tab.
enum PlanTierKey { basic, moderate, advance }

/// A single line shown as a green-checkmark bullet on the card
/// ("Glucose & HbA1c"), as opposed to [PackageOption.cardParagraph] which
/// some cards use instead (a single sentence, no bullets) — both forms
/// appear in the mockups, driven by which the source data used.
class CardBullet {
  const CardBullet(this.text);
  final String text;
}

/// Everything needed to render one package — both the compact card (Plans
/// tab) and the full detail page (after "View Details" / "Select Plan").
class PackageOption {
  const PackageOption({
    required this.cardTitle,
    required this.fullName,
    required this.provider,
    required this.priceRupees,
    required this.isRecommended,
    this.cardBullets,
    this.cardParagraph,
    required this.matchingParameters,
    required this.matchCount,
    required this.ageAndFrequency,
    required this.demographicImpact,
    this.link,
  }) : assert(
          (cardBullets != null) ^ (cardParagraph != null),
          'A package shows either a bullet list or a paragraph on its card, not both/neither.',
        );

  /// Short title shown on the card (e.g. "Comprehensive Gold").
  final String cardTitle;

  /// Full commercial name from the source package sheet (e.g.
  /// "Comprehensive Gold Package with ECG & USG Whole Abdomen"), shown on
  /// the detail page.
  final String fullName;

  final String provider;
  final int priceRupees;
  final bool isRecommended;

  /// Card body — exactly one of these is set per package.
  final List<String>? cardBullets;
  final String? cardParagraph;

  /// Detail-page-only fields, sourced from the package sheet.
  final List<String> matchingParameters;
  final int matchCount;
  final String ageAndFrequency;
  final String demographicImpact;

  /// Booking URL for the "Link" row on the detail page. Null/empty until
  /// the real URLs are supplied — the row renders as a disabled placeholder
  /// in that case (see `link_row.dart`).
  final String? link;
}

/// One tab's worth of content: the header (icon/title/description) plus
/// its package cards.
class PlanTierData {
  const PlanTierData({
    required this.key,
    required this.tabLabel,
    required this.titleLine,
    required this.description,
    required this.iconAssetPath,
    required this.packages,
  });

  final PlanTierKey key;

  /// "Basic" / "Moderate" / "Advance" — the tab label itself.
  final String tabLabel;

  /// "Moderate: Health Plus" — the heading inside the wrapper card.
  final String titleLine;
  final String description;
  final String iconAssetPath;
  final List<PackageOption> packages;
}
