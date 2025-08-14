// Copyright 2022 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../shared/classes/classes.dart';
import '../../../shared/extensions.dart';
import './teams_view_model.dart';

class TeamScreen extends StatefulWidget {
  final int teamNumber;
  final TeamsViewModel viewModel;

  const TeamScreen({
    required this.teamNumber,
    required this.viewModel,
    super.key,
  });

  @override
  State<TeamScreen> createState() => _TeamScreenState();
}

class _TeamScreenState extends State<TeamScreen> {
  late Team team;
  final _formKey = GlobalKey<FormState>();
  late TextEditingController generalNotesController;
  late TextEditingController leftAutoNotesController;
  late TextEditingController rightAutoNotesController;

  final newLeftAutoController = TextEditingController();
  final newRightAutoController = TextEditingController();
  bool isLeftAutoInputValid = false;
  bool isRightAutoInputValid = false;

  @override
  void initState() {
    super.initState();
    // Team currently selected is passed by reference for ease of use.
    // However, this value should NOT be added to or modified in any way and the team should only be changed through the update function.
    // If this value is modified it probably won't update the database accordingly and thus the changes made won't be saved.
    // However, it is prob okay to change this value if you remember to call updateTeam() after to update the database.
    // In the event of a change, since this variable is a reference to the original, this variable's value will update with the change.
    team = widget.viewModel.teams.firstWhere(
      (t) => t.number == widget.teamNumber,
    );
    generalNotesController = TextEditingController(
      text: team.customTeamInfo.generalNotes,
    );
    leftAutoNotesController = TextEditingController(
      text: team.customTeamInfo.leftAutoNotes,
    );
    rightAutoNotesController = TextEditingController(
      text: team.customTeamInfo.rightAutoNotes,
    );

    newLeftAutoController.addListener(() {
      final text = newLeftAutoController.text.trim();
      final regex = RegExp(r"^[0-9]+ *[\+, ] *[0-9]+ *$");
      final valid = regex.hasMatch(text);
      if (valid != isLeftAutoInputValid) {
        setState(() {
          isLeftAutoInputValid = valid;
        });
      }
    });

    newRightAutoController.addListener(() {
      final text = newRightAutoController.text.trim();
      final regex = RegExp(r"^[0-9]+ *[\+, ] *[0-9]+ *$");
      final valid = regex.hasMatch(text);
      if (valid != isRightAutoInputValid) {
        setState(() {
          isRightAutoInputValid = valid;
        });
      }
    });
  }

  @override
  void dispose() {
    generalNotesController.dispose();
    newLeftAutoController.dispose();
    newRightAutoController.dispose();
    super.dispose();
  }

