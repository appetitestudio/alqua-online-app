import 'package:floating_snackbar/floating_snackbar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:souq_alqua/faq_screen/faq_screen.dart';
import 'package:souq_alqua/screens/cart/cart_screen.dart';
import 'package:souq_alqua/screens/order_screens/delivery_locations/delivery_location.dart';
import 'package:souq_alqua/screens/order_screens/delivery_locations/providers/delivery_location_provider.dart';
import 'package:souq_alqua/screens/order_screens/orders/order_screen.dart';
import 'package:souq_alqua/screens/authentication/sign_in/provider/login_provider.dart';

import 'package:souq_alqua/screens/authentication/sign_in/sign_in_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:souq_alqua/utils/constants.dart';
import 'package:souq_alqua/utils/image_class.dart';
import 'package:url_launcher/url_launcher.dart';

import 'components/profile_menu.dart';
import 'components/profile_pic.dart';

class ProfileScreen extends StatefulWidget {
  static String routeName = "/profile";

  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    LoginProvider loginProvider =
        Provider.of<LoginProvider>(context, listen: false);
    AddressProvider addressProvider =
        Provider.of<AddressProvider>(context, listen: false);
    Future.microtask(() {
      loginProvider.getPreference();
      if (!loginProvider.isGuestLogin) {
        addressProvider.fetchUserEmail();
      }
    });

