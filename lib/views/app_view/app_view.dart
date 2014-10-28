library app_view;

import 'dart:html';
import 'dart:convert';
import 'package:polymer/polymer.dart';
import '../../model/global.dart';
import '../../components/index_iterator/index_iterator.dart';
import '../../model/chord.dart';
import 'dart:js';

@CustomTag('app-view')
class AppView extends PolymerElement {

  // initialize system log
  bool _logInitialized = initLog();

  // constants
  static const String CHORD_LIST_PATH = "resources/data/chords.json";

  @observable List<Chord> chordList;
  @observable IndexIterator chordDisplayIterator;

  AppView.created() : super.created() {
    HttpRequest.getString(CHORD_LIST_PATH)
      .then((String fileContents) {
        List<Map> mapList = JSON.decode(fileContents);
        chordList = mapList.map((Map chordMap) => new Chord.fromMap(chordMap)).toList(growable: false);
      })
      .catchError((Error error) => log.severe(error));

    // changing this JS value will alter the duration of slide transitions in <core-animated-pages>
    context['CoreStyle']['g']['transitions']['slideDuration'] = "250ms";
  }

  // life-cycle method called by the Polymer framework when the element is attached to the DOM
  @override void attached() {
    super.attached();
    log.info("$runtimeType::attached()");

    chordDisplayIterator = $["chord-iterator"];
  }

  void startSlideshow(Event event, var detail, Element target) {
    log.info("$runtimeType::startSlideshow()");

    chordDisplayIterator.start();
  }

  void stopSlideshow(Event event, var detail, Element target) {
    log.info("$runtimeType::stopSlideshow()");

    chordDisplayIterator.stop();
  }

  void pauseSlideshow(Event event, var detail, Element target) {
    log.info("$runtimeType::pauseSlideshow()");

    chordDisplayIterator.pause();
  }

  void nextSlide(Event event, var detail, Element target) {
    log.info("$runtimeType::nextSlide()");

    chordDisplayIterator.next();
  }

  void prevSlide(Event event, var detail, Element target) {
    log.info("$runtimeType::prevSlide()");

    chordDisplayIterator.prev();
  }

  // prevent app reload on <form> submission
  void submit(Event event, var detail, Element target) {
    event.preventDefault();
  }
}

