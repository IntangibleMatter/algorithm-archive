extends Mpde

func _ready() -> void:
	var queue : Queue = Queue.new()

	queue.enqueue(10)
	queue.enqueue("Hello, world")
	queue.enqueue(true)

	print(queue.dequeue())
	print(queue.size())
	print(queue.front())

class Queue extends Refcounted:
	var _list : Array = []

	func dequeue() -> Variant:
		return _list.pop_front()


	func enqueue(element: Variant) -> int:
		_list.append(element)
		return _list.size()


	func front() -> Variant:
		return _list[0]


	func size() -> int:
		return _list.size()
