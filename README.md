# zig-permutate

Easy to use permutation generator for zig with zero allocations.

## What is it?

This is a package for zig containing a way to generate all permutations of a list of items. It does so using [Heap's Algorithm](https://en.wikipedia.org/wiki/Heap%27s_algorithm). 

It's implemented with an iterator using pretty much the same pattern as seen with for example `std.mem.split()`.

## Why?

I wanted a way to permutate a list in Zig to solve an advent of code problem. The few implementations I could find all used Allocators and returned all permutations at once instead of giving you each permutation one at a time. I wanted an allocation free soltion - and here it is.

## Example

Code works best, in my experience, by example. 

```
const std = @import("std");
const perm = @import("zig-permutate");

pub fn main() !void {
   // Find all combinations of the uneven numbers 1, 3 and 5
    var numbers = [_]u32{ 1, 3, 5 };

    // .permute() will return an error if the input list is too long.
    // The number of permutations are `N factorial` so unrealisticly high numbers are reached pretty quickly
    var iterator = try perm.permutate(u32, &numbers);

    // the .next() function returns the next permutation, and finally null when all iterations have been returned.
    while (iterator.next()) |p| {
        std.debug.print("{any}\n", .{p});
    }

    // The original list has been mutated as well
    std.debug.print("-----------\n", .{});
    std.debug.print("{any}\n", .{numbers});
}

```
Outputs:
```
{ 1, 3, 5 }
{ 3, 1, 5 }
{ 5, 1, 3 }
{ 1, 5, 3 }
{ 3, 5, 1 }
{ 5, 3, 1 }
-----------
{ 5, 3, 1 }
```

Notice that the original array `numbers` mutated during iterating the iterator. This is how allocations are avoided, doing the iterations in-place while tracking the state in the `PermutationIterator(T)`.