import 'package:flutter/material.dart';

import '../../../../../constants/text_strings.dart';

class WorkerSearchBar extends StatelessWidget {
  const WorkerSearchBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(border: Border(left: BorderSide(width: 4))),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: TextField(
              onChanged: (value) {
              },
              decoration: InputDecoration(
                hintText: tSearch,
                hintStyle: TextStyle(color: Colors.grey.withOpacity(0.5)),
                suffixIcon: IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.search, size: 25),
                ),
              ),
              style: Theme.of(context).textTheme.headline4,
            ),
          ),
        ],
      ),
    );
  }
}