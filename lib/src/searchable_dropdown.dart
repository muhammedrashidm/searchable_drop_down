import 'dart:async';
import 'dart:developer';
import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:searchable_drop_down/src/widget_textfield.dart';

import '/src/app_styles.dart';

class SearchableDropdownWidget extends StatefulWidget {
  const SearchableDropdownWidget({
    Key? key,
    required this.dropDownList,
    required this.onSelected,
    this.hint,
    this.defaultValue,
    this.functionValidate,
    this.onChanged,
    this.isReadOnly,
    this.outlineColor,
    this.bgColor,
    this.disabledColor,
    this.onFieldTap,
  }) : super(key: key);
  final List<String> dropDownList;
  final ValueChanged<String?> onSelected;
  final Function? onFieldTap;
  final ValueChanged<String?>? onChanged;
  final String? Function(String?)? functionValidate;
  final String? hint;
  final String? defaultValue;
  final bool? isReadOnly;
  final Color? outlineColor;
  final Color? disabledColor;
  final Color? bgColor;

  @override
  State<SearchableDropdownWidget> createState() =>
      _SearchableDropdownWidgetState();
}

class _SearchableDropdownWidgetState extends State<SearchableDropdownWidget>
    with AfterLayoutMixin {
  String _selectedOption = '', keyboardSelectedItem = '';
  var filteredOptions = [];
  final FocusNode _focusNode = FocusNode();
  int selectedIndex = -1;
  int optionsLength = 0;
  TextEditingController textFieldController = TextEditingController();

  _handleKeyEvent(RawKeyEvent keyEvent) {
    if (keyEvent is RawKeyDownEvent) {
      if (keyEvent.logicalKey == LogicalKeyboardKey.arrowUp) {
        setState(() {
          if (selectedIndex > 0) {
            selectedIndex--;
          }
        });
        //debugPrint("abc_arrowUp: $selectedIndex");
      } else if (keyEvent.logicalKey == LogicalKeyboardKey.arrowDown) {
        setState(() {
          if (selectedIndex < filteredOptions.length - 1) {
            selectedIndex++;
          }
        });
        //debugPrint("abc_arrowDown: ${widget.filteredOptions?.length}");
        //debugPrint("abc_arrowDown: $selectedIndex");
      } else if (keyEvent.logicalKey == LogicalKeyboardKey.enter) {
        if (selectedIndex >= 0 && selectedIndex < filteredOptions.length) {
          final selectedValue = filteredOptions[selectedIndex];
          setState(() {
            _selectedOption = selectedValue;
            keyboardSelectedItem = selectedValue;
          });
        }
        // debugPrint("abc_enter_key: $selectedIndex $selectedOption");
        widget.onSelected(_selectedOption);
        // return KeyEventResult.ignored;
        //debugPrint("abc_enter_key: $selectedIndex");
      }
    }
  }

  @override
  void initState() {
    super.initState();
    clearField();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    textFieldController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return RawKeyboardListener(
          focusNode: _focusNode,
          onKey: _handleKeyEvent,
          child: Autocomplete<String>(
            optionsBuilder: (TextEditingValue value) {
              filteredOptions = value.text.isEmpty
                  ? widget.dropDownList
                  : widget.dropDownList
                      .where((option) => option
                          .toLowerCase()
                          .contains(value.text.toLowerCase().trim()))
                      .toList();

              // Reset the selected index when the list changes
              if (widget.dropDownList.length != optionsLength) {
                selectedIndex = -1;
                optionsLength = widget.dropDownList.length;
              }

              return filteredOptions.map((e) => e as String).toList();
            },
            optionsViewBuilder: (context, onSelected, options) {
              //debugPrint('abc_optionsViewBuilder_val: $options');
              final scrollController =
                  ScrollController(initialScrollOffset: 0.0);

              WidgetsBinding.instance.addPostFrameCallback((_) {
                // Scroll to the selected index after the frame is built
                if (selectedIndex >= 0 &&
                    selectedIndex < filteredOptions.length) {
                  final selectedOffset = selectedIndex *
                      40.0; // Assuming each item has a fixed height of 40.0
                  final maxScrollExtent =
                      scrollController.position.maxScrollExtent;
                  final targetOffset =
                      selectedOffset.clamp(0.0, maxScrollExtent);
                  // scrollController.jumpTo(selectedOffset);
                  scrollController.animateTo(
                    targetOffset,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                }
              });

              return Align(
                alignment: Alignment.topLeft,
                child: Material(
                  shape: const RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.vertical(bottom: Radius.circular(4.0)),
                  ),
                  elevation: 5,
                  child: Container(
                    decoration: BoxDecoration(
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                          color: const Color(0xFFE8E8E8).withAlpha(40),
                          spreadRadius: 6,
                          blurRadius: 10,
                        ),
                      ],
                      color: Colors.white,
                      border: Border.all(
                        color: const Color(0xFFE8E8E8),
                        width: 0.3,
                      ),
                    ),
                    width: constraints.biggest.width,
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(
                        maxHeight:
                            300, // Set the maximum height of the dropdown menu
                      ),
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: options.length,
                        controller: scrollController,
                        // Use the scroll controller
                        physics: const AlwaysScrollableScrollPhysics(),
                        // Enable scrolling with any input method
                        itemBuilder: (context, index) {
                          final option = options.elementAt(index);
                          return Container(
                            color: index == selectedIndex
                                ? Colors.grey.shade100
                                : Colors.transparent,
                            child: ListTile(
                              onTap: () {
                                setState(() {
                                  selectedIndex = index;
                                  _selectedOption = option;
                                });
                                onSelected(option);
                              },
                              title: Text(
                                option,
                                style: AppStyles.alertNormal.copyWith(
                                  fontSize: 10,
                                  // color: Colors.black,
                                  color: index == selectedIndex
                                      ? Colors.black
                                      : Colors.black87,
                                  fontWeight: index == selectedIndex
                                      ? FontWeight.w500
                                      : FontWeight.normal,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              );
            },
            onSelected: (value) {
              setState(() {
                _selectedOption = value;
              });
              debugPrint("abc_onSelected: $selectedIndex $_selectedOption");
              widget.onSelected(_selectedOption);
            },
            fieldViewBuilder: (
              BuildContext context,
              TextEditingController fieldTextEditingController,
              FocusNode fieldFocusNode,
              VoidCallback onFieldSubmitted,
            ) {
              print('build field view');
              if (widget.isReadOnly ?? false) {
                fieldTextEditingController = textFieldController;
              }
              textFieldController = fieldTextEditingController;
              if (keyboardSelectedItem.isNotEmpty) {
                fieldTextEditingController.text = keyboardSelectedItem;
                keyboardSelectedItem = '';
              }
              // if the given default value is not null and the field is not read only.

              return TapRegion(
                onTapOutside: (event) {
                  print('outside');
                },
                child: TextFieldWidget(
                  bgColor: widget.bgColor,
                  outlineColor: widget.outlineColor,
                  disabledColor: widget.disabledColor,
                  isReadOnly: widget.isReadOnly ?? false,
                  focusNode: fieldFocusNode,
                  controller: fieldTextEditingController,
                  // widget.controller ?? fieldTextEditingController,
                  textCapitalization: TextCapitalization.words,
                  maxlines: 1,
                  functionValidate: widget.functionValidate,
                  hintText: widget.hint ?? '',
                  doOnChanged: (val) {
                    widget.isReadOnly ?? false
                        ? null //todo rest
                        : textOnChanged(val);
                  },
                  // onSubmitField: () {
                  //   widget.onSelected(fieldTextEditingController.text);
                  // },
                  onFieldTap: () {
                    if (widget.onFieldTap != null) {
                      widget.onFieldTap!();
                    }
                    debugPrint('abc_searchableDropDown onFieldTap');
                    setState(() {
                      // fieldTextEditingController.text = '';
                      log('currentTexteditingValue => ${fieldTextEditingController.text}');
                    });
                  },
                  suffixIconConstraints:
                      const BoxConstraints(minWidth: 23, maxHeight: 20),
                  suffixIcon: _selectedOption.isEmpty
                      ? Focus(
                          skipTraversal: true,
                          descendantsAreFocusable: false,
                          descendantsAreTraversable: false,
                          canRequestFocus: false,
                          child: Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                customBorder: const CircleBorder(),
                                onTap: () {
                                  setState(() {});
                                },
                                child: const Icon(
                                  Icons.keyboard_arrow_down_rounded,
                                  size: 15,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                        )
                      : Focus(
                          skipTraversal: true,
                          descendantsAreFocusable: false,
                          descendantsAreTraversable: false,
                          canRequestFocus: false,
                          child: Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                customBorder: const CircleBorder(),
                                onTap: () {
                                  widget.isReadOnly ?? false
                                      ? null
                                      : closeIconClick(
                                          fieldTextEditingController);
                                },
                                child: const Icon(
                                  Icons.close_rounded,
                                  size: 12,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  void clearField() {
    //log('abc_clear2');
    setState(() {
      _selectedOption = '';
      textFieldController.clear();
    });
  }

  @override
  Future<FutureOr<void>> afterFirstLayout(BuildContext context) async {
    _selectedOption = widget.defaultValue ?? '';
    textFieldController.text = widget.defaultValue ?? '';
  }

  void textOnChanged(String val) {
    setState(() {
      selectedIndex = 0;
    });
    if (widget.onChanged != null) {
      widget.onChanged!(val);
    }
  }

  void closeIconClick(TextEditingController fieldTextEditingController) {
    setState(() {
      _selectedOption = '';
      fieldTextEditingController.text = '';
    });
    widget.onSelected('');
    debugPrint("abc_text_close: ");
  }
}
