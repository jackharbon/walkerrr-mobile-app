import 'package:flutter/material.dart';
import 'package:walkerrr/common/armor_variables.dart';
import 'package:walkerrr/common/single_shopitem.dart';
import 'package:walkerrr/common/styling_variables.dart';
import 'package:walkerrr/providers/user_provider.dart';

class WalkerShop extends StatefulWidget {
  const WalkerShop({super.key});

  @override
  State<WalkerShop> createState() => _WalkerShopState();
}

class _WalkerShopState extends State<WalkerShop> {
  final ninja = ArmorIcons().armorIconOne;
  final rogue = ArmorIcons().armorIconTwo;
  final knight = ArmorIcons().armorIconThree;
  final shaman = ArmorIcons().armorIconFour;
  final beach = ArmorIcons().armorIconFive;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: GlobalStyleVariables.equipmentAppBarColour,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Shop'),
            Text('Coins: ${userObject["coins"]}'),
          ],
        ),
      ),
      backgroundColor: GlobalStyleVariables.equipmentBackgroundColour,
      body: GridView.count(
        crossAxisCount: 2,
        children: [
          SingleShopItem(name: "Beach", price: 500, assetName: beach),
          SingleShopItem(name: "Ninja", price: 1000, assetName: ninja),
          SingleShopItem(name: "Rogue", price: 1500, assetName: rogue),
          SingleShopItem(name: "Knight", price: 2500, assetName: knight),
          SingleShopItem(name: "Shaman", price: 4000, assetName: shaman),
        ],
      ),
    );
  }
}
