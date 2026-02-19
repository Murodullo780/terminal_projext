import 'dart:async';

import 'package:flutter/material.dart';
import 'dart:math' as math;

class CustomEasyLoading extends StatelessWidget {
  const CustomEasyLoading({super.key});

  /// ===== STATE =====
  static final ValueNotifier<bool> _showing = ValueNotifier(false);
  static final ValueNotifier<bool> _canPop = ValueNotifier(false);
  static final ValueNotifier<Widget> _currentWidget = ValueNotifier(_doneWidget);
  static final ValueNotifier<String?> _message = ValueNotifier(null);

  static Timer? _hideTimer;
  static bool _isVisible = false;

  /// ===== PUBLIC API =====

  static void show({String? status}) {
    _show(
      widget: _loadingWidget,
      message: status,
      canPop: false,
    );
  }

  static void showInfo(
      String status, {
        Duration duration = const Duration(seconds: 2),
      }) {
    _show(
      widget: _infoWidget,
      message: status,
      canPop: true,
      duration: duration,
    );
  }

  static void showError(
      String? text, {
        Duration duration = const Duration(seconds: 3),
      }) {
    _show(
      widget: _errorWidget,
      message: text,
      canPop: true,
      duration: duration,
    );
  }

  static void showSuccess(
      String? text, {
        Duration duration = const Duration(seconds: 2),
      }) {
    _show(
      widget: _doneWidget,
      message: text,
      canPop: false,
      duration: duration,
    );
  }

  static void dismiss() {
    if (!_isVisible) return;

    _hideTimer?.cancel();
    _hideTimer = null;

    _showing.value = false;
    _canPop.value = false;
    _message.value = null;
    _isVisible = false;
  }

  /// ===== INTERNAL CORE =====

  static void _show({
    required Widget widget,
    String? message,
    bool canPop = false,
    Duration? duration,
  }) {
    // eski timerlarni bekor qilamiz
    _hideTimer?.cancel();
    _hideTimer = null;

    _currentWidget.value = widget;
    _message.value = message;
    _canPop.value = canPop;
    _showing.value = true;
    _isVisible = true;

    if (duration != null) {
      _hideTimer = Timer(duration, dismiss);
    }
  }

  /// ===== WIDGETS =====

  static const Widget _infoWidget = Icon(Icons.info_outline, color: Colors.white);

  static const Widget _doneWidget = Icon(Icons.check, color: Colors.white);

  static const Widget _errorWidget = Icon(Icons.close, color: Colors.white);

  static final Widget _loadingWidget = LoadingSpinner();

  /// ===== UI =====

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: _showing,
      builder: (context, show, _) {
        if (!show) return const SizedBox();

        return ValueListenableBuilder<bool>(
          valueListenable: _canPop,
          builder: (context, canPop, _) {
            return GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: canPop ? dismiss : null,
              child: Material(
                color: Colors.black.withAlpha(70),
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.all(30),
                    margin: const EdgeInsets.all(30),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ValueListenableBuilder<String?>(
                      valueListenable: _message,
                      builder: (context, statusText, _) {
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ValueListenableBuilder<Widget>(
                              valueListenable: _currentWidget,
                              builder: (context, statusWidget, _) {
                                return Container(
                                  height: 50,
                                  width: 50,
                                  padding: const EdgeInsets.all(10),
                                  decoration:  BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                  child: statusWidget,
                                );
                              },
                            ),
                            if (statusText != null) ...[
                              const SizedBox(height: 15),
                              Text(
                                statusText,
                                textAlign: TextAlign.center,
                                style:  TextStyle(fontSize: 21, color: Colors.black),
                              ),
                            ],
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}


class LoadingSpinner extends StatefulWidget {
  const LoadingSpinner({super.key});

  @override
  State<LoadingSpinner> createState() => _LoadingSpinnerState();
}

class _LoadingSpinnerState extends State<LoadingSpinner>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  bool _mirror = false;
  bool _disposed = false;

  static const _rotateDuration = Duration(seconds: 3);
  static const _pauseDuration = Duration(milliseconds: 1000);

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: _rotateDuration,
    );

    _runLoop();
  }

  Future<void> _runLoop() async {
    while (!_disposed) {
      // 1️⃣ AYLANTIRISH (normal)
      await _controller.forward();
      if (_disposed) return;

      // 2️⃣ PAUSE
      await Future.delayed(_pauseDuration);
      if (_disposed) return;

      // 3️⃣ MIRROR YOQISH
      setState(() => _mirror = true);

      // 4️⃣ AYLANTIRISH (mirror)
      _controller.reset();
      await _controller.forward();
      if (_disposed) return;

      // 5️⃣ PAUSE
      await Future.delayed(_pauseDuration);
      if (_disposed) return;

      // 6️⃣ MIRROR O‘CHIRISH
      setState(() => _mirror = false);

      _controller.reset();
    }
  }

  @override
  void dispose() {
    _disposed = true;
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, child) {
        return Transform.scale(
          scaleX: _mirror ? -1 : 1, // 🪞 vertical mirror
          child: Transform.rotate(
            angle: _controller.value * 2 * math.pi,
            child: child,
          ),
        );
      },
      // child: Icon.asset(
      //   'assets/svg/loading.svg',
      //   colorFilter: const ColorFilter.mode(
      //     Colors.white,
      //     BlendMode.srcIn,
      //   ),
      // ),
      child: Icon(Icons.hourglass_bottom),
    );
  }
}