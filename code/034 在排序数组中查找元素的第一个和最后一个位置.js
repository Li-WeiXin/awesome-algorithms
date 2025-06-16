/**
 * 题号：34
 * 给你一个按照非递减顺序排列的整数数组 `nums`，和一个目标值 `target`。请你找出给定目标值在数组中的开始位置和结束位置。
 * 难度： 中等
 * https://leetcode.cn/problems/find-first-and-last-position-of-element-in-sorted-array/
 */

/**
 * @param {number[]} nums
 * @param {number} target
 * @return {number[]}
 */
var lowerBound = function (nums, target) {
  let left = 0,
    right = nums.length - 1; // 闭区间 [left, right]
  while (left <= right) {
    // 区间不为空
    // 循环不变量：
    // nums[left-1] < target
    // nums[right+1] >= target
    const mid = Math.floor((left + right) / 2);
    if (nums[mid] >= target) {
      right = mid - 1; // 范围缩小到 [left, mid-1]
    } else {
      left = mid + 1; // 范围缩小到 [mid+1, right]
    }
  }
  // 循环结束后 left = right+1
  // 此时 nums[left-1] < target 而 nums[left] = nums[right+1] >= target
  // 所以 left 就是第一个 >= target 的元素下标
  return left;
};

var searchRange = function (nums, target) {
  const start = lowerBound(nums, target);
  if (start === nums.length || nums[start] !== target) {
    return [-1, -1]; // nums 中没有 target
  }
  // 如果 start 存在，那么 end 必定存在
  const end = lowerBound(nums, target + 1) - 1;
  return [start, end];
};
