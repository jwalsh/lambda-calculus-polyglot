import unittest
from lambda_calculus import lc_add, lc_mult, lc_map, lc_filter, lc_fold, lc_pair, lc_first, lc_second, lc_is_nil, lc_head, lc_tail, lc_true, lc_false, lc_if, lc_zero, lc_one, lc_two, lc_three, lc_four, lc_five, lc_six, lc_seven, lc_eight, lc_nine, lc_ten, factorial, list_to_church, church_to_list


class TestLambdaCalculus(unittest.TestCase):

    def test_arithmetic(self):
        # Testing addition
        self.assertEqual(church_to_int(lc_add(lc_one)(lc_two)), 3)
        # Testing multiplication
        self.assertEqual(church_to_int(lc_mult(lc_two)(lc_three)), 6)

    def test_pairs(self):
        # Testing pair creation and access
        my_pair = lc_pair(1)(2)
        self.assertEqual(lc_first(my_pair), 1)
        self.assertEqual(lc_second(my_pair), 2)

    def test_lists(self):
        # Testing list conversion and manipulation
        my_list = list_to_church([1, 2, 3])
        doubled_list = lc_map(lambda x: x * 2)(my_list)
        self.assertEqual(church_to_list(doubled_list), [2, 4, 6])

        filtered_list = lc_filter(lambda x: x > 1)(my_list)
        self.assertEqual(church_to_list(filtered_list), [2, 3])

        sum_list = lc_fold(lambda x: lambda y: x + y)(0)(my_list)
        self.assertEqual(sum_list, 6)

    def test_logical_operations(self):
        # Testing logical operations
        self.assertTrue(lc_if(lc_true)("yes")("no"))
        self.assertFalse(lc_if(lc_false)("yes")("no"))

    def test_factorial(self):
        # Testing factorial calculation
        self.assertEqual(
            church_to_int(factorial(lc_add(lc_two)(lc_succ(lc_two))))(), 120)


if __name__ == '__main__':
    unittest.main()
