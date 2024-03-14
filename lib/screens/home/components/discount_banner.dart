import 'package:flutter/material.dart';
import 'package:shop_app/utils/color_class.dart';

class DiscountBanner extends StatelessWidget {
  const DiscountBanner({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 16,
      ),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            ColorClass.primaryGradientColor2,
            ColorClass.primaryGradientColor1,
          ],
        ),
        color: const Color(0xff3cebbc),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          const Text.rich(
            TextSpan(
              style: TextStyle(color: Colors.white),
              children: [
                TextSpan(
                  text: "Buy now.\n",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(
                  text: "Pay later with",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Image.network(
            "https://i0.wp.com/ifnfintech.com/wp-content/uploads/2021/04/tabby.png?fit=322%2C150&ssl=1",
            width: 60,
          )
        ],
      ),
    );
  }
}
