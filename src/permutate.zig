const std = @import("std");
const testing = std.testing;

pub fn main() void {}

inline fn swap(comptime T: type, a: *T, b: *T) void {
    const tmp = a.*;
    a.* = b.*;
    b.* = tmp;
}

pub const PermutationError = error{ListTooLong};

/// Returns an iterator that iterates all the permutations of `list`.
/// `permutate(u8, slice_of_bytes)`
/// will return all permutations of slice_of_bytes followed by `null` as the last value.
/// If `list.len` is greater than 16 an error is returned.
pub fn permutate(comptime T: type, list: []T) PermutationError!PermutationIterator(T) {
    if (list.len > 16) return PermutationError.ListTooLong;

    return PermutationIterator(T){
        .list = list[0..],
        .size = @intCast(list.len),
        .state = [_]u4{0} ** 16,
        .stateIndex = 0,
        .first = true,
    };
}

pub fn PermutationIterator(comptime T: type) type {
    return struct {
        list: []T,
        size: u4,
        state: [16]u4,
        stateIndex: u4,
        first: bool,

        const Self = @This();

        pub fn next(self: *Self) ?[]T {
            if (self.first) {
                self.first = false;
                return self.list;
            }

            while (self.stateIndex < self.size) {
                if (self.state[self.stateIndex] < self.stateIndex) {
                    if (self.stateIndex % 2 == 0) {
                        swap(T, &self.list[0], &self.list[self.stateIndex]);
                    } else {
                        swap(T, &self.list[self.state[self.stateIndex]], &self.list[self.stateIndex]);
                    }

                    self.state[self.stateIndex] += 1;
                    self.stateIndex = 0;

                    return self.list;
                } else {
                    self.state[self.stateIndex] = 0;
                    self.stateIndex += 1;
                }
            }

            return null;
        }
    };
}

test "permutate []u8" {
    var input = "ab".*;

    var pit = try permutate(u8, input[0..]);
    try testing.expectEqualStrings("ab", pit.next().?);
    try testing.expectEqualStrings("ba", pit.next().?);
}

test "list too long" {
    var input = [_]u8{0} ** 17;

    var pit = permutate(u8, &input);

    try testing.expectError(PermutationError.ListTooLong, pit);
}

test "swap u32" {
    const exp_a: u32 = 5;
    const exp_b: u32 = 3;

    var a: u32 = 3;
    var b: u32 = 5;

    swap(u32, &a, &b);

    try testing.expectEqual(exp_a, a);
    try testing.expectEqual(exp_b, b);
}

test "swap u32 in slice" {
    const exp_a: u32 = 5;
    const exp_b: u32 = 3;

    var s = [_]u32{ 3, 5 };

    swap(u32, &s[0], &s[1]);

    try testing.expectEqual(exp_a, s[0]);
    try testing.expectEqual(exp_b, s[1]);
}

test "generates 10! perms" {
    var str = "0123456789".*;
    const expected: usize = 3628800;
    var count: usize = 0;
    var pit = try permutate(u8, str[0..]);

    while (pit.next()) |_| {
        count += 1;
    }

    try testing.expectEqual(expected, count);
}
