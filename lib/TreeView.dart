import 'package:flutter/material.dart';

import 'TreeNode.dart';

class TreeView extends StatefulWidget {
  final TreeNode rootNode;

  const TreeView({super.key, required this.rootNode});

  @override
  _TreeViewState createState() => _TreeViewState();
}

class _TreeViewState extends State<TreeView> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CheckboxListTile(
          title: Text(widget.rootNode.label),
          value: widget.rootNode.isSelected,
          onChanged: (value) {
            setState(() {
              widget.rootNode.isSelected = value!;
              _updateChildrenSelection(widget.rootNode, value);
            });
          },
          controlAffinity: ListTileControlAffinity.leading,
        ),
        if (widget.rootNode.isExpanded)
          Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: Column(
              children: widget.rootNode.children.map((child) {
                return _TreeNodeWidget(
                  node: child,
                  onExpansionChanged: (isExpanded) {
                    setState(() {
                      child.isExpanded = isExpanded;
                    });
                  },
                  onSelectionChanged: (isSelected) {
                    setState(() {
                      child.isSelected = isSelected;
                      _updateParentSelection(child);
                    });
                  },
                );
              }).toList(),
            ),
          ),
      ],
    );
  }

  void _updateChildrenSelection(TreeNode node, bool isSelected) {
    node.isSelected = isSelected;
    for (var child in node.children) {
      child.isSelected = isSelected;
      _updateChildrenSelection(child, isSelected);
    }
  }

  void _updateParentSelection(TreeNode node) {
    if (node.children.isNotEmpty) {
      final allChildrenSelected =
          node.children.every((child) => child.isSelected);
      node.isSelected = allChildrenSelected;
    }

    TreeNode? parent = _findParent(node, widget.rootNode);
    while (parent != null) {
      final allSiblingsSelected =
          parent.children.every((sibling) => sibling.isSelected);
      parent.isSelected = allSiblingsSelected;
      parent = _findParent(parent, widget.rootNode);
    }
  }

  TreeNode? _findParent(TreeNode child, TreeNode parent) {
    if (parent.children.contains(child)) {
      return parent;
    }
    for (var node in parent.children) {
      final foundParent = _findParent(child, node);
      if (foundParent != null) {
        return foundParent;
      }
    }
    return null;
  }
}

class _TreeNodeWidget extends StatefulWidget {
  final TreeNode node;
  final Function(bool) onExpansionChanged;
  final Function(bool) onSelectionChanged;

  const _TreeNodeWidget({
    required this.node,
    required this.onExpansionChanged,
    required this.onSelectionChanged,
  });

  @override
  __TreeNodeWidgetState createState() => __TreeNodeWidgetState();
}

class __TreeNodeWidgetState extends State<_TreeNodeWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          title: Row(
            children: [
              GestureDetector(
                onTap: () {
                  widget.onExpansionChanged(!widget.node.isExpanded);
                },
                child: Icon(
                  widget.node.isExpanded
                      ? Icons.arrow_drop_down
                      : Icons.arrow_right,
                ),
              ),
              Checkbox(
                value: widget.node.isSelected,
                onChanged: (value) {
                  setState(() {
                    widget.node.isSelected = value!;
                    widget.onSelectionChanged(value!);
                  });
                },
              ),
              Text(widget.node.label),
            ],
          ),
        ),
        if (widget.node.isExpanded)
          Padding(
            padding: EdgeInsets.only(left: 16.0),
            child: Column(
              children: widget.node.children.map((child) {
                return _TreeNodeWidget(
                  node: child,
                  onExpansionChanged: widget.onExpansionChanged,
                  onSelectionChanged: widget.onSelectionChanged,
                );
              }).toList(),
            ),
          ),
      ],
    );
  }
}
