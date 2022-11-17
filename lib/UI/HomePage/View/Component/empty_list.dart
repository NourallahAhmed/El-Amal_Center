
import 'package:flutter/material.dart';

class EmptyList extends StatelessWidget {
  const EmptyList({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Image.network(
          "https://ouch-cdn2.icons8.com/BbYaGQcG9qxVp4LAoSXm-fhbsTutCLjWaV2ESMk6GMI/rs:fit:256:171/czM6Ly9pY29uczgu/b3VjaC1wcm9kLmFz/c2V0cy9zdmcvMy82/YTk5NTJiMi1mNWVh/LTRkNDAtYjZlMi1h/ZGQzODUwYTIwMjUu/c3Zn.png"),
    );
  }
}
