// // Copyright 2022 The Flutter Authors. All rights reserved.
// // Use of this source code is governed by a BSD-style license that can be
// // found in the LICENSE file.

// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// import '../../../shared/classes/classes.dart';
// import '../../../shared/extensions.dart';
// import '../../../shared/playback/bloc/bloc.dart';
// import '../../../shared/views/image_clipper.dart';
// import '../../../shared/views/views.dart';

// class EventTeams extends StatelessWidget {
//   const EventTeams({
//     super.key,
//     required this.event
//   });

//   final Event event;

//   @override
//   Widget build(BuildContext context) {
//     return AdaptiveTable<Team>(
//       items: event.teams,
//       breakpoint: 450,
//       columns: const [
//         DataColumn(
//           label: Padding(padding: EdgeInsets.only(left: 20), child: Text('#')),
//         ),
//         DataColumn(label: Text('Name')),
//         DataColumn(
//           label: Padding(
//             padding: EdgeInsets.only(right: 10),
//             child: Text('OPR'),
//           ),
//         ),
//       ],
//       rowBuilder: (context, index) => DataRow.byIndex(
//         index: index,
//         cells: [
//           DataCell(Text(event.teams[index].number.toString())),
//           DataCell(Text(event.teams[index].name)),
//           DataCell(Text(event.teams[index].opr.toString()))
//           // DataCell(
//           //   HoverableSongPlayButton(
//           //     hoverMode: HoverMode.overlay,
//           //     song: event.teams[index],
//           //     child: Center(
//           //       child: Text(
//           //         (index + 1).toString(),
//           //         textAlign: TextAlign.center,
//           //       ),
//           //     ),
//           //   ),
//           // ),
//           // DataCell(
//           //   Row(
//           //     children: [
//           //       Padding(
//           //         padding: const EdgeInsets.all(2),
//           //         child: ClippedImage(event.teams[index].image.image),
//           //       ),
//           //       const SizedBox(width: 10),
//           //       Expanded(child: Text(event.songs[index].title)),
//           //     ],
//           //   ),
//           // ),
//           // DataCell(Text(event.teams[index].name)),
//         ],
//       ),
//       itemBuilder: (song, index) {
//         return ListTile(
//           // onTap: () => BlocProvider.of<PlaybackBloc>(
//           //   context,
//           // ).add(PlaybackEvent.changeSong(song)),
//           // leading: ClippedImage(song.image.image),
//           // title: Text(song.title),
//           // subtitle: Text(song.length.toHumanizedString()),
//         );
//       },
//     );
//   }
// }
