import 'package:flutter/material.dart';

class LoadingContainer extends StatelessWidget {
  final Widget child;
  final bool isLoading;

  const LoadingContainer(
      {Key key,
        @required this.isLoading,
        @required this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return isLoading ? _loadingView :child ;
  }

  Widget get _loadingView {
    return Center(
      child: CircularProgressIndicator(),
    );
  }
}

