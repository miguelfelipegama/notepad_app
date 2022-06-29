import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:notepad_app/helpers/loading/loading_screen_controller.dart';

class LoadingScreen {
  static final LoadingScreen _shared = LoadingScreen._sharedIsntance();
  factory LoadingScreen() => _shared;
  LoadingScreen._sharedIsntance();

  LoadingScreenController? controller;

  void hide() {
    controller?.close();
    controller = null;
  }

  LoadingScreenController showOverlay({
    required BuildContext context,
    required String text,
  }) {
    final _text = StreamController<String>();
    _text.add(text);

    final state = Overlay.of(context);
    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;

    final overlay = OverlayEntry(
      builder: (context) {
        return Material(
          color: Colors.black.withAlpha(150),
          child: Center(
              child: Container(
            constraints: BoxConstraints(
              maxWidth: size.width * 0.8,
              maxHeight: size.height * 0.8,
              minWidth: size.width * 0.5,
            ),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(10.0)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    const CircularProgressIndicator(),
                    const SizedBox(
                      height: 20,
                    ),
                    StreamBuilder(
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return Text(
                            snapshot.data as String,
                            textAlign: TextAlign.center,
                          );
                        } else {
                          return Container();
                        }
                      },
                      stream: _text.stream,
                    )
                  ],
                ),
              ),
            ),
          )),
        );
      },
    );

    state?.insert(overlay);

    return LoadingScreenController(close: () {
      _text.close();
      overlay.remove();
      return true;
    }, update: (text) {
      _text.add(text);
      return true;
    });
  }
}