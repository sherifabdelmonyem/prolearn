import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class LessonAudioPlayerWidget extends StatefulWidget {
  final String audioUrl;

  const LessonAudioPlayerWidget({
    super.key,
    required this.audioUrl,
  });

  @override
  State<LessonAudioPlayerWidget> createState() =>
      _LessonAudioPlayerWidgetState();
}

class _LessonAudioPlayerWidgetState
    extends State<LessonAudioPlayerWidget> {
  late final AudioPlayer _audioPlayer;

  bool _isPlaying = false;
  bool _finished = false;

  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;

  @override
  void initState() {
    super.initState();

    _audioPlayer = AudioPlayer();

    _audioPlayer.onPlayerStateChanged.listen((state) {
      if (!mounted) return;

      setState(() {
        _isPlaying = state == PlayerState.playing;
      });
    });

    _audioPlayer.onDurationChanged.listen((duration) {
      if (!mounted) return;

      setState(() {
        _duration = duration;
      });
    });

    _audioPlayer.onPositionChanged.listen((position) {
      if (!mounted) return;

      setState(() {
        _position = position;
      });
    });

    _audioPlayer.onPlayerComplete.listen((event) {
      if (!mounted) return;

      setState(() {
        _isPlaying = false;
        _finished = true;
        _position = _duration;
      });
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _togglePlay() async {
    try {
      if (_isPlaying) {
        await _audioPlayer.pause();
        return;
      }

      if (_finished) {
        setState(() {
          _finished = false;
          _position = Duration.zero;
        });

        await _audioPlayer.stop();

        await _audioPlayer.play(
          UrlSource(widget.audioUrl),
        );

        return;
      }

      if (_position == Duration.zero) {
        await _audioPlayer.play(
          UrlSource(widget.audioUrl),
        );
      } else {
        await _audioPlayer.resume();
      }
    } catch (e) {
      debugPrint("Audio Error: $e");
    }
  }

  Future<void> _stop() async {
    try {
      await _audioPlayer.stop();

      setState(() {
        _position = Duration.zero;
        _isPlaying = false;
        _finished = false;
      });
    } catch (e) {
      debugPrint("Stop Error: $e");
    }
  }

  Future<void> _restart() async {
    try {
      await _audioPlayer.stop();

      setState(() {
        _position = Duration.zero;
        _finished = false;
      });

      await _audioPlayer.play(
        UrlSource(widget.audioUrl),
      );
    } catch (e) {
      debugPrint("Restart Error: $e");
    }
  }

  String _format(Duration d) {
    String two(int n) => n.toString().padLeft(2, '0');

    return "${two(d.inMinutes)}:${two(d.inSeconds.remainder(60))}";
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [
            Row(
              children: [
                IconButton(
                  iconSize: 46,
                  onPressed: _togglePlay,
                  icon: Icon(
                    _isPlaying
                        ? Icons.pause_circle_filled
                        : Icons.play_circle_fill,
                    color: Colors.blue,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.stop_circle),
                  color: Colors.red,
                  onPressed: _stop,
                ),
                IconButton(
                  icon: const Icon(Icons.restart_alt),
                  color: Colors.green,
                  onPressed: _restart,
                ),
                Expanded(
                  child: Text(
                    _finished
                        ? "انتهى تشغيل الشرح"
                        : _isPlaying
                            ? "جاري تشغيل الشرح..."
                            : "اضغط للاستماع إلى الشرح",
                    textAlign: TextAlign.right,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
            Slider(
              value: _position.inMilliseconds
                  .clamp(
                    0,
                    _duration.inMilliseconds == 0
                        ? 1
                        : _duration.inMilliseconds,
                  )
                  .toDouble(),
              max: _duration.inMilliseconds == 0
                  ? 1
                  : _duration.inMilliseconds.toDouble(),
              onChanged: (value) async {
                final newPosition = Duration(
                  milliseconds: value.toInt(),
                );

                await _audioPlayer.seek(newPosition);

                setState(() {
                  _position = newPosition;
                });
              },
            ),
            Row(
              mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _format(_position),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  _format(_duration),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}