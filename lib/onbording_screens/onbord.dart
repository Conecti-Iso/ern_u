

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
    title: ' Can be accessed from anywhere at any time',
    image: ImagesPath.kOnboarding1,
    description:
    'The essential language learning tools and resources you need to seamlessly transition into mastering a new language',
  ),
  OnBoarding(
      title: 'Offers a dynamic and interactive experience',
      image: ImagesPath.kOnboarding2,
      description:
      'Engaging features including test, story telling, and conversations that motivate and inspire language learners to unlock their full potential'),
  OnBoarding(
      title: "Experience the Premium Features with Our App",
      image: ImagesPath.kOnboarding3,
      description:
      'Updated TalkGpt with premium materials and a dedicated following, providing language learners with immersive content for effective learning'),
];