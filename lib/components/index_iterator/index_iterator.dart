library index_iterator;

import 'dart:async';
import 'package:polymer/polymer.dart';
import '../../model/global.dart';

@CustomTag('index-iterator')
class IndexIterator extends PolymerElement {

  static const String STOPPED = "STOPPED";
  static const String PLAYING = "PLAYING";
  static const String PAUSED = "PAUSED";

  @published int index = 0;           // the current index
  @published int startIndex = 0;      // the starting index
  @published int endIndex;            // the ending index
  @published int step = 1;            // how far, and in which direction, to step with prev() or next()
  @published num interval = 1;        // interval, in seconds, between index changes
  @published bool loop = false;       // should the index loop back to the beginning?
  @published bool autoStart = false;  // should the timer start automatically?

  @observable String state = STOPPED;

  Timer _timer;
  Duration _duration;

  IndexIterator.created() : super.created();

  @override void attached() {
    super.attached();
    log.info("$runtimeType::attached() -- $endIndex");

    if (autoStart && endIndex != null) {
      start();
    }
  }

  void _setupDuration() {
    // setup the Duration object
    _duration = new Duration(seconds: interval);
  }

  void _stopTimer() {
    if (_timer != null) {
      _timer.cancel();
    }
  }

  // this is the only required attribute
  void endIndexChanged([oldValue]) {
    log.info("$runtimeType::endIndexChanged(): $endIndex");

    if (autoStart && endIndex != null) {
      start();
    }
  }

  // respond to any change in the "interval" attribute
  void intervalChanged([oldValue]) {
    log.info("$runtimeType::intervalChanged(): $interval");

    if (interval == null || interval <= 0) {
      log.info("$runtimeType::intervalChanged(): ERROR: interval -- $interval");
      return;
    }

    _setupDuration();

    // if we're already playing, restart the timer with the new interval
    if (state == PLAYING) {
      _stopTimer();
      _timer = new Timer.periodic(_duration, next);
    }
  }

  void startIndexChanged(oldvalue) {
    reset();
  }

  void indexChanged(oldValue) {
    fire('index-changed', detail: index);
  }

  void start() {
    if (endIndex == null) {
      log.severe("$runtimeType::start() -- ERROR: Iterator invalid.");
      return;
    }

    if (state == PLAYING) {
      return;
    }

    // kill any existing timer
    _stopTimer();

    if (_duration == null) {
      _setupDuration();
    }

    // start the timer
    _timer = new Timer.periodic(_duration, next);

    state = PLAYING;
  }

  void pause() {
    // kill the timer and record that we're paused
    _stopTimer();
    state = PAUSED;
  }

  void stop() {
    // kill the timer, reset the index, and record that we're stopped
    _stopTimer();
    reset();
    state = STOPPED;
  }

  void reset() {
    index = startIndex;
  }

  void next([Timer timer = null]) {
    if (endIndex == null) {
      log.severe("$runtimeType::next() -- ERROR: Iterator invalid.");
      return;
    }

    bool nextAvailable = false;

    if (!step.isNegative) {
      if (index < endIndex) {
        nextAvailable = true;
      }
    }
    else if (index > endIndex) {
      nextAvailable = true;
    }

    if (nextAvailable) {
      index += step;
      log.info("$runtimeType::next() -- $index");
    }
    else {
      if (loop) {
        reset();
      }
      else if (state == PLAYING) {
        stop();
      }
    }
  }

  void prev([Timer timer = null]) {
    if (endIndex == null) {
      log.severe("$runtimeType::prev() -- ERROR: Iterator invalid.");
      return;
    }

    bool prevAvailable = false;

    if (!step.isNegative) {
      if (index > startIndex) {
        prevAvailable = true;
      }
    }
    else if (index < startIndex) {
      prevAvailable = true;
    }

    if (prevAvailable) {
      index -= step;
      log.info("$runtimeType::prev() -- $index");
    }
    else {
      if (loop) {
        index = endIndex;
      }
      else if (state == PLAYING) {
        stop();
      }
    }
  }
}