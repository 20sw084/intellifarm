library appbar_dropdown;

import 'package:flutter/material.dart';
import 'package:intellifarm/external_libs/appbar_dropdown/src/mobile.dart';



/// A dropdown button that shows a menu when pressed.
/// 
/// Use it like this :
/// 
///   return Scaffold(
///          appBar: AppBar(
///            flexibleSpace: AppBarDropdown(
///              items: [ "User 1", "User 2", "User 3" ]
///              selected: "User 2",
///              title: ( (user) => user.toString() ),
///              onClick: ( (user) => print(user) ),
///           ),
class AppbarDropdown<T> extends StatefulWidget {

  final List<T> items;
  final T? selected;
  final Function(T)? onClick;
  /// title is a function that returns the String to be displayed as the AppBar title, and as the list item labels
  /// eg. `(T item) => item.toString()` or `(e) => e.name` 
  final String Function(T) title;
  /// optional parameter margin can be set to make more space if you have 
  /// action buttons in your app bar, or if your list item titles are 
  /// especially short (or long), default is EdgeInsets.fromLTRB(60, 0, 60, 0)
  final EdgeInsets margin;
  /// dialogInsetPadding lets you specify padding for the dropdown itself
  /// default is EdgeInsets.fromLTRB(0, 0, 0, 40.0)
  final EdgeInsets dialogInsetPadding;
  /// dropdownAppBarColor can be overridden, defaults to `Theme.of(context).scaffoldBackgroundColor`
  final Color? dropdownAppBarColor;

  const AppbarDropdown({super.key,
    required this.items,
    this.selected,
    this.onClick,
    required this.title,
    this.dropdownAppBarColor,
    margin,
  }) : 
    margin = const EdgeInsets.fromLTRB(0, 0, 0, 0), 
    dialogInsetPadding = const EdgeInsets.fromLTRB(0, 0, 0, 40.0);

  @override
  // ignore: no_logic_in_create_state
  AppbarDropdownState<T> createState() => AppbarDropdownState<T>(selected: selected);
}


class AppbarDropdownState<T> extends State<AppbarDropdown<T>> {

  T? selected;
  AppbarDropdownState({ required this.selected });

  String _buildTitle(T? item) {
    return item !=null ? widget.title( item ) : '';
  }

  @override
  Widget build(BuildContext context) {

    return Container(
        color: widget.dropdownAppBarColor ?? Theme.of(context).scaffoldBackgroundColor,
        margin: widget.margin,
        height: AppBar().preferredSize.height,
          child: InkWell(
              customBorder: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext c) => _appbarDropdownList(
                    items: widget.items,
                    currentTitle: _buildTitle(selected),
                ),
              );
            },
            child: Row(
              children: [
                const Spacer(flex: 1),
                Expanded(
                  flex: 2,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      _buildTitle(selected),
                      //'Test',
                      style: Theme.of(context).textTheme.titleLarge,
                      overflow: TextOverflow.clip,
                      softWrap: false,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                // const Spacer(),
                const Icon(Icons.arrow_drop_down),
                const Spacer(),
              ],
            ),
          ),
    );
  }

  
  Dialog _appbarDropdownList({
    required List<T> items,
    required String currentTitle,
  }) {

      return Dialog(
        insetPadding: widget.dialogInsetPadding,
        elevation: 8,
        child: PointerInterceptor(
          child: Container(
            color: widget.dropdownAppBarColor ?? Theme.of(context).scaffoldBackgroundColor,
            child: Column( 
            
            children: [ 

              InkWell(
                onTap: () {
                  // if they click the header, then just close the dropdown
                  Navigator.of(context, rootNavigator: true).pop();
                },
                child: Container( 
                  color: AppBar().backgroundColor,
                  margin: widget.margin,
                  height: AppBar().preferredSize.height,
                  child: Row( 
                    children: [
                      const Spacer( flex: 2),
                      Expanded( flex: 4,
                        child: Text( 
                          currentTitle,
                          style: Theme.of(context).textTheme.titleLarge,
                          overflow: TextOverflow.clip,
                          softWrap: false,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const Spacer(),
                      const Icon(Icons.arrow_drop_down_circle),
                      const Spacer(),
                    ],
                  ),
                ),
              ),

             // Container(height: 4, color: Colors.grey[300]),
              
              Expanded( child: ListView(
                shrinkWrap: true,
                children: <Widget>[
                  const SizedBox(height: 20),
                  ...items.map((e) => _buildRow( context: context, item: e) ), 
                  const SizedBox(height: 20),
                ],
              ), ),

            ],
          ), 
        ),
        ),
      );
    }

    Widget _buildRow({
      required BuildContext context,
      required T item,
    }) {

      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
            children: <Widget>[
              InkWell(
                onTap: () {
                  Navigator.of(context, rootNavigator: true).pop();
                  setState( () {
                    selected = item;
                  });
                  if (widget.onClick!=null) widget.onClick!(item);
                },
                child: Padding( 
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: <Widget>[
                      const Spacer(),
                      Flexible(flex: 12, child: Text( _buildTitle(item), overflow: TextOverflow.ellipsis, ),),
                      const Spacer(),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 6),
              Container(height: 2, color: Colors.grey[300]),
              const SizedBox(height: 6),
            ],
          ),
      );
    }




}


