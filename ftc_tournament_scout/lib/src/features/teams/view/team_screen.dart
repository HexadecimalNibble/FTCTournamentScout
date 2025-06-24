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

  const TeamScreen({required this.teamNumber, required this.viewModel, super.key});

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
    team = widget.viewModel.teams.firstWhere((t) => t.number == widget.teamNumber);
    notesController = TextEditingController(text: team.customTeamInfo.notes);
    leftAutoController = TextEditingController(text: team.customTeamInfo.leftAuto);

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

  void _saveTeam() {
    if (_formKey.currentState!.validate()) {
      widget.viewModel.update.execute(team);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Team data saved.'),
          showCloseIcon: true,
        ),
      );
    }
  }

  List<String> get leftAutoPrograms {
  return team.customTeamInfo.leftAuto
      .split(',')
      .map((e) => e.trim())
      .where((e) => e.isNotEmpty)
      .toList();
}

void updateLeftAutoPrograms(List<String> items) {
  team.customTeamInfo.leftAuto = items.join(', ');
}


  @override
  Widget build(BuildContext context) {
    final constraints = MediaQuery.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("${team.name} - #${team.number}"),
        toolbarHeight: kToolbarHeight * 2,
        actions: [
          IconButton(
            onPressed: _saveTeam,
            icon: const Icon(Icons.save),
          ),
        ],
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
                          for (final entry in leftAutoPrograms)
                            Chip(
                              label: Text(entry),
                              deleteIcon: const Icon(Icons.close),
                              onDeleted: () {
                                final updated = [...leftAutoPrograms]..remove(entry);
                                setState(() {
                                  updateLeftAutoPrograms(updated);
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
                                labelText: "Add Auto (Spec. + Samp.)",
                                border: OutlineInputBorder(),
                              ),
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                              validator: (value) {
                                if (value == null || value == "") {
                                  return null;
                                }

                                if (!RegExp(r"^[0-9]+ *[\+, ] *[0-9]+$").hasMatch(value)) {
                                  return "Enter as: Specimens+Samples (e.g. 2 + 1)";
                                }
                                return null;
                              },
                              onFieldSubmitted: (value) => {
                                if (isLeftAutoInputValid) {
                                  setState(() {
                                    updateLeftAutoPrograms([...leftAutoPrograms, RegExp(r"[0-9]+").allMatches(newLeftAutoItemController.text).map((m) => m.group(0)!).join("+")],);
                                    newLeftAutoItemController.clear();
                                  })
                                }
                              },
                            ),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton.icon(
                            icon: const Icon(Icons.add),
                            label: const Text("Add"),
                            onPressed: isLeftAutoInputValid
                                ? () {
                                    final value = RegExp(r"[0-9]+").allMatches(newLeftAutoItemController.text).map((m) => m.group(0)!).join("+");
                                    final updated = [...leftAutoPrograms, value];
                                    setState(() {
                                      updateLeftAutoPrograms(updated);
                                      newLeftAutoItemController.clear();
                                    });
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
                    onChanged: (value) {
                    },
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
              onChanged: (value) {
              },
            ),
            Text(team.customTeamInfo.toJson().toString())
          ],
        ),
      ),
    );
  }
}
