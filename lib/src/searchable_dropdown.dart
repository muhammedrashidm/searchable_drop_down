import 'dart:async';
import 'dart:developer';

import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:search_drop_down/src/widget_textfield.dart';

import '/src/app_styles.dart';


class SearchableDropdownWidget extends StatefulWidget {
  SearchableDropdownWidget({
    Key? key,
    required this.dropDownList,
    required this.onSelected,
    this.hint,
    this.controller,
    this.defaultValue,
    this.functionValidate,
    this.filteredOptions,
    this.focusNode,
    this.tag,
    this.clearField,
    this.textOnChanged,
    this.isReadOnly,
    this.outlineColor,
    this.bgColor,
    this.disabledColor,
    this.onFieldTap,
  }) : super(key: key);
  final List dropDownList;
  List? filteredOptions;
  final ValueChanged<String?> onSelected;
  final Function? onFieldTap;
  final ValueChanged<String?>? textOnChanged;
  final String? Function(String?)? functionValidate;
  final String? hint;
  final String? defaultValue;
  final String? tag;
  FocusNode? focusNode;
  TextEditingController? controller;
  final bool? clearField;
  final bool? isReadOnly;
  final Color? outlineColor;
  final Color? disabledColor;
  final Color? bgColor;

  @override
  State<SearchableDropdownWidget> createState() => SearchableDropdownWidgetState();
}

class SearchableDropdownWidgetState extends State<SearchableDropdownWidget> with AfterLayoutMixin {
  String selectedOption = '', selectedOptionVal = '';

  // List filteredOptions = [];
  final FocusNode _focusNode = FocusNode();
  int selectedIndex = -1;
  int optionsLength = 0;

  String? keyboardSelectedItem = '';

  TextEditingController textFieldController = TextEditingController();

