import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../constants/app_colors.dart';

class CustomRichText extends StatelessWidget {
  const CustomRichText({
    super.key,
    required this.title,
    required this.subtitle,
    required this.onTab,
    required this.subtitleTextStyle,
  });
  final String title, subtitle;
  final TextStyle subtitleTextStyle;
  final VoidCallback onTab;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTab,
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          text: title,
          style: GoogleFonts.plusJakartaSans(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColor.kWhite)
              .copyWith(
              color: AppColor.kGrayscale40,
              fontWeight: FontWeight.w600,
              fontSize: 14),
          children: <TextSpan>[
            TextSpan(
              text: subtitle,
              style: subtitleTextStyle,
            ),
          ],
        ),
      ),
    );
  }
}



class TermsAndPrivacyText extends StatelessWidget {
  const TermsAndPrivacyText(
      {super.key,
        required this.title1,
        required this.title2,
        required this.title3,
        this.color2,
        required this.title4});
  final Color? color2;
  final String title1, title2, title3, title4;
  @override
  Widget build(BuildContext context) {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        style: GoogleFonts.plusJakartaSans(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColor.kWhite)
            .copyWith(
            color: AppColor.kGrayscale40,
            fontWeight: FontWeight.w500,
            fontSize: 14),
        children: [
          TextSpan(
            text: title1,
          ),
          TextSpan(
            text: title2,
            style: GoogleFonts.plusJakartaSans(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColor.kWhite)
                .copyWith(
                color: color2 ?? AppColor.kGrayscaleDark100,
                fontWeight: FontWeight.w500,
                fontSize: 14),
          ),
          TextSpan(
            text: title3,
            style: GoogleFonts.plusJakartaSans(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColor.kWhite)
                .copyWith(
                color: AppColor.kGrayscale40,
                fontWeight: FontWeight.w500,
                fontSize: 14),
          ),
          TextSpan(
            text: title4,
            style: GoogleFonts.plusJakartaSans(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColor.kWhite)
                .copyWith(
                color: AppColor.kGrayscaleDark100,
                fontWeight: FontWeight.w500,
                fontSize: 14),
          ),
        ],
      ),
    );
  }
}