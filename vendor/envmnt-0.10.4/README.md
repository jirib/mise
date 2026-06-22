# envmnt (vendored, indexmap 2 bump)

Vendored copy of [`envmnt` 0.10.4](https://github.com/sagiegurari/envmnt)
with one change: `indexmap` bumped from `^1` to `^2` in Cargo.toml, source
unchanged.

Upstream's `^1` pin causes `IndexMap<K, V, S>` arity-defaulting errors
(missing the `S` hasher param) when built under `cargo -Z build-std`
against a from-source-built `std` -- it works fine on a normal stable
build, but `-Z build-std` is needed to cross-build for tier-3 targets
like `x86_64-unknown-openbsd`. `indexmap` 2.x doesn't hit this; envmnt's
own usage (`IndexMap::new()`, `IndexMap<String, String>` type
annotations only -- no removed/renamed APIs) is fully compatible with 2.x
as-is, so no source changes were needed.

Referenced via `[patch.crates-io]` in the workspace `Cargo.toml`.
