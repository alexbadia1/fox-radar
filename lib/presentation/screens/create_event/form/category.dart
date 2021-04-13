import 'package:communitytabs/constants/marist_color_scheme.dart';
import 'package:communitytabs/logic/blocs/blocs.dart';
import 'package:communitytabs/logic/constants/constants.dart';
import 'package:communitytabs/presentation/components/pickers/category_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:communitytabs/logic/cubits/cubits.dart';

import 'form_components/create_event_form_expansion_panel_buttons.dart';
import 'form_components/create_event_form_expansion_panel_labels.dart';

class Category extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double _textFormFieldHeight = MediaQuery.of(context).size.height * .07;

    return BorderTopBottom(
        child: BlocProvider<CategoryPickerCubit>(
            create: (context) => CategoryPickerCubit(),
            child: Builder(builder: (context) {
              return Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      FocusScope.of(context).unfocus();
                      BlocProvider.of<CategoryPickerCubit>(context)
                          .openExpansionPanelToCategoryPicker();
                    },
                    child: Container(
                      color: Color.fromRGBO(33, 33, 33, 1.0),
                      height: _textFormFieldHeight,
                      width: double.infinity,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          cLeftMarginSmall(context),

                          // Leading text, for hint text
                          ExpansionPanelCategoryTitle(
                            title: 'Category',
                            hintText: 'Add Category (Required)',
                            retrieveCategoryFromBlocCallback: (state) {
                              return state.eventModel.myCategory;
                            },
                          ),

                          Expanded(child: SizedBox()),

                          // Trailing text for date and time label
                          ExpansionPanelCategoryLabel(
                            retrieveCategoryFromBlocCallback:
                                (CreateEventState state) {
                              return state.eventModel.myCategory;
                            },
                          ),

                          cRightMarginSmall(context),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    color: Color.fromRGBO(33, 33, 33, 1.0),
                    child: Column(
                      children: <Widget>[
                        Builder(builder: (context) {
                          final CategoryPickerState _expansionPanelCubitState =
                              context.watch<CategoryPickerCubit>().state;

                          // Show DatePicker
                          if (_expansionPanelCubitState is CategoryPickerOpen) {
                            return CategoryPicker(
                              onSelectedItemChangedCallback: (int index) =>
                                  BlocProvider.of<CategoryPickerCubit>(context)
                                      .openExpansionPanelToCategoryPicker(
                                          newPickerIndex: index),
                            );
                          } // if
                          // Show empty container, this may not be necessary
                          else {
                            return Container(height: 0, width: 0);
                          } // else
                        }),

                        // Category Buttons
                        Builder(
                          builder: (BuildContext context) {
                            final CategoryPickerState
                                _expansionPanelCubitState =
                                context.watch<CategoryPickerCubit>().state;

                            if (_expansionPanelCubitState
                                is CategoryPickerOpen) {
                              return Container(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    ExpansionPanelCancelButton(
                                      onPressedCallback: () =>
                                          BlocProvider.of<CategoryPickerCubit>(
                                                  context)
                                              .closeExpansionPanel(),
                                    ),
                                    ExpansionPanelConfirmButton(
                                      onPressedCallback: () {
                                        BlocProvider.of<CategoryPickerCubit>(
                                                context)
                                            .closeExpansionPanel();
                                        BlocProvider.of<CreateEventBloc>(
                                                context)
                                            .add(CreateEventSetCategory(
                                                category: CATEGORIES[BlocProvider
                                                        .of<CategoryPickerCubit>(
                                                            context)
                                                    .state
                                                    .index]));
                                      },
                                    ),
                                  ],
                                ),
                              );
                            } // Show empty container, this may not be necessary
                            else {
                              return Container(height: 0, width: 0);
                            } // else
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              );
            })));
  }
} // CreateEventFormCategory