    super.initState();
  }

  Future<void> launchWhatsApp(
      {required String phone, required String message}) async {
    String urlString() {
      if (message.isNotEmpty) {
        return "https://wa.me/$phone/?text=${Uri.encodeComponent(message)}";
      } else {
        return "https://wa.me/$phone/";
      }
    }

    Uri url = Uri.parse(urlString());
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile", style: Theme.of(context).textTheme.bodyLarge),
        centerTitle: true,
      ),
      body: Consumer2<LoginProvider, AddressProvider>(
        builder: (context, snap, addressSnap, child) => SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: snap.isGuestLogin
              ? SizedBox(
                  height: MediaQuery.of(context).size.height / 1.3,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(ImageClass.loginIcon, height: 110),
                        Text(
                          "Ready to roll?\n Log in to make these cars yours",
                          style: Theme.of(context).textTheme.titleMedium,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 2,
                          child: ElevatedButton(
                              onPressed: () {
                                Navigator.pushAndRemoveUntil(context,
                                    MaterialPageRoute(builder: (context) {
                                  return const SignInScreen();
                                }), (route) => false);
                              },
                              child: const Text('Login')),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        ProfileMenu(
                          text: "Contact Us",
                          icon: "assets/icons/Call.svg",
                          press: () async {
                            // call to "8766786789"
                            Uri url = Uri(scheme: 'tel', path: "0506375562");
                            if (await canLaunchUrl(url)) {
                              await launchUrl(url);
                            } else {
                              throw 'Could not launch $url';
                            }
                          },
                        ),
                        ProfileMenu(
                          text: "Whatsapp Support",
                          icon: ImageClass.whatsappIcon,
                          press: () {
                            launchWhatsApp(
                                phone: "+971506375562",
                                message: "Hello, I need help with my order.");
                          },
                        ),
                        ProfileMenu(
                          text: "Frequently Asked Questions",
                          icon: "assets/icons/Question mark.svg",
                          press: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return const FaqScreen();
                            }));
                          },
                        ),
                      ],
                    ),
                  ),
                )
              : Column(
                  children: [
                    const ProfilePic(),
                    const SizedBox(height: 10),
                    Text(
                      snap.userName ?? "",
                      style: Theme.of(context).textTheme.labelMedium,
                    ),
                    Text(
                      snap.emailId ?? "",
                      style: Theme.of(context).textTheme.labelMedium,
                    ),
                    const SizedBox(height: 10),

                    /// My Wallet
                    Container(
                      padding: const EdgeInsets.all(16),
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                        color: Colors.black87,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 1,
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ],
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Row(
                        children: [
                          SvgPicture.asset(
                            "assets/icons/Flash Icon.svg",
                            // ignore: deprecated_member_use
                            color: Colors.white,
                            height: 30,
                          ),
                          const SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("Reward Points",
                                  style: TextStyle(
                                    fontFamily: kFontFamily,
                                    fontSize: 12,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  )),
                              Text(addressSnap.rewardPoint ?? "0.00",
                                  style: const TextStyle(
                                    fontFamily: kFontFamily,
                                    fontSize: 20,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  )),
                            ],
                          ),
                        ],
                      ),
                    ),
                    ProfileMenu(
                      text: "Contact Us",
                      icon: "assets/icons/Call.svg",
                      press: () async {
                        // call to "8766786789"
                        Uri url = Uri(scheme: 'tel', path: "0506375562");
                        if (await canLaunchUrl(url)) {
                          await launchUrl(url);
                        } else {
                          throw 'Could not launch $url';
                        }
                      },
                    ),
                    ProfileMenu(
                      text: "My Cart",
                      icon: "assets/icons/Cart Icon.svg",
                      press: () => {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return const CartScreen();
                        }))
                      },
                    ),
                    ProfileMenu(
                      text: "My Orders",
                      icon: "assets/icons/User Icon.svg",
                      press: () => {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return const MyOrderScreen();
                        }))
                      },
                    ),
                    ProfileMenu(
                      text: "Delivery Address",
                      icon: "assets/icons/Parcel.svg",
                      press: () => {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return const LocationScreen();
                        }))
                      },
                    ),
                    Consumer<AddressProvider>(
                      builder: (context, value, child) => ProfileMenu(
                        text: value.userSelectedCountry ?? "Select Country",
                        icon: "assets/icons/Location point.svg",
                        press: () {
                          final countryList = [
                            'UAE 🇦🇪',
                            'Saudi Arabia 🇸🇦',
                            'Kuwait 🇰🇼',
                            'Bahrain 🇧🇭',
                            'Oman 🇴🇲',
                            'Qatar 🇶🇦',
                          ];
                          if (countryList.isNotEmpty) {
                            FloatingSnackBar(
                                message:
                                    'Currently we are only serving in UAE 🇦🇪',
                                context: context);

                            return;
                          } else {
                            showModalBottomSheet(
                              context: context,
                              builder: (BuildContext context) {
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: Text('Select Country',
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.w700),
                                                textAlign: TextAlign.center),
                                          ),
                                          IconButton(
                                            icon: const Icon(Icons.close),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                        ],
                                      ),
                                      const Divider(),
                                      Expanded(
                                        child: ListView.builder(
                                          padding: const EdgeInsets.all(8),
                                          itemCount: countryList.length,
                                          itemBuilder: (context, index) {
                                            return ListTile(
                                              leading: value
                                                          .userSelectedCountry ==
                                                      countryList[index]
                                                  ? const Icon(Icons.check)
                                                  : const Icon(Icons
                                                      .radio_button_unchecked),
                                              title: Text(countryList[index],
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      color:
                                                          value.userSelectedCountry ==
                                                                  countryList[
                                                                      index]
                                                              ? Colors.black
                                                              : Colors.grey,
                                                      fontWeight:
                                                          FontWeight.w600)),
                                              onTap: () {
                                                // value.selectOrUpdateCountry(
                                                //   countryList[index],
                                                // );
                                                FloatingSnackBar(
                                                    message:
                                                        'Currently we are only serving in UAE 🇦🇪',
                                                    context: context);

                                                Navigator.of(context).pop();
                                              },
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                          }
                        },
                      ),
                    ),
                    ProfileMenu(
                      text: "Frequently Asked Questions",
                      icon: "assets/icons/Question mark.svg",
                      press: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return const FaqScreen();
                        }));
                      },
                    ),
                    ProfileMenu(
                      text: "Whatsapp Support",
                      icon: ImageClass.whatsappIcon,
                      press: () {
                        launchWhatsApp(
                            phone: "+971506375562",
                            message: "Hello, I need help with my order.");
                      },
                    ),
                    ProfileMenu(
                      text: "Delete Account",
                      icon: "assets/icons/Trash.svg",
                      press: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Delete Account'),
                              content: const Text(
                                  'Are you sure you want to delete your account?'),
                              actions: <Widget>[
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          Colors.grey.withOpacity(0.2)),
                                  onPressed: () {
                                    Navigator.of(context).pop(
                                        false); // Dismiss the dialog and return false
                                  },
                                  child: const Text(
                                    'Cancel',
                                    style: TextStyle(color: Colors.black45),
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.redAccent),
                                  onPressed: () async {
                                    snap.logoutFn(context: context);
                                  },
                                  child: const Text('Delete'),
                                ),
                              ],
                            );
                          },
                        );
                      },
                    ),
                    ProfileMenu(
                      text: "Log Out",
                      icon: "assets/icons/Log out.svg",
                      press: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return const LogoutDialog();
                          },
                        ).then((value) {
                          // This block executes when the dialog is dismissed.
                          if (value != null && value) {
                            // FirebaseAuth.instance.signOut();
                            Navigator.pushAndRemoveUntil(context,
                                MaterialPageRoute(builder: (context) {
                              return const SignInScreen();
                            }), (route) => false);
                          }
                        });
                      },
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}

class LogoutDialog extends StatelessWidget {
  const LogoutDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Logout'),
      content: const Text('Are you sure you want to logout?'),
      actions: <Widget>[
        ElevatedButton(
          style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue.withOpacity(0.2)),
          onPressed: () {
            Navigator.of(context)
                .pop(false); // Dismiss the dialog and return false
          },
          child: const Text(
            'Cancel',
            style: TextStyle(color: Colors.black45),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
          onPressed: () {
            Navigator.of(context)
                .pop(true); // Dismiss the dialog and return true
          },
          child: const Text('Logout'),
        ),
      ],
    );
  }
}