  bool stopClear = false;

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
          if (widget.filteredOptions != null && selectedIndex < widget.filteredOptions!.length - 1) {
            selectedIndex++;
          }
        });
        //debugPrint("abc_arrowDown: ${widget.filteredOptions?.length}");
        //debugPrint("abc_arrowDown: $selectedIndex");
      } else if (keyEvent.logicalKey == LogicalKeyboardKey.enter) {
        if (widget.filteredOptions != null &&
            selectedIndex >= 0 &&
            selectedIndex < widget.filteredOptions!.length) {
          final selectedValue = widget.filteredOptions![selectedIndex];
          setState(() {
            selectedOption = selectedValue;
            selectedOptionVal = selectedValue;
            // widget.controller?.text = selectedValue;
            keyboardSelectedItem = selectedValue;
          });
        }
        // debugPrint("abc_enter_key: $selectedIndex $selectedOption");
        widget.onSelected(selectedOption);
        // return KeyEventResult.ignored;
        //debugPrint("abc_enter_key: $selectedIndex");
      }
    }
  }

  @override
  void initState() {
    super.initState();
    // filteredOptions = widget.filteredOptions ?? [];

    // if (filteredOptions.isEmpty) {
    //   filteredOptions = widget.dropDownList;
    // }
    clearField();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // debugPrint('searchable dropdown widget built - keyboard focus: ${_focusNode.hasFocus}');
    //debugPrint('Options: ${widget.filteredOptions}');
    //debugPrint('Options: ${widget.dropDownList}');

    return LayoutBuilder(builder: (context, constraints) {
      // // set a minimum height for the dropdown menu
      // double minMenuHeight = 50.0;
      //
      // // calculate the maximum height for the dropdown menu
      // double maxMenuHeight = Get.height - constraints.maxHeight;
      // if (maxMenuHeight < minMenuHeight) {
      //   maxMenuHeight = minMenuHeight;
      // }

      return RawKeyboardListener(
        focusNode: _focusNode,
        onKey: _handleKeyEvent,
        child: Autocomplete<String>(
          optionsBuilder: (TextEditingValue value) {
            //debugPrint('abc_optionsBuilder_val: $value');
            widget.filteredOptions = value.text.isEmpty
                ? widget.dropDownList
                : widget.dropDownList
                    .where((option) => option.toLowerCase().contains(value.text.toLowerCase().trim()))
                    .toList();

            //debugPrint('abc_optionsLength: $optionsLength');
            //debugPrint('abc_original_optionsLength: ${widget.dropDownList.length}');
            //debugPrint('abc_filtered_optionsLength: ${widget.filteredOptions?.length}');

            // Reset the selected index when the list changes
            if (widget.dropDownList.length != optionsLength) {
              selectedIndex = -1;
              optionsLength = widget.dropDownList.length;
            }

            return widget.filteredOptions!.map((e) => e as String).toList();
          },
          optionsViewBuilder: (context, onSelected, options) {
            //debugPrint('abc_optionsViewBuilder_val: $options');
            final scrollController = ScrollController(initialScrollOffset: 0.0);

            WidgetsBinding.instance.addPostFrameCallback((_) {
              // Scroll to the selected index after the frame is built
              if (widget.filteredOptions != null &&
                  selectedIndex >= 0 &&
                  selectedIndex < widget.filteredOptions!.length) {
                final selectedOffset =
                    selectedIndex * 40.0; // Assuming each item has a fixed height of 40.0
                final maxScrollExtent = scrollController.position.maxScrollExtent;
                final targetOffset = selectedOffset.clamp(0.0, maxScrollExtent);
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
                  borderRadius: BorderRadius.vertical(bottom: Radius.circular(4.0)),
                ),
                elevation: 8,
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
                    border: Border.all(color: const Color(0xFFE8E8E8), width: 0.3),
                  ),
                  width: constraints.biggest.width,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxHeight: 300, // Set the maximum height of the dropdown menu
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
                          color: index == selectedIndex ? Colors.grey.shade100 : Colors.transparent,
                          child: ListTile(
                            onTap: () {
                              setState(() {
                                //log('abc_index: $selectedIndex');
                                selectedIndex = index;
                                selectedOption = option;
                                selectedOptionVal = option;
                              });
                              onSelected(option);
                            },
                            title: Text(
                              option,
                              style: AppStyles.alertNormal.copyWith(
                                fontSize: 10,
                                // color: Colors.black,
                                color: index == selectedIndex ? Colors.black : Colors.black87,
                                fontWeight: index == selectedIndex ? FontWeight.w500 : FontWeight.normal,
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
              selectedOption = value;
              selectedOptionVal = value;
              // widget.controller?.text = value;
            });
            debugPrint("abc_onSelected: $selectedIndex $selectedOption");
            widget.onSelected(selectedOption);
          },
          fieldViewBuilder: (BuildContext context, TextEditingController fieldTextEditingController,
              FocusNode fieldFocusNode, VoidCallback onFieldSubmitted) {
            if (widget.isReadOnly ?? false) {
              fieldTextEditingController = widget.controller ?? textFieldController;
            }
            textFieldController = fieldTextEditingController;

            widget.focusNode = fieldFocusNode;
            widget.controller = fieldTextEditingController;

            if (keyboardSelectedItem != null && keyboardSelectedItem!.isNotEmpty) {
              fieldTextEditingController.text = keyboardSelectedItem!;
              keyboardSelectedItem = null;
            }

            //debugPrint("abc_clearField1: ${widget.clearField}");
            //debugPrint("abc_clearField2: $stopClear");
            if (stopClear) {
              stopClear = widget.clearField ?? false;
            }
            if ((widget.clearField != null && widget.clearField!) && !stopClear) {
              // if (selectedOption != selectedOptionVal) {
              // setState(() {
              selectedOption = '';
              // widget.controller?.text = '';
              fieldTextEditingController.text = '';
              //debugPrint("abc_clearField_inside: ");
              stopClear = true;
              // });
              // },
            }

            //using custom focus node instead of fieldFocusNode
            if (widget.focusNode != null) {
              widget.focusNode!.addListener(() {
                // checking if the autocomplete field widget has focus. Not the dropdown item.
                if (widget.focusNode!.hasFocus) {
                  setState(() {
                    //debugPrint("abc_list_length: ${widget.dropDownList.length}");
                    //debugPrint("abc_filtered_list_length: ${widget.filteredOptions?.length}");
                  });
                } else {
                  if (selectedOption != selectedOptionVal) {
                    var dontClearFieldWhenFocusedOut = widget.tag == "kyc_employer" ||
                        widget.tag == "wu_state" ||
                        widget.tag == "wu_city" ||
                        widget.tag == "wu_branch";
                    if (!dontClearFieldWhenFocusedOut) {
                      setState(() {
                        selectedOption = '';
                        // widget.controller?.text = '';
                        fieldTextEditingController.text = '';
                        //debugPrint("abc_text_outOfFocus: ");
                      });
                    }
                  }
                }
              });
            }
// if the given default value is not null and the field is not read only.

            return TextFieldWidget(
              bgColor: widget.bgColor,
              outlineColor: widget.outlineColor,
              disabledColor: widget.disabledColor,
              isReadOnly: widget.isReadOnly ?? false,
              focusNode: widget.focusNode,
              //fieldFocusNode,
              controller: widget.isReadOnly ?? false ? widget.controller : fieldTextEditingController,
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
              suffixIconConstraints: const BoxConstraints(minWidth: 23, maxHeight: 20),
              suffixIcon: selectedOption.isEmpty
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
                                  : closeIconClick(fieldTextEditingController);
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
              // Focus(
              //    skipTraversal: true,
              //    descendantsAreFocusable: false,
              //    descendantsAreTraversable: false,
              //    child: Padding(
              //      padding: const EdgeInsets.only(right: 10),
              //      child: Material(
              //        color: Colors.transparent,
              //        child: InkWell(
              //          customBorder: const CircleBorder(),
              //          onTap: () {
              //            widget.isReadOnly ?? false
              //                ? null
              //                : closeIconClick(fieldTextEditingController);
              //          },
              //          child: const Icon(
              //            Icons.close_rounded,
              //            size: 12,
              //            color: Colors.black,
              //          ),
              //        ),
              //      ),
              //    ),
              //  ),
            );
          },
        ),
      );
    });
  }

  void setFieldFocus() {
    FocusScope.of(context).requestFocus(widget.focusNode);
  }

  bool getFieldFocus() {
    if (widget.focusNode!.hasFocus) {
      return true;
    } else {
      return false;
    }
  }

  void clearField() {
    //log('abc_clear2');
    setState(() {
      selectedOption = '';
      selectedOptionVal = '';
      widget.controller?.clear();
      textFieldController.text = '';
    });
  }

  @override
  Future<FutureOr<void>> afterFirstLayout(BuildContext context) async {
    // log('abc_search_dropdown afterFirstLayout ');
    selectedOption = widget.defaultValue ?? '';
    selectedOptionVal = widget.defaultValue ?? '';
    textFieldController.text = widget.defaultValue ?? '';

    // widget.controller?.text = widget.defaultValue ?? '';
  }

  textOnChanged(String val) {
    setState(() {
      //debugPrint("abc_text_changed: $val");
      selectedIndex = 0;
      selectedOptionVal = val;
    });
    if (widget.textOnChanged != null) {
      widget.textOnChanged!(val);
    }
  }

  closeIconClick(TextEditingController fieldTextEditingController) {
    setState(() {
      selectedOption = '';
      // widget.controller?.text = '';
      fieldTextEditingController.text = '';
      //debugPrint("abc_text_close: ");
    });
    widget.onSelected('');
    debugPrint("abc_text_close: ");
  }
}
