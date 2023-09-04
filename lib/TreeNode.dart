class TreeNode {
  final String label;
  bool isExpanded = false;
  bool isSelected = false;
  final List<TreeNode> children;

  TreeNode({
    required this.label,
    this.isExpanded = false,
    this.isSelected = false,
    required this.children,
  });
}
