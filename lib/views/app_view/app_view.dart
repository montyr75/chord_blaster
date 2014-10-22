library app_view;

import 'dart:html';
import 'dart:convert';
import 'package:polymer/polymer.dart';
import '../../components/index_iterator/index_iterator.dart';
import '../../model/chord.dart';
import 'dart:js';

@CustomTag('app-view')
class AppView extends PolymerElement {

  static const CLASS_NAME = "AppView";

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
      .catchError((Error error) => print(error));

    // changing this JS value will alter the duration of slide transitions in <core-animated-pages>
    context['CoreStyle']['g']['transitions']['slideDuration'] = "250ms";
  }

  @override void attached() {
    super.attached();
    print("$CLASS_NAME::attached()");

    chordDisplayIterator = $["chord-iterator"];
  }

  void startSlideshow(Event event, var detail, Element target) {
    print("$CLASS_NAME::startSlideshow()");

    chordDisplayIterator.start();
  }

  void stopSlideshow(Event event, var detail, Element target) {
    print("$CLASS_NAME::stopSlideshow()");

    chordDisplayIterator.stop();
  }

  void pauseSlideshow(Event event, var detail, Element target) {
    print("$CLASS_NAME::pauseSlideshow()");

    chordDisplayIterator.pause();
  }

  void nextSlide(Event event, var detail, Element target) {
    print("$CLASS_NAME::nextSlide()");

    chordDisplayIterator.next();
  }

  void prevSlide(Event event, var detail, Element target) {
    print("$CLASS_NAME::prevSlide()");

    chordDisplayIterator.prev();
  }

  // prevent app reload on <form> submission
  void submit(Event event, var detail, Element target) {
    event.preventDefault();
  }
}

