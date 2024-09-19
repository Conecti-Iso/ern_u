

import '../constants/image_path.dart';

class OnBoarding {
  String title;
  String description;
  String image;

  OnBoarding({
    required this.title,
    required this.description,
    required this.image,
  });
}

List<OnBoarding> onBoardinglist = [
  OnBoarding(
    title: ' Hands on desk, create your world!',
    image: ImagesPath.kOnboarding1,
    description:
    'Hands on desk, create your world',
  ),
  OnBoarding(
      title: 'Love what you do',
      image: ImagesPath.kOnboarding2,
      description:
      'love what you do'),
  OnBoarding(
      title: "Administrators it's your Time",
      image: ImagesPath.kOnboarding3,
      description:
      "Administrators it's your time"),
];