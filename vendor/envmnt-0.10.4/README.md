# envmnt (vendored, build-std compatibility fixes)

Vendored copy of [`envmnt` 0.10.4](https://github.com/sagiegurari/envmnt)
with two changes, both only needed under `cargo -Z build-std` (required
to cross-build tier-3 targets like `x86_64-unknown-openbsd`) -- envmnt
builds fine as-is on a normal stable/prebuilt-std build:

1. `indexmap` bumped from `^1` to `^2` in Cargo.toml. Upstream's `^1` pin
   causes `IndexMap<K, V, S>` arity-defaulting errors (missing the `S`
   hasher param) against a from-source-built `std`. `indexmap` 2.x
   doesn't hit this; envmnt's own usage (`IndexMap::new()`,
   `IndexMap<String, String>` type annotations only -- no removed/
   renamed APIs) is fully compatible with 2.x as-is.
2. Removed `unused_crate_dependencies` from `lib.rs`'s `#![deny(...)]`
   list. Building `std` from source makes `extern crate alloc/core/
   compiler_builtins/panic_abort/panic_unwind/proc_macro` visible as
   "unused" under that lint, which envmnt denies (hard error) rather
   than warns.

Referenced via `[patch.crates-io]` in the workspace `Cargo.toml`.