  Widget buildDropdown({
    required String label,
    required List<String> options,
    String? selectedValue,
    void Function(String?)? onChanged,
  }) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      value: selectedValue,
      items: options
          .map((option) => DropdownMenuItem(value: option, child: Text(option)))
          .toList(),
      onChanged: onChanged,
    );
  }

  List<String> get leftAutoPrograms {
    // FIX TO USE THE REGEX PROB
    return team.customTeamInfo.leftAuto
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();
  }

  void updateLeftAutoPrograms(List<String> items) {
    // TODO: FIX
    team.customTeamInfo.leftAuto = items.join(', ');
  }

  void submitLeftAuto() {
    setState(() {
      final newAuto = RegExp(r"[0-9]+")
          .allMatches(newLeftAutoController.text)
          .map((m) => m.group(0)!)
          .join("+");
      if (team.customTeamInfo.leftAuto.isEmpty) {
        team.customTeamInfo.leftAuto = newAuto;
      } else {
        team.customTeamInfo.leftAuto =
            "${team.customTeamInfo.leftAuto}, $newAuto";
      }
      updateTeam(team);
      newLeftAutoController.clear();
    });
  }

  void submitRightAuto() {
    setState(() {
      final newAuto = RegExp(r"[0-9]+")
          .allMatches(newRightAutoController.text)
          .map((m) => m.group(0)!)
          .join("+");
      if (team.customTeamInfo.rightAuto.isEmpty) {
        team.customTeamInfo.rightAuto = newAuto;
      } else {
        team.customTeamInfo.rightAuto =
            "${team.customTeamInfo.rightAuto}, $newAuto";
      }
      updateTeam(team);
      newRightAutoController.clear();
    });
  }

  void updateTeam(Team teamToUpdateWith) =>
      widget.viewModel.update.execute(teamToUpdateWith);

  @override
  Widget build(BuildContext context) {
    final constraints = MediaQuery.of(context);

    return Scaffold(
      appBar: AppBar(
        title: RichText(
          text: TextSpan(
            style: context.titleLarge?.copyWith(
              decoration: TextDecoration.underline,
            ),
            text: "${team.name} - #${team.number}",
            recognizer: TapGestureRecognizer()
              ..onTap = () async {
                final Uri url = Uri.parse(
                  'https://ftcscout.org/teams/${team.number}',
                );
                if (await canLaunchUrl(url)) {
                  await launchUrl(url);
                }
              },
          ),
        ),
        toolbarHeight: kToolbarHeight * 2,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text("General", style: context.titleLarge),
            const SizedBox(height: 10),
            Text("OPR: ${team.teamStats.opr}", style: context.bodyLarge),
            TextFormField(
              controller: generalNotesController,
              decoration: const InputDecoration(labelText: "Notes"),
              minLines: 1,
              maxLines: 5,
              keyboardType: TextInputType.text,
              onChanged: (value) => setState(() {
                team.customTeamInfo.generalNotes = value;
                updateTeam(team);
              }),
            ),
            const SizedBox(height: 20),
            Text("Auto", style: context.titleLarge),
            const SizedBox(height: 10),
            Text(
              "Auto OPR: ${team.teamStats.autoOpr}",
              style: context.bodyLarge,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Left Side
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Wrap(
                        spacing: 8,
                        runSpacing: 4,
                        children: [
                          for (final auto
                              in team.customTeamInfo.leftAuto
                                  .split(", ")
                                  .map((s) => s.trim())
                                  .where((s) => s.isNotEmpty)
                                  .toList())
                            Chip(
                              label: Text(auto),
                              deleteIcon: const Icon(Icons.close),
                              onDeleted: () {
                                setState(() {
                                  var autos = team.customTeamInfo.leftAuto
                                      .split(", ");
                                  autos.remove(auto);
                                  team.customTeamInfo.leftAuto = autos.join(
                                    ", ",
                                  );
                                  updateTeam(team);
                                });
                              },
                            ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: newLeftAutoController,
                              decoration: const InputDecoration(
                                labelText: "Add Left Auto (Spec. + Samp.)",
                                border: OutlineInputBorder(),
                              ),
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              validator: (value) {
                                if (value == null || value == "") return null;

                                if (!RegExp(
                                  r"^[0-9]+ *[\+, ] *[0-9]+ *$",
                                ).hasMatch(value)) {
                                  return "Enter as: Specimens+Samples (2+1) or similar";
                                }
                                return null;
                              },
                              onFieldSubmitted: (value) => {
                                if (isLeftAutoInputValid) submitLeftAuto(),
                              },
                            ),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton.icon(
                            icon: const Icon(Icons.add),
                            label: const Text("Add"),
                            onPressed: isLeftAutoInputValid
                                ? () {
                                    submitLeftAuto();
                                  }
                                : null, // disables the button
                          ),
                        ],
                      ),
                      TextFormField(
                        controller: leftAutoNotesController,
                        decoration: const InputDecoration(labelText: "Notes"),
                        minLines: 1,
                        maxLines: 5,
                        keyboardType: TextInputType.text,
                        onChanged: (value) => setState(() {
                          team.customTeamInfo.leftAutoNotes = value;
                          updateTeam(team);
                        }),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 20),
                // Right Side
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Wrap(
                        spacing: 8,
                        runSpacing: 4,
                        children: [
                          for (final auto
                              in team.customTeamInfo.rightAuto
                                  .split(", ")
                                  .map((s) => s.trim())
                                  .where((s) => s.isNotEmpty)
                                  .toList())
                            Chip(
                              label: Text(auto),
                              deleteIcon: const Icon(Icons.close),
                              onDeleted: () {
                                setState(() {
                                  var autos = team.customTeamInfo.rightAuto
                                      .split(", ");
                                  autos.remove(auto);
                                  team.customTeamInfo.rightAuto = autos.join(
                                    ", ",
                                  );
                                  updateTeam(team);
                                });
                              },
                            ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: newRightAutoController,
                              decoration: const InputDecoration(
                                labelText: "Add Right Auto (Spec. + Samp.)",
                                border: OutlineInputBorder(),
                              ),
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              validator: (value) {
                                if (value == null || value == "") return null;

                                if (!RegExp(
                                  r"^[0-9]+ *[\+, ] *[0-9]+ *$",
                                ).hasMatch(value)) {
                                  return "Enter as: Specimens+Samples (2+1) or similar";
                                }
                                return null;
                              },
                              onFieldSubmitted: (value) => {
                                if (isRightAutoInputValid) submitRightAuto(),
                              },
                            ),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton.icon(
                            icon: const Icon(Icons.add),
                            label: const Text("Add"),
                            onPressed: isRightAutoInputValid
                                ? () {
                                    submitRightAuto();
                                  }
                                : null, // disables the button
                          ),
                        ],
                      ),
                      TextFormField(
                        controller: rightAutoNotesController,
                        decoration: const InputDecoration(labelText: "Notes"),
                        minLines: 1,
                        maxLines: 5,
                        keyboardType: TextInputType.text,
                        onChanged: (value) => setState(() {
                          team.customTeamInfo.rightAutoNotes = value;
                          updateTeam(team);
                        }),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text("TeleOp", style: context.titleLarge),
            const SizedBox(height: 10),
            Text(
              "TeleOp OPR: ${team.teamStats.teleOpOpr}",
              style: context.bodyLarge,
            ),
            const SizedBox(height: 10),
            // CONTENT HERE
            const SizedBox(height: 20),
            Text("End Game", style: context.titleLarge),
            const SizedBox(height: 10),
            Text(
              "End Game OPR: ${team.teamStats.endGameOpr}",
              style: context.bodyLarge,
            ),
            const SizedBox(height: 10),
            buildDropdown(
              label: 'Ascent Level',
              options: ['', 'L1/Park', 'L2', 'L3'],
              selectedValue: team.customTeamInfo.ascentLevel,
              onChanged: (value) => setState(() {
                team.customTeamInfo.ascentLevel = value!;
                updateTeam(team);
              }),
            ),
            Text(
              widget.viewModel.teams
                  .firstWhere((t) => t.number == widget.teamNumber)
                  .customTeamInfo
                  .toJson()
                  .toString(),
            ),
            Text(
              widget.viewModel.teams
                  .firstWhere((t) => t.number == widget.teamNumber)
                  .teamStats
                  .toJson()
                  .toString(),
            ),
          ],
        ),
      ),
    );
  }
}
