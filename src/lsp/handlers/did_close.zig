//! Handler for LSP `textDocument/didClose` notifications.

const std = @import("std");
const Allocator = std.mem.Allocator;

/// Handler for `textDocument/didClose` notifications.
pub fn handler(comptime ServerType: type) type {
    return struct {
        pub fn call(self: *ServerType, params_value: ?std.json.Value) Allocator.Error!void {
            const params = params_value orelse return;
            const obj = switch (params) {
                .object => |o| o,
                else => return,
            };

            const text_doc_value = obj.get("textDocument") orelse return;
            const text_doc = switch (text_doc_value) {
                .object => |o| o,
                else => return,
            };

            const uri_value = text_doc.get("uri") orelse return;
            const uri = switch (uri_value) {
                .string => |s| s,
                else => return,
            };

            self.remove(uri);
        }
    };
}
