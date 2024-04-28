extends Node

func _ready() -> void:
	var stack : Stack = Stack.new()

	stack.push(10)
	stack.push("Hello, world")
	stack.push(true)

	print(stack.pop())
	print(stack.size())
	print(stack.top())

class Stack extends Refcounted:
	var _list : Array = []

	func pop() -> Variant:
		return _list.pop_back()


	func push(element: Variant) -> int:
		_list.append(element)
		return _list.size()


	func top() -> Variant:
		return _list[-1]


	func size() -> int:
		return _list.size()
