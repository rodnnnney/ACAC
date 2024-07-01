import 'package:ACAC/domain_layer/repository_interface/cards.dart';
import 'package:ACAC/domain_layer/repository_interface/start_stop.dart';
import 'package:ACAC/domain_layer/repository_interface/times.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

List<restaurantCard> restaurantInfo = [
  restaurantCard(
    restaurantName: 'Kinton Ramen',
    location: const LatLng(45.41913804744197, -75.6914954746089),
    address: '216 Elgin St #2',
    imageSrc:
        'https://acacpicturesgenerealbucket.s3.amazonaws.com/kinton/kt.jpeg',
    imageLogo:
        'https://acacpicturesgenerealbucket.s3.amazonaws.com/kinton/kintonlogo.png',
    hours: Time(
      monday: StartStop(startTime: '11:30 AM', endTime: '10:30 PM'),
      tuesday: StartStop(startTime: '11:30 AM', endTime: '10:30 PM'),
      wednesday: StartStop(startTime: '12:30 PM', endTime: '10:30 PM'),
      thursday: StartStop(startTime: '11:30 AM', endTime: '10:30 PM'),
      friday: StartStop(startTime: '11:30 AM', endTime: '10:30 PM'),
      saturday: StartStop(startTime: '11:30 AM', endTime: '10:30 PM'),
      sunday: StartStop(startTime: '11:30 AM', endTime: '10:30 PM'),
    ),
    rating: 4.7,
    cuisineType: ['Japanese', 'Noodle'],
    reviewNum: 1294,
    discounts: ['10% off dine in'],
    phoneNumber: '+1613 565 8138',
    discountPercent: 10,
    topRatedItemsImgSrc: [
      'https://acacpicturesgenerealbucket.s3.amazonaws.com/kinton/ramen1.webp',
      'https://acacpicturesgenerealbucket.s3.amazonaws.com/kinton/ramen2.webp',
      'https://acacpicturesgenerealbucket.s3.amazonaws.com/kinton/ramen3.png'
    ],
    topRatedItemsPrice: [],
    topRatedItemsName: ['Pork Original', 'Beef Original', 'Pork Shoyu'],
    gMapsLink:
        'https://www.google.ca/maps/place/KINTON+RAMEN+OTTAWA/@45.4190401,-75.6913349,17z/data=!4m22!1m13!4m12!1m4!2m2!1d-79.3741151!2d43.6436609!4e1!1m6!1m2!1s0x4cce053ef4bda579:0x7f0a3ad6db8cc017!2sKINTON+RAMEN+OTTAWA,+216+Elgin+St+%232,+Ottawa,+ON+K2P+1L7!2m2!1d-75.6915062!2d45.4189724!3m7!1s0x4cce053ef4bda579:0x7f0a3ad6db8cc017!8m2!3d45.4189724!4d-75.6915062!9m1!1b1!16s%2Fg%2F11ty4xjgmw?entry=ttu',
    websiteLink: 'https://www.kintonramen.com/menu/',
    awsMatch: 'Kinton Ramen',
  ),
  restaurantCard(
    restaurantName: 'Friends&KTV',
    location: const LatLng(45.36865077062187, -75.70277557461156),
    address: '1430 Prince of Wales',
    imageLogo:
        'https://acacpicturesgenerealbucket.s3.amazonaws.com/friendsktv/friends.jpeg',
    imageSrc:
        'https://acacpicturesgenerealbucket.s3.amazonaws.com/friendsktv/friends.jpeg',
    hours: Time(
      monday: StartStop(startTime: 'Closed', endTime: 'Closed'),
      tuesday: StartStop(startTime: '11:30 AM', endTime: '11:30 PM'),
      wednesday: StartStop(startTime: '12:30 PM', endTime: '11:30 PM'),
      thursday: StartStop(startTime: '11:30 AM', endTime: '11:30 PM'),
      friday: StartStop(startTime: '11:30 AM', endTime: '11:30 PM'),
      saturday: StartStop(startTime: '11:30 AM', endTime: '11:30 PM'),
      sunday: StartStop(startTime: '11:30 AM', endTime: '11:30 PM'),
    ),
    rating: 3.7,
    cuisineType: ['Chinese'],
    reviewNum: 73,
    discounts: ['10% off dine in'],
    phoneNumber: '+1613 695 6868',
    discountPercent: 10,
    topRatedItemsImgSrc: [
      'https://acacpicturesgenerealbucket.s3.amazonaws.com/friendsktv/ktv1.png',
      'https://acacpicturesgenerealbucket.s3.amazonaws.com/friendsktv/ktv2.png',
      'https://acacpicturesgenerealbucket.s3.amazonaws.com/friendsktv/ktv3.png'
    ],
    topRatedItemsPrice: [],
    topRatedItemsName: ['Malatang', 'Chicken tender', 'Lamb Skewers'],
    gMapsLink:
        'https://www.google.ca/maps/place/KINTON+RAMEN+OTTAWA/@45.4190401,-75.6913349,17z/data=!4m22!1m13!4m12!1m4!2m2!1d-79.3741151!2d43.6436609!4e1!1m6!1m2!1s0x4cce053ef4bda579:0x7f0a3ad6db8cc017!2sKINTON+RAMEN+OTTAWA,+216+Elgin+St+%232,+Ottawa,+ON+K2P+1L7!2m2!1d-75.6915062!2d45.4189724!3m7!1s0x4cce053ef4bda579:0x7f0a3ad6db8cc017!8m2!3d45.4189724!4d-75.6915062!9m1!1b1!16s%2Fg%2F11ty4xjgmw?entry=ttu',
    websiteLink: 'https://www.kintonramen.com/menu/',
    awsMatch: 'Friends&KTV',
  ),
  restaurantCard(
      restaurantName: 'Chatime',
      location: const LatLng(45.411220513918316, -75.70696356085315),
      address: '695 Somerset St',
      imageSrc:
          'https://acacpicturesgenerealbucket.s3.amazonaws.com/chatime/chat.jpeg',
      imageLogo:
          'https://acacpicturesgenerealbucket.s3.amazonaws.com/chatime/chatime.jpeg',
      hours: Time(
        monday: StartStop(startTime: '11:00 AM', endTime: '1:00 AM'),
        tuesday: StartStop(startTime: '12:00 PM', endTime: '1:00 AM'),
        wednesday: StartStop(startTime: '12:00 PM', endTime: '1:00 AM'),
        thursday: StartStop(startTime: '12:00 PM', endTime: '1:00 AM'),
        friday: StartStop(startTime: '12:00 PM', endTime: '2:00 AM'),
        saturday: StartStop(startTime: '11:00 AM', endTime: '2:00 AM'),
        sunday: StartStop(startTime: '11:00 AM', endTime: '1:00 AM'),
      ),
      rating: 4.4,
      cuisineType: ['Bubble Tea', 'Desert'],
      reviewNum: 123,
      discounts: ['10% off drinks'],
      phoneNumber: '+1613 366 4006',
      discountPercent: 10,
      topRatedItemsImgSrc: [
        'https://acacpicturesgenerealbucket.s3.amazonaws.com/chatime/chat1.png',
        'https://acacpicturesgenerealbucket.s3.amazonaws.com/chatime/chat2.png',
        'https://acacpicturesgenerealbucket.s3.amazonaws.com/chatime/chat3.png'
      ],
      topRatedItemsPrice: [],
      topRatedItemsName: [
        'Pearl Milk Tea',
        'Brown Sugar Pearl',
        'Handcrafted Taro'
      ],
      gMapsLink:
          'https://www.google.ca/maps/place/KINTON+RAMEN+OTTAWA/@45.4190401,-75.6913349,17z/data=!4m22!1m13!4m12!1m4!2m2!1d-79.3741151!2d43.6436609!4e1!1m6!1m2!1s0x4cce053ef4bda579:0x7f0a3ad6db8cc017!2sKINTON+RAMEN+OTTAWA,+216+Elgin+St+%232,+Ottawa,+ON+K2P+1L7!2m2!1d-75.6915062!2d45.4189724!3m7!1s0x4cce053ef4bda579:0x7f0a3ad6db8cc017!8m2!3d45.4189724!4d-75.6915062!9m1!1b1!16s%2Fg%2F11ty4xjgmw?entry=ttu',
      websiteLink: 'https://www.kintonramen.com/menu/',
      awsMatch: 'Chatime'),
  restaurantCard(
    restaurantName: 'Dakogi Elgin',
    location: const LatLng(45.4278039812124, -75.69032978995092),
    address: '280 Elgin St',
    imageSrc:
        'https://acacpicturesgenerealbucket.s3.amazonaws.com/dakogi/dakpic.webp',
    imageLogo:
        'https://acacpicturesgenerealbucket.s3.amazonaws.com/dakogi/daklogo.png',
    hours: Time(
      monday: StartStop(startTime: 'Closed', endTime: 'Closed'),
      tuesday: StartStop(startTime: '5:00 AM', endTime: '10:00 PM'),
      wednesday: StartStop(startTime: '5:00 AM', endTime: '10:00 PM'),
      thursday: StartStop(startTime: '5:00 AM', endTime: '10:00 PM'),
      friday: StartStop(startTime: '5:00 AM', endTime: '11:00 PM'),
      saturday: StartStop(startTime: '5:00 AM', endTime: '11:00 PM'),
      sunday: StartStop(startTime: '5:00 AM', endTime: '9:00 PM'),
    ),
    rating: 3.9,
    cuisineType: ['Korean', 'Fried Chicken'],
    reviewNum: 720,
    discounts: ['10% off', 'Free Fries with purchases \$40+'],
    phoneNumber: '+1613 565 2232',
    discountPercent: 10,
    topRatedItemsImgSrc: [
      'https://acacpicturesgenerealbucket.s3.amazonaws.com/dakogi/dak1.png',
      'https://acacpicturesgenerealbucket.s3.amazonaws.com/dakogi/dak2.png',
      'https://acacpicturesgenerealbucket.s3.amazonaws.com/dakogi/dak3.png'
    ],
    topRatedItemsPrice: [],
    topRatedItemsName: [
      'Half and Half',
      'Spicy Chicken feet',
      'Yang Nyeom Chicken'
    ],
    gMapsLink:
        'https://www.google.ca/maps/place/KINTON+RAMEN+OTTAWA/@45.4190401,-75.6913349,17z/data=!4m22!1m13!4m12!1m4!2m2!1d-79.3741151!2d43.6436609!4e1!1m6!1m2!1s0x4cce053ef4bda579:0x7f0a3ad6db8cc017!2sKINTON+RAMEN+OTTAWA,+216+Elgin+St+%232,+Ottawa,+ON+K2P+1L7!2m2!1d-75.6915062!2d45.4189724!3m7!1s0x4cce053ef4bda579:0x7f0a3ad6db8cc017!8m2!3d45.4189724!4d-75.6915062!9m1!1b1!16s%2Fg%2F11ty4xjgmw?entry=ttu',
    websiteLink: 'https://www.kintonramen.com/menu/',
    awsMatch: 'Dakogi_Elgin',
  ),
  restaurantCard(
      restaurantName: 'Dakogi MP',
      location: const LatLng(45.411220513918316, -75.70696356085315),
      address: '80 Marketplace Ave',
      imageSrc:
          'https://acacpicturesgenerealbucket.s3.amazonaws.com/dakogi/dakpic.webp',
      imageLogo:
          'https://acacpicturesgenerealbucket.s3.amazonaws.com/dakogi/daklogo.png',
      hours: Time(
        monday: StartStop(startTime: 'Closed', endTime: 'Closed'),
        tuesday: StartStop(startTime: '11:30 AM', endTime: '9:00 PM'),
        wednesday: StartStop(startTime: '11:30 AM', endTime: '9:00 PM'),
        thursday: StartStop(startTime: '11:30 AM', endTime: '9:00 PM'),
        friday: StartStop(startTime: '11:30 AM', endTime: '9:00 PM'),
        saturday: StartStop(startTime: '11:30 AM', endTime: '9:00 PM'),
        sunday: StartStop(startTime: '11:30 AM', endTime: '9:00 PM'),
      ),
      rating: 3.8,
      cuisineType: ['Korean', 'Fried Chicken'],
      reviewNum: 299,
      discounts: ['10% off', 'Free Fries with purchases \$40+'],
      phoneNumber: '+1613 823 8233',
      discountPercent: 10,
      topRatedItemsPrice: [],
      topRatedItemsImgSrc: [
        'https://acacpicturesgenerealbucket.s3.amazonaws.com/dakogi/dak1.png',
        'https://acacpicturesgenerealbucket.s3.amazonaws.com/dakogi/dak2.png',
        'https://acacpicturesgenerealbucket.s3.amazonaws.com/dakogi/dak3.png'
      ],
      topRatedItemsName: [
        'Half and Half',
        'Spicy Chicken feet',
        'Yang Nyeom Chicken'
      ],
      gMapsLink:
          'https://www.google.ca/maps/place/KINTON+RAMEN+OTTAWA/@45.4190401,-75.6913349,17z/data=!4m22!1m13!4m12!1m4!2m2!1d-79.3741151!2d43.6436609!4e1!1m6!1m2!1s0x4cce053ef4bda579:0x7f0a3ad6db8cc017!2sKINTON+RAMEN+OTTAWA,+216+Elgin+St+%232,+Ottawa,+ON+K2P+1L7!2m2!1d-75.6915062!2d45.4189724!3m7!1s0x4cce053ef4bda579:0x7f0a3ad6db8cc017!8m2!3d45.4189724!4d-75.6915062!9m1!1b1!16s%2Fg%2F11ty4xjgmw?entry=ttu',
      websiteLink: 'https://www.kintonramen.com/menu/',
      awsMatch: 'Dakogi_Marketplace'),
  restaurantCard(
    restaurantName: 'Gongfu Bao',
    location: const LatLng(45.41573106777921, -75.69463575934863),
    address: '365 Bank St',
    imageSrc:
        'https://acacpicturesgenerealbucket.s3.amazonaws.com/gongfubao/gonfubao.avif',
    imageLogo:
        'https://acacpicturesgenerealbucket.s3.amazonaws.com/gongfubao/gongfulogo.png',
    hours: Time(
      monday: StartStop(startTime: 'Closed', endTime: 'Closed'),
      tuesday: StartStop(startTime: 'Closed', endTime: 'Closed'),
      wednesday: StartStop(startTime: '12:30 PM', endTime: '10:30 PM'),
      thursday: StartStop(startTime: '11:30 AM', endTime: '10:30 PM'),
      friday: StartStop(startTime: '11:30 AM', endTime: '10:30 PM'),
      saturday: StartStop(startTime: '11:30 AM', endTime: '10:30 PM'),
      sunday: StartStop(
          startTime: 'Closed', endTime: 'Closed'), //TODO ANNOYING ASS TIMES
    ),
    rating: 4.6,
    cuisineType: ['Chinese', 'Bao'],
    reviewNum: 968,
    discounts: ['10% off', 'Free Item with \$20+ Purchase'],
    phoneNumber: '+1613 454 5963',
    discountPercent: 10,
    topRatedItemsImgSrc: [
      'https://acacpicturesgenerealbucket.s3.amazonaws.com/gongfubao/bao1.webp',
      'https://acacpicturesgenerealbucket.s3.amazonaws.com/gongfubao/bao2.webp',
      'https://acacpicturesgenerealbucket.s3.amazonaws.com/gongfubao/bao3.webp'
    ],
    topRatedItemsPrice: [],
    topRatedItemsName: [
      'Berkshire Pork Bao',
      'Brisket Bao',
      'Fried Chicken Bao'
    ],
    gMapsLink:
        'https://www.google.ca/maps/place/KINTON+RAMEN+OTTAWA/@45.4190401,-75.6913349,17z/data=!4m22!1m13!4m12!1m4!2m2!1d-79.3741151!2d43.6436609!4e1!1m6!1m2!1s0x4cce053ef4bda579:0x7f0a3ad6db8cc017!2sKINTON+RAMEN+OTTAWA,+216+Elgin+St+%232,+Ottawa,+ON+K2P+1L7!2m2!1d-75.6915062!2d45.4189724!3m7!1s0x4cce053ef4bda579:0x7f0a3ad6db8cc017!8m2!3d45.4189724!4d-75.6915062!9m1!1b1!16s%2Fg%2F11ty4xjgmw?entry=ttu',
    websiteLink: 'https://www.kintonramen.com/menu/',
    awsMatch: 'Gongfu_Bao',
  ),
  restaurantCard(
    restaurantName: 'Hot Star Chicken',
    location: const LatLng(45.42785741450634, -75.68871809793494),
    address: '412 Dalhousie St',
    imageSrc:
        'https://acacpicturesgenerealbucket.s3.amazonaws.com/hotstarchicken/hotsrc.jpeg',
    imageLogo:
        'https://acacpicturesgenerealbucket.s3.amazonaws.com/hotstarchicken/hotlogo.jpeg',
    hours: Time(
      monday: StartStop(startTime: '12:00 AM', endTime: '9:00 PM'),
      tuesday: StartStop(startTime: '4:30 PM', endTime: '9:00 PM'),
      wednesday: StartStop(startTime: '4:30 PM', endTime: '9:00 PM'),
      thursday: StartStop(startTime: '12:00 AM', endTime: '9:00 PM'),
      friday: StartStop(startTime: '12:00 AM', endTime: '10:00 PM'),
      saturday: StartStop(startTime: '12:00 AM', endTime: '10:00 PM'),
      sunday: StartStop(startTime: '12:00 PM', endTime: '9:00 PM'),
    ),
    rating: 4.1,
    cuisineType: ['Korean', 'Fried Chicken'],
    reviewNum: 109,
    discounts: ['10% off'],
    phoneNumber: '+1613 680 2500',
    discountPercent: 10,
    topRatedItemsImgSrc: [
      'https://acacpicturesgenerealbucket.s3.amazonaws.com/hotstarchicken/hot3.png',
      'https://acacpicturesgenerealbucket.s3.amazonaws.com/hotstarchicken/hot2.png',
      'https://acacpicturesgenerealbucket.s3.amazonaws.com/hotstarchicken/hot1.png'
    ],
    topRatedItemsPrice: [],
    topRatedItemsName: [
      'Fried Chicken w/ BBQ',
      'Hot Cheese Fried Chicken',
      'Chicken Popcorn'
    ],
    gMapsLink:
        'https://www.google.ca/maps/place/KINTON+RAMEN+OTTAWA/@45.4190401,-75.6913349,17z/data=!4m22!1m13!4m12!1m4!2m2!1d-79.3741151!2d43.6436609!4e1!1m6!1m2!1s0x4cce053ef4bda579:0x7f0a3ad6db8cc017!2sKINTON+RAMEN+OTTAWA,+216+Elgin+St+%232,+Ottawa,+ON+K2P+1L7!2m2!1d-75.6915062!2d45.4189724!3m7!1s0x4cce053ef4bda579:0x7f0a3ad6db8cc017!8m2!3d45.4189724!4d-75.6915062!9m1!1b1!16s%2Fg%2F11ty4xjgmw?entry=ttu',
    websiteLink: 'https://www.kintonramen.com/menu/',
    awsMatch: 'Hot_Star_Chicken',
  ),
  restaurantCard(
    restaurantName: 'La Noodle',
    location: const LatLng(45.36116625959877, -75.73836670501889),
    address: '1383 Clyde Ave',
    imageSrc:
        'https://acacpicturesgenerealbucket.s3.amazonaws.com/lanoodle/laSrc.jpeg',
    imageLogo:
        'https://acacpicturesgenerealbucket.s3.amazonaws.com/lanoodle/lalogo.jpeg',
    hours: Time(
      monday: StartStop(startTime: '10:30 AM', endTime: '8:30 PM'),
      tuesday: StartStop(startTime: '10:30 AM', endTime: '8:30 PM'),
      wednesday: StartStop(startTime: '10:30 AM', endTime: '8:30 PM'),
      thursday: StartStop(startTime: '10:30 AM', endTime: '8:30 PM'),
      friday: StartStop(startTime: '10:30 AM', endTime: '8:30 PM'),
      saturday: StartStop(startTime: '10:30 AM', endTime: '8:30 PM'),
      sunday: StartStop(startTime: '10:30 AM', endTime: '8:30 PM'),
    ),
    rating: 3.2,
    cuisineType: ['Chinese', 'Noodle'],
    reviewNum: 132,
    discounts: ['10% off'],
    phoneNumber: '+1613 686 1350',
    discountPercent: 10,
    topRatedItemsImgSrc: [
      'https://acacpicturesgenerealbucket.s3.amazonaws.com/lanoodle/la1.png',
      'https://acacpicturesgenerealbucket.s3.amazonaws.com/lanoodle/la2.png',
      'https://acacpicturesgenerealbucket.s3.amazonaws.com/lanoodle/la3.png'
    ],
    topRatedItemsPrice: [],
    topRatedItemsName: ['1', '2', '3'],
    gMapsLink:
        'https://www.google.ca/maps/place/KINTON+RAMEN+OTTAWA/@45.4190401,-75.6913349,17z/data=!4m22!1m13!4m12!1m4!2m2!1d-79.3741151!2d43.6436609!4e1!1m6!1m2!1s0x4cce053ef4bda579:0x7f0a3ad6db8cc017!2sKINTON+RAMEN+OTTAWA,+216+Elgin+St+%232,+Ottawa,+ON+K2P+1L7!2m2!1d-75.6915062!2d45.4189724!3m7!1s0x4cce053ef4bda579:0x7f0a3ad6db8cc017!8m2!3d45.4189724!4d-75.6915062!9m1!1b1!16s%2Fg%2F11ty4xjgmw?entry=ttu',
    websiteLink: 'https://www.kintonramen.com/menu/',
    awsMatch: 'La_Noodle',
  ),
  restaurantCard(
    restaurantName: 'Oriental house',
    location: const LatLng(45.418782346856325, -75.6901756513935),
    address: '266 Elgin St',
    imageSrc:
        'https://acacpicturesgenerealbucket.s3.amazonaws.com/orientalhouse/orientalSRC.jpeg',
    imageLogo:
        'https://acacpicturesgenerealbucket.s3.amazonaws.com/orientalhouse/orientalSRc.png',
    hours: Time(
      monday: StartStop(startTime: '11:00 AM', endTime: '9:00 PM'),
      tuesday: StartStop(startTime: '11:00 AM', endTime: '9:00 PM'),
      wednesday: StartStop(startTime: '11:00 AM', endTime: '9:00 PM'),
      thursday: StartStop(startTime: '11:00 AM', endTime: '9:00 PM'),
      friday: StartStop(startTime: '11:00 AM', endTime: '9:00 PM'),
      saturday: StartStop(startTime: '3:00 PM', endTime: '10:00 PM'),
      sunday: StartStop(startTime: '3:00 PM', endTime: '1:00 PM'),
    ),
    rating: 4.1,
    cuisineType: [
      'Chinese',
    ],
    reviewNum: 244,
    discounts: ['10% off dine-in'],
    phoneNumber: '+1613 563 2694',
    discountPercent: 10,
    topRatedItemsImgSrc: [
      'https://acacpicturesgenerealbucket.s3.amazonaws.com/orientalhouse/oriental1.png',
      'https://acacpicturesgenerealbucket.s3.amazonaws.com/orientalhouse/oriental2.png',
      'https://acacpicturesgenerealbucket.s3.amazonaws.com/orientalhouse/oriental3.png'
    ],
    topRatedItemsPrice: [],
    topRatedItemsName: [
      'Fried Eggplant',
      'Shanghai Chow Mein',
      'Beef with Ginger and Onion'
    ],
    gMapsLink:
        'https://www.google.ca/maps/place/KINTON+RAMEN+OTTAWA/@45.4190401,-75.6913349,17z/data=!4m22!1m13!4m12!1m4!2m2!1d-79.3741151!2d43.6436609!4e1!1m6!1m2!1s0x4cce053ef4bda579:0x7f0a3ad6db8cc017!2sKINTON+RAMEN+OTTAWA,+216+Elgin+St+%232,+Ottawa,+ON+K2P+1L7!2m2!1d-75.6915062!2d45.4189724!3m7!1s0x4cce053ef4bda579:0x7f0a3ad6db8cc017!8m2!3d45.4189724!4d-75.6915062!9m1!1b1!16s%2Fg%2F11ty4xjgmw?entry=ttu',
    websiteLink: 'https://www.kintonramen.com/menu/',
    awsMatch: 'Oriental_house',
  ),
  restaurantCard(
    restaurantName: 'Pho Lady',
    location: const LatLng(45.411220513918316, -75.70696356085315),
    address: '280 Elgin St',
    imageSrc:
        'https://acacpicturesgenerealbucket.s3.amazonaws.com/pholady/pholadysrc.webp',
    imageLogo:
        'https://acacpicturesgenerealbucket.s3.amazonaws.com/pholady/pholadysrc.webp',
    hours: Time(
      monday: StartStop(startTime: '11:30 AM', endTime: '10:30 PM'),
      tuesday: StartStop(startTime: '11:30 AM', endTime: '10:30 PM'),
      wednesday: StartStop(startTime: '12:30 PM', endTime: '10:30 PM'),
      thursday: StartStop(startTime: '11:30 AM', endTime: '10:30 PM'),
      friday: StartStop(startTime: '11:30 AM', endTime: '10:30 PM'),
      saturday: StartStop(startTime: '11:30 AM', endTime: '10:30 PM'),
      sunday: StartStop(startTime: '11:30 AM', endTime: '10:30 PM'),
    ),
    rating: 4.6,
    cuisineType: ['Vietnamese', 'Noodle'],
    reviewNum: 66,
    discounts: ['10% off', 'Free Item with \$40+ Purchase'],
    phoneNumber: '+1613 983 1288',
    discountPercent: 10,
    topRatedItemsImgSrc: [
      'https://acacpicturesgenerealbucket.s3.amazonaws.com/pholady/pholay1.jpeg',
      'https://acacpicturesgenerealbucket.s3.amazonaws.com/pholady/pholady2.jpeg',
      'https://acacpicturesgenerealbucket.s3.amazonaws.com/pholady/Screenshot+2024-06-04+at+9.49.37%E2%80%AFPM.png'
    ],
    topRatedItemsPrice: [],
    topRatedItemsName: [
      'House Special Pho',
      'Well Done Beef Noodle',
      'Pad Thai Noodle'
    ],
    gMapsLink:
        'https://www.google.ca/maps/place/KINTON+RAMEN+OTTAWA/@45.4190401,-75.6913349,17z/data=!4m22!1m13!4m12!1m4!2m2!1d-79.3741151!2d43.6436609!4e1!1m6!1m2!1s0x4cce053ef4bda579:0x7f0a3ad6db8cc017!2sKINTON+RAMEN+OTTAWA,+216+Elgin+St+%232,+Ottawa,+ON+K2P+1L7!2m2!1d-75.6915062!2d45.4189724!3m7!1s0x4cce053ef4bda579:0x7f0a3ad6db8cc017!8m2!3d45.4189724!4d-75.6915062!9m1!1b1!16s%2Fg%2F11ty4xjgmw?entry=ttu',
    websiteLink: 'https://www.kintonramen.com/menu/',
    awsMatch: 'Pho_Lady',
  ),
  restaurantCard(
    restaurantName: 'Pomelo Hat',
    location: const LatLng(45.39319281520581, -75.68141281285315),
    address: '1196 Bank St',
    imageSrc:
        'https://acacpicturesgenerealbucket.s3.amazonaws.com/pomelohat/pomelosrc.jpeg',
    imageLogo:
        'https://acacpicturesgenerealbucket.s3.amazonaws.com/pomelohat/pomelosrc.png',
    hours: Time(
      monday: StartStop(startTime: '1:00 PM', endTime: '11:00 PM'),
      tuesday: StartStop(startTime: '1:00 PM', endTime: '11:00 PM'),
      wednesday: StartStop(startTime: '1:00 PM', endTime: '11:00 PM'),
      thursday: StartStop(startTime: '1:00 PM', endTime: '11:00 PM'),
      friday: StartStop(startTime: '1:00 PM', endTime: '11:00 PM'),
      saturday: StartStop(startTime: '1:00 PM', endTime: '11:00 PM'),
      sunday: StartStop(startTime: '1:00 PM', endTime: '11:00 PM'),
    ),
    rating: 4.7,
    cuisineType: ['Bubble Tea', 'Drinks'],
    reviewNum: 197,
    discounts: ['10% off drinks'],
    phoneNumber: 'N/A',
    discountPercent: 10,
    topRatedItemsImgSrc: [
      'https://acacpicturesgenerealbucket.s3.amazonaws.com/pomelohat/pomelo1.webp',
      'https://acacpicturesgenerealbucket.s3.amazonaws.com/pomelohat/pomelo2.webp',
      'https://acacpicturesgenerealbucket.s3.amazonaws.com/pomelohat/pomelo3.webp'
    ],
    topRatedItemsPrice: [],
    topRatedItemsName: [
      'Strawberry Matcha Latte',
      'Brown Sugar w mousse',
      'Butterfly Flower Tea'
    ],
    gMapsLink:
        'https://www.google.ca/maps/place/KINTON+RAMEN+OTTAWA/@45.4190401,-75.6913349,17z/data=!4m22!1m13!4m12!1m4!2m2!1d-79.3741151!2d43.6436609!4e1!1m6!1m2!1s0x4cce053ef4bda579:0x7f0a3ad6db8cc017!2sKINTON+RAMEN+OTTAWA,+216+Elgin+St+%232,+Ottawa,+ON+K2P+1L7!2m2!1d-75.6915062!2d45.4189724!3m7!1s0x4cce053ef4bda579:0x7f0a3ad6db8cc017!8m2!3d45.4189724!4d-75.6915062!9m1!1b1!16s%2Fg%2F11ty4xjgmw?entry=ttu',
    websiteLink: 'https://www.kintonramen.com/menu/',
    awsMatch: 'Pomelo_Hat',
  ),
  restaurantCard(
    restaurantName: 'Shuyi Tealicious',
    location: const LatLng(45.359349329491906, -75.7385750902237),
    address: '1400 Clyde Ave',
    imageSrc:
        'https://acacpicturesgenerealbucket.s3.amazonaws.com/shuyi/shuiSrc.jpeg',
    imageLogo:
        'https://acacpicturesgenerealbucket.s3.amazonaws.com/shuyi/shuyiLOGO.png',
    hours: Time(
      monday: StartStop(startTime: '2:00 PM', endTime: '10:30 PM'),
      tuesday: StartStop(startTime: '2:00 PM', endTime: '10:30 PM'),
      wednesday: StartStop(startTime: '2:00 PM', endTime: '10:30 PM'),
      thursday: StartStop(startTime: '2:00 PM', endTime: '10:30 PM'),
      friday: StartStop(startTime: '2:00 PM', endTime: '11:00 PM'),
      saturday: StartStop(startTime: '1:00 PM', endTime: '10:30 PM'),
      sunday: StartStop(startTime: '1:00 PM', endTime: '10:00 PM'),
    ),
    rating: 4.3,
    cuisineType: ['Bubble Tea', 'Drinks'],
    reviewNum: 61,
    discounts: ['10% off drinks'],
    discountPercent: 10,
    phoneNumber: '+1343 598 0866',
    topRatedItemsImgSrc: [
      'https://acacpicturesgenerealbucket.s3.amazonaws.com/shuyi/shuy1.webp',
      'https://acacpicturesgenerealbucket.s3.amazonaws.com/shuyi/shuyi2.webp',
      'https://acacpicturesgenerealbucket.s3.amazonaws.com/shuyi/shuyi3.webp'
    ],
    topRatedItemsPrice: [],
    topRatedItemsName: [
      'Strawberry Mochi Latte',
      'Chestnut Nochi Latte',
      'Taro Mochi Latte'
    ],
    gMapsLink:
        'https://www.google.ca/maps/place/KINTON+RAMEN+OTTAWA/@45.4190401,-75.6913349,17z/data=!4m22!1m13!4m12!1m4!2m2!1d-79.3741151!2d43.6436609!4e1!1m6!1m2!1s0x4cce053ef4bda579:0x7f0a3ad6db8cc017!2sKINTON+RAMEN+OTTAWA,+216+Elgin+St+%232,+Ottawa,+ON+K2P+1L7!2m2!1d-75.6915062!2d45.4189724!3m7!1s0x4cce053ef4bda579:0x7f0a3ad6db8cc017!8m2!3d45.4189724!4d-75.6915062!9m1!1b1!16s%2Fg%2F11ty4xjgmw?entry=ttu',
    websiteLink: 'https://www.kintonramen.com/menu/',
    awsMatch: 'Shuyi_Tealicious',
  ),
  restaurantCard(
    restaurantName: 'Fuwa Fuwa',
    location: const LatLng(45.4225835555733, -75.63807849648177),
    address: '1200 St. Laurent Blvd',
    imageSrc:
        'https://acacpicturesgenerealbucket.s3.amazonaws.com/fuwax2/fuwaSRC.avif',
    imageLogo:
        'https://acacpicturesgenerealbucket.s3.amazonaws.com/fuwax2/fuwalogo.png',
    hours: Time(
      monday: StartStop(startTime: '9:30 AM', endTime: '9:00 PM'),
      tuesday: StartStop(startTime: '9:30 AM', endTime: '9:00 PM'),
      wednesday: StartStop(startTime: '9:30 AM', endTime: '9:00 PM'),
      thursday: StartStop(startTime: '9:30 AM', endTime: '9:00 PM'),
      friday: StartStop(startTime: '9:30 AM', endTime: '9:00 PM'),
      saturday: StartStop(startTime: '9:30 AM', endTime: '9:00 PM'),
      sunday: StartStop(startTime: '11:00 AM', endTime: '5:00 PM'),
    ),
    rating: 3.9,
    cuisineType: ['Pancakes', 'Desert'],
    reviewNum: 83,
    discounts: ['10% off drinks'],
    discountPercent: 10,
    phoneNumber: 'N/A',
    topRatedItemsImgSrc: [
      'https://acacpicturesgenerealbucket.s3.amazonaws.com/fuwax2/fuwa1.jpeg',
      'https://acacpicturesgenerealbucket.s3.amazonaws.com/fuwax2/fuwa2.jpeg',
      'https://acacpicturesgenerealbucket.s3.amazonaws.com/fuwax2/fuwa3.jpeg'
    ],
    topRatedItemsPrice: [],
    topRatedItemsName: [
      'Blueberry Cheese',
      'Classic Tiramisu',
      'Cookies and Cream'
    ],
    gMapsLink:
        'https://www.google.ca/maps/place/KINTON+RAMEN+OTTAWA/@45.4190401,-75.6913349,17z/data=!4m22!1m13!4m12!1m4!2m2!1d-79.3741151!2d43.6436609!4e1!1m6!1m2!1s0x4cce053ef4bda579:0x7f0a3ad6db8cc017!2sKINTON+RAMEN+OTTAWA,+216+Elgin+St+%232,+Ottawa,+ON+K2P+1L7!2m2!1d-75.6915062!2d45.4189724!3m7!1s0x4cce053ef4bda579:0x7f0a3ad6db8cc017!8m2!3d45.4189724!4d-75.6915062!9m1!1b1!16s%2Fg%2F11ty4xjgmw?entry=ttu',
    websiteLink: 'https://www.kintonramen.com/menu/',
    awsMatch: 'Fuwa_Fuwa',
  ),
];

final restaurant = Provider((ref) {
  return restaurantInfo;
});

final sortedRestaurantsProvider = Provider<List<restaurantCard>>((ref) {
  var restaurants = List<restaurantCard>.from(restaurantInfo);
  restaurants.sort((a, b) => b.rating.compareTo(a.rating));
  return restaurants;
});
