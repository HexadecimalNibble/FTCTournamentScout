// Copyright 2022 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:math';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ftc_tournament_scout/src/utils/adaptive_column.dart';
import 'package:ftc_tournament_scout/src/utils/adaptive_components.dart';
import 'package:go_router/go_router.dart';

import '../../../shared/classes/classes.dart';
import '../../../shared/extensions.dart';
import '../../../shared/views/adaptive_image_card.dart';
import '../../../shared/views/views.dart';
import 'event_teams.dart';
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
  late TextEditingController notesController;
  late TextEditingController leftAutoController;

  final newLeftAutoItemController = TextEditingController();
  bool isLeftAutoInputValid = false;

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
    notesController = TextEditingController(text: team.customTeamInfo.notes);
    leftAutoController = TextEditingController(
      text: team.customTeamInfo.leftAuto,
    );

    newLeftAutoItemController.addListener(() {
      final text = newLeftAutoItemController.text.trim();
      final regex = RegExp(r"^[0-9]+ *[\+, ] *[0-9]+$");
      final valid = regex.hasMatch(text);
      if (valid != isLeftAutoInputValid) {
        setState(() {
          isLeftAutoInputValid = valid;
        });
      }
    });
  }

  @override
  void dispose() {
    notesController.dispose();
    leftAutoController.dispose();
    newLeftAutoItemController.dispose();
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

  // void _saveTeam() {
  //   if (_formKey.currentState!.validate()) {
  //     widget.viewModel.update.execute(team);
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(
  //         content: Text('Team data saved.'),
  //         showCloseIcon: true,
  //       ),
  //     );
  //   }
  // }

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
      // updateLeftAutoPrograms([...leftAutoPrograms, RegExp(r"[0-9]+").allMatches(newLeftAutoItemController.text).map((m) => m.group(0)!).join("+")],);
      final newAuto = RegExp(r"[0-9]+")
          .allMatches(newLeftAutoItemController.text)
          .map((m) => m.group(0)!)
          .join("+");
      if (team.customTeamInfo.leftAuto.isEmpty) {
        team.customTeamInfo.leftAuto = newAuto;
      } else {
        team.customTeamInfo.leftAuto =
            "${team.customTeamInfo.leftAuto}, $newAuto";
      }
      updateTeam(team);
      newLeftAutoItemController.clear();
    });
  }

  void updateTeam(Team teamToUpdateWith) =>
      widget.viewModel.update.execute(teamToUpdateWith);

  @override
  Widget build(BuildContext context) {
    final constraints = MediaQuery.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("${team.name} - #${team.number}"),
        toolbarHeight: kToolbarHeight * 2,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text("General", style: context.titleLarge),
            const SizedBox(height: 10),
            TextFormField(
              controller: notesController,
              decoration: const InputDecoration(labelText: "Notes"),
              minLines: 1,
              maxLines: 5,
              keyboardType: TextInputType.text,
              onChanged: (value) => setState(() {
                team.customTeamInfo.notes = value;
                updateTeam(team);
              }),
            ),
            const SizedBox(height: 20),
            Text("Auto", style: context.titleLarge),
            const SizedBox(height: 10),
            Row(
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
                                // final updated = [...leftAutoPrograms]..remove(auto);
                                setState(() {
                                  // updateLeftAutoPrograms(updated);
                                  var autos = team.customTeamInfo.leftAuto
                                      .split(", ");
                                  // print("auto ${auto}; autos: ${autos}");
                                  // print(autos.remove(auto));
                                  // print("autos ${autos}");
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
                              controller: newLeftAutoItemController,
                              decoration: const InputDecoration(
                                labelText: "Add Left Auto (Spec. + Samp.)",
                                border: OutlineInputBorder(),
                              ),
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              validator: (value) {
                                if (value == null || value == "") return null;

                                if (!RegExp(
                                  r"^[0-9]+ *[\+, ] *[0-9]+$",
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
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                // Right Side
                Expanded(
                  child: buildDropdown(
                    label: 'Right Option',
                    options: ['Option 1', 'Option 2', 'Option 3'],
                    onChanged: (value) {},
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text("End Game", style: context.titleLarge),
            const SizedBox(height: 10),
            buildDropdown(
              label: 'Select End Game Option',
              options: ['Option 1', 'Option 2', 'Option 3'],
              onChanged: (value) {},
            ),
            Text(team.customTeamInfo.toJson().toString()),
          ],
        ),
      ),
    );
  }
}
