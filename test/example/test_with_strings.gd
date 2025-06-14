extends GutTest


func test_strings_equal():
	assert_eq("This", "This", "This should still be This")

func test_string_not_equal():
	assert_ne("This", "That", "This should not be That")
