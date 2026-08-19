import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../domain/plan_data.dart';
import '../domain/plan_repository.dart';

/// TODO(backend-integration): replace with `ApiPlanRepository` once a
/// packages endpoint exists. Card copy is verbatim from the 3 screenshots;
/// `link` values are the real booking URLs supplied directly.
class MockPlanRepository implements PlanRepository {
  @override
  Future<List<PlanTierData>> fetchTiers() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return [_basic, _moderate, _advance];
  }

  static const _basic = PlanTierData(
    key: PlanTierKey.basic,
    tabLabel: 'Basic',
    titleLine: 'Basic: Health Foundation',
    description: 'Evaluates essential blood health, immediate blood sugar, and core lipid balance.',
    iconAssetPath: 'assets/icons/basic.png',
    packages: [
      PackageOption(
        cardTitle: 'Heart Day Special',
        fullName: 'Heart Day Special - Advance With ECG',
        provider: 'Redcliffe Labs',
        priceRupees: 999,
        isRecommended: false,
        cardBullets: [
          'Fasting Glucose & HbA1c',
          'Total Cholesterol, LDL, HDL, Triglycerides',
          'eGFR / Creatinine & ECG',
        ],
        matchingParameters: [
          'Fasting Glucose',
          'HbA1c',
          'Total Cholesterol',
          'LDL',
          'HDL',
          'Triglycerides',
          'TC/HDL',
          'eGFR / Creatinine',
          'ECG',
        ],
        matchCount: 9,
        ageAndFrequency: '18–40+ · 1 year',
        demographicImpact: 'Gender: Creatinine baseline is higher in males due to muscle mass. HDL targets differ '
            'for pre-menopausal females. Age: ECG interpretations and baselines shift with age-related heart '
            'changes.',
        link: 'https://redcliffelabs.com/indore/bhawarkuan/package/heart-day-special-advance-ecg',
      ),
      PackageOption(
        cardTitle: 'Good Health Silver',
        fullName: 'Good Health Silver Package',
        provider: 'Tata 1mg',
        priceRupees: 749,
        isRecommended: false,
        cardBullets: [
          'Fasting Plasma Glucose',
          'Lipid Profile & TC/HDL Ratio',
          'eGFR / Creatinine',
        ],
        matchingParameters: [
          'Fasting Plasma Glucose',
          'Total Cholesterol',
          'LDL',
          'HDL',
          'Triglycerides',
          'TC/HDL Ratio',
          'eGFR / Creatinine',
        ],
        matchCount: 7,
        ageAndFrequency: '18–35+ · Every 2 years',
        demographicImpact: 'Gender: The baseline for creatinine (a kidney marker included in this test) runs '
            'naturally higher in males due to higher average muscle mass. Age: Baseline kidney filtration (eGFR) '
            'naturally begins to decline slightly as you age, so older individuals will have different normal '
            'reference ranges compared to younger adults.',
        link: 'https://www.1mg.com/labs/test/good-health-silver-package-with-smart-report-33027',
      ),
    ],
  );

  static const _moderate = PlanTierData(
    key: PlanTierKey.moderate,
    tabLabel: 'Moderate',
    titleLine: 'Moderate: Health Plus',
    description: 'Tracks long-term metabolic health, detecting early signs of subclinical inflammation.',
    iconAssetPath: 'assets/icons/moderate.png',
    packages: [
      PackageOption(
        cardTitle: 'Comprehensive Gold',
        fullName: 'Comprehensive Gold Package with ECG & USG Whole Abdomen',
        provider: 'Tata 1mg',
        priceRupees: 3999,
        isRecommended: true,
        cardBullets: [
          'Glucose & HbA1c',
          'Advanced Lipid Profile',
          'UACR & ECG',
          'Whole Abdomen USG',
        ],
        matchingParameters: [
          'Fasting Plasma Glucose',
          'HbA1c',
          'Total Cholesterol',
          'LDL',
          'HDL',
          'Triglycerides',
          'TC/HDL',
          'eGFR / Creatinine',
          'UACR',
          'ECG',
        ],
        matchCount: 10,
        ageAndFrequency: '20–40+ · 1 year',
        demographicImpact: 'Gender: Creatinine levels run naturally higher in males. Post-menopausal women '
            'experience a shift in baseline lipid risk profiles. Age: Aging increases the necessity of frequent '
            'screening to detect emerging metabolic dysfunction.',
        link: 'https://www.1mg.com/labs/test/comprehensive-gold-package-with-ecg-usg-whole-abdomen-41866',
      ),
      PackageOption(
        cardTitle: 'Apollo Heart Panel',
        fullName: 'Apollo Heart Panel – Advance',
        provider: 'Apollo Hospital',
        priceRupees: 4329,
        isRecommended: false,
        cardParagraph: 'Includes hs-CRP, Lp(a), hs-Troponin, NT-proBNP / BNP, Homocysteine.',
        matchingParameters: [
          'hs-CRP',
          'Lp(a)',
          'hs-Troponin',
          'NT-proBNP / BNP',
          'Total Cholesterol (TC)',
          'HDL Cholesterol',
          'LDL Cholesterol',
          'Triglycerides',
          'ApoB',
          'TC/HDL Ratio',
          'eGFR / Creatinine',
          'Fasting Plasma Glucose',
          'HbA1c',
          'Homocysteine',
        ],
        matchCount: 14,
        ageAndFrequency: '18–50+ · 1 year',
        demographicImpact: 'Gender: Female cardiovascular risk profiles adjust relative to biological sex '
            'factors. Age: Vascular inflammation and metabolic markers shift as age increases.',
        link: 'https://www.apollo247.com/lab-tests/apollo-heart-essential',
      ),
    ],
  );

  static const _advance = PlanTierData(
    key: PlanTierKey.advance,
    tabLabel: 'Advance',
    titleLine: 'Advanced: Heart Complete',
    description: 'Exhaustive health evaluation tier combining deep blood pathology with advanced physical radiology.',
    iconAssetPath: 'assets/icons/advanced.png',
    packages: [
      // Moved here per your correction — this is an Advance-tier package,
      // not Moderate.
      PackageOption(
        cardTitle: 'Cardiac Advanced',
        fullName: 'Cardiac Health Package - Advanced',
        provider: 'Max Healthcare',
        priceRupees: 10340,
        isRecommended: false,
        cardParagraph: 'Adds Carotid IMT, LVH (via Echocardiogram), and Body Composition.',
        matchingParameters: [
          'Fasting Plasma Glucose',
          'HbA1c',
          'Total Cholesterol',
          'LDL',
          'HDL',
          'Triglycerides',
          'TC/HDL',
          'eGFR / Creatinine',
          'Homocysteine',
          'hs-CRP',
          'Carotid IMT',
          'LVH (via Echocardiogram)',
          'Body Composition',
          'ECG',
        ],
        matchCount: 14,
        ageAndFrequency: '18–35+ · 1 year',
        demographicImpact: 'Gender: Baseline body composition and cardiovascular risk profiles adjust relative '
            'to biological sex. Age: Arterial thickness (Carotid IMT) and vascular inflammation (hs-CRP) are '
            'highly sensitive to age-related vascular aging.',
        link: 'https://www.blkmaxhospital.com/preventive-health-plans',
      ),
      PackageOption(
        cardTitle: 'Health Check Up+CT',
        fullName: 'Advanced Health Check Up + CT Coronary Angiography (CAC)',
        provider: 'Apollo Hospitals',
        priceRupees: 17999,
        isRecommended: false,
        cardBullets: [
          'CT Coronary Angiography (CAC)',
          'Lp(a), ApoB, Homocysteine',
          'LVH (via Echo)',
        ],
        matchingParameters: [
          'Fasting Plasma Glucose',
          'HbA1c',
          'Total Cholesterol',
          'LDL Cholesterol',
          'HDL Cholesterol',
          'Triglycerides',
          'TC/HDL Ratio',
          'eGFR / Creatinine',
          'UACR',
          'Lp(a)',
          'ApoB',
          'Homocysteine',
          'hs-CRP',
          'ECG',
          'CAC Score (via CT)',
          'LVH (via Echo)',
        ],
        matchCount: 16,
        ageAndFrequency: '18–40+ · Every 3 years (for the CT scan portion)',
        demographicImpact: 'Gender: Risk of arterial calcification (CAC) historically presents differently in '
            'males versus pre-menopausal females. Age: The CAC score is highly age-dependent; expected plaque '
            'baseline heavily increases as age advances.',
        link: 'https://www.apollocvhf.com/treatments/heart-health-check-packages',
      ),
      PackageOption(
        cardTitle: 'ProHealth Platinum',
        fullName: 'Apollo ProHealth Platinum Health Program',
        provider: 'Apollo Hospitals',
        priceRupees: 31500,
        isRecommended: false,
        cardBullets: [
          'Fibrinogen & hs-Troponin',
          'Complete Lipid & Pathology Panel',
          'Full Body Composition & LVH',
        ],
        matchingParameters: [
          'Total Cholesterol (TC)',
          'LDL Cholesterol',
          'HDL Cholesterol',
          'Triglycerides',
          'TC/HDL Ratio',
          'Fasting Plasma Glucose',
          'HbA1c',
          'eGFR / Creatinine',
          'UACR / Microalbuminuria',
          'Lp(a)',
          'ApoB',
          'Homocysteine',
          'Fibrinogen',
          'hs-CRP',
          'hs-Troponin',
          'Body Composition',
          'LVH',
          'ECG',
        ],
        matchCount: 18,
        ageAndFrequency: '20–45+ · 1 year',
        demographicImpact: 'Gender: Fibrinogen levels fluctuate during hormonal shifts. Bone/body composition '
            'baseline varies significantly by sex. Age: Captures age-driven structural damage (LVH) and vascular '
            'inflammation (hs-CRP) that escalate in senior years.',
        link: 'https://www.apollohospitals.com/apollo-prohealth-platinum-health-program-apollo-hospitals-navi-mumba',
      ),
    ],
  );
}

/// Per-tier card background — kept next to the seed data since it's a
/// property of the tier, not a per-package choice.
extension PlanTierCardColor on PlanTierKey {
  Color get cardBackground {
    switch (this) {
      case PlanTierKey.basic:
        return AppColors.planBasicCardBg;
      case PlanTierKey.moderate:
        return AppColors.planModerateCardBg;
      case PlanTierKey.advance:
        return AppColors.planAdvanceCardBg;
    }
  }
}