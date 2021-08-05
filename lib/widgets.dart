import 'package:flutter/material.dart';
import 'package:sudoku/note.dart';

Text difficultyText(String text) {
  return Text(
    text,
    style: TextStyle(
      color: Color(0xffBDD0E1),
      fontSize: 20,
    ),
  );
}

class Tile extends StatelessWidget {
  final NoteState? state;
  final double? height;
  final VoidCallback? onTap;

  const Tile({Key? key, this.height, this.state, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: height,
      child: GestureDetector(
        onTapDown: (_) => onTap!(),
        child: Container(color: color),
      ),
    );
  }

  Color get color {
    switch (state) {
      case NoteState.ready:
        return Colors.black;
      case NoteState.missed:
        return Colors.red;
      case NoteState.tapped:
        return Colors.transparent;
      default:
        return Colors.black;
    }
  }
}

class Line extends AnimatedWidget {
  final int? lineNumber;
  final List<Note>? currentNotes;
  final Function(Note)? onTileTap;

  const Line({
    Key? key,
    this.currentNotes,
    this.lineNumber,
    this.onTileTap,
    Animation<double>? animation,
  }) : super(key: key, listenable: animation as Listenable);

  @override
  Widget build(BuildContext context) {
    Animation<double>? animation = super.listenable as Animation<double>?;

    //get heights
    double height = MediaQuery.of(context).size.height;
    double tileHeight = height / 4;

    //get only notes for that line
    List<Note> thisLineNotes = currentNotes!.where((note) => note.line == lineNumber).toList();

    //map notes to widgets
    List<Widget> tiles = thisLineNotes.map((note) {
      //specify note distance from top
      int index = currentNotes!.indexOf(note);
      double offset = (3 - index + animation!.value) * tileHeight;

      return Transform.translate(
        offset: Offset(0, offset),
        child: Tile(
          height: tileHeight,
          state: note.state,
          onTap: () => onTileTap!(note),
        ),
      );
    }).toList();

    return SizedBox.expand(
      child: Stack(
        children: tiles,
      ),
    );
  }
}

class LineDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: 1,
      color: Colors.white,
    );
  }
}
