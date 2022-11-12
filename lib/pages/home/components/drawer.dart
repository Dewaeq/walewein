import 'package:flutter/material.dart';
import 'package:walewein/shared/constants.dart';

class HomeDrawer extends StatelessWidget {
  const HomeDrawer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 45),
      child: ClipRRect(
        borderRadius: const BorderRadius.horizontal(
          right: Radius.circular(25),
        ),
        child: Drawer(
          child: Column(
            children: [
              const DrawerHeader(
                decoration: BoxDecoration(
                  color: kPrimaryColor,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(25),
                  ),
                ),
                child: SizedBox(
                  width: double.infinity,
                  child: Text(
                    "Settings",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                  ),
                ),
              ),
              ListTile(
                title: const Text('Item 1'),
                onTap: () {},
                onLongPress: () => {},
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.all(12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    MaterialButton(
                      onPressed: () {},
                      color: kPrimaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: const Text(
                        "SIGN OUT",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    MaterialButton(
                      onPressed: () {},
                      shape: const CircleBorder(),
                      minWidth: 0,
                      color: kPrimaryColor,
                      child: const Icon(
                        Icons.language,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
