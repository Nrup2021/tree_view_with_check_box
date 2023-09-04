import 'package:flutter/material.dart';
import 'package:tree_view_with_check_box/TreeNode.dart';
import 'package:tree_view_with_check_box/TreeView.dart';
void main() {
  final rootNode = TreeNode(
    label: 'Root',
    isExpanded: true,
    isSelected: false,
    children: [
      TreeNode(
        label: 'Category 1',
        isExpanded: false,
        isSelected: false,
        children: [
          TreeNode(
            label: 'Item 1.1',
            isSelected: false,
            children: [],
          ),
          TreeNode(
            label: 'Item 1.2',
            isSelected: false,
            children: [],
          ),
        ],
      ),
      TreeNode(
        label: 'Category 2',
        isExpanded: false,
        isSelected: false,
        children: [
          TreeNode(
            label: 'Item 2.1',
            isSelected: false,
            children: [],
          ),
        ],
      ),
    ],
  );

  runApp(MaterialApp(
    home: Scaffold(
      appBar: AppBar(
        title: const Text('Tree View with Checkbox'),
      ),
      body: TreeView(rootNode: rootNode),
    ),
  ));
}
