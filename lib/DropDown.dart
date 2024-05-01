import 'package:flutter/material.dart';

class DropdownListTile extends StatefulWidget {
  final Widget title;
  final List<Widget> children;
  final Function(int index)? onChildTap;

  DropdownListTile({
    required this.title,
    required this.children,
    this.onChildTap,
  });

  @override
  _DropdownListTileState createState() => _DropdownListTileState();
}

class _DropdownListTileState extends State<DropdownListTile> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ListTile(
          title: widget.title,
          trailing: _isExpanded ? Icon(Icons.expand_less) : Icon(Icons.expand_more),
          onTap: () {
            setState(() {
              _isExpanded = !_isExpanded;
            });
          },
        ),
        if (_isExpanded)
          ..._buildChildren(),
      ],
    );
  }

  List<Widget> _buildChildren() {
    List<Widget> expandedChildren = [];
    for (int i = 0; i < widget.children.length; i++) {
      expandedChildren.add(
        GestureDetector(
          onTap: () {
            if (widget.onChildTap != null) {
              widget.onChildTap!(i);
            }
          },
          child: widget.children[i],
        ),
      );
    }
    return expandedChildren;
  }
}