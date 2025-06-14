extends GutTest


func test_one_equals_one():
	assert_eq(1, 1, "One should equal one")
	
func test_one_is_less_than_two():
	assert_lt(1, 2, "One should be less than two")
	
func test_one_is_greater_than_zero():
	assert_gt(1, 0, "One should be greather than three")
