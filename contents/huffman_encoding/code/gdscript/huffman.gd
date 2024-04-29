extends Node


func _ready() -> void:
	var input_string := "bibbity bobbity"
	var tree := build_huffman_tree(input_string)
	var encoded := huffman_encode(input_string, tree)
	prints("input", input_string)
	prints("codebook", build_codebook(tree))
	prints("encoded", encoded)
	prints("decoded", huffman_decode(encoded, tree))


func huffman_encode(text: String, tree: TreeNode) -> String:
	var codebook := build_codebook(tree)
	var output := ""

	for chara in text:
		output += codebook[chara]

	return output


func huffman_decode(encoded: String, tree: TreeNode) -> String:
	var codebook := build_codebook(tree)
	var output := ""

	for chara in codebook.keys():
		codebook[codebook[chara]] = chara
		codebook.erase(chara)

	var substr := ""
	for chara in encoded:
		substr += chara
		if substr in codebook:
			output += codebook[substr]
			substr = ""

	return output


func build_huffman_tree(text: String) -> TreeNode:
	var char_counts := {}
	var tree_nodes : Array[TreeNode] = []

	for chara in text:
		char_counts[chara] = char_counts.get(chara, 0) + 1

	for chara in char_counts:
		var node := Leaf.new()
		node.chara = chara
		node.count = char_counts[chara]
		tree_nodes.append(node)

	tree_nodes.sort_custom(sort_tree)

	while tree_nodes.size() > 1:
		var branch := Branch.new()
		branch.left = tree_nodes.pop_back()
		branch.right = tree_nodes.pop_back()
		branch.count = branch.left.count + branch.right.count
		tree_nodes.append(branch)

		tree_nodes.sort_custom(sort_tree)

	return tree_nodes[0]


func build_codebook(tree: TreeNode, code := "") -> Dictionary:
	var codebook := {}

	if tree is Leaf:
		return {tree.chara: "0"}

	if tree.left is Branch:
		codebook.merge(build_codebook(tree.left, code + "0"))
	else:
		codebook[tree.left.chara] = code + "0"

	if tree.right is Branch:
		codebook.merge(build_codebook(tree.right, code + "1"))
	else:
		codebook[tree.right.chara] = code + "1"

	return codebook


func sort_tree(x: TreeNode, y: TreeNode) -> bool:
	return x.count > y.count


class TreeNode extends RefCounted:
	pass


class Leaf extends TreeNode:
	var count : int = 0
	var chara : String = ""


class Branch extends TreeNode:
	var count : int = 0
	var left: TreeNode
	var right: TreeNode
