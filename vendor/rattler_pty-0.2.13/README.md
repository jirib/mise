# rattler_pty (vendored, OpenBSD patch)

Vendored copy of [`rattler_pty` 0.2.13](https://github.com/conda/rattler/tree/rattler_pty-v0.2.13/crates/rattler_pty)
with one addition: an `openbsd` implementation of `ptsname_r` in
`src/unix/pty_process.rs`, using the POSIX `ptsname(3)` (the crate already
has equivalent per-platform shims for `linux`, `macos`, `freebsd`, and
`netbsd` — OpenBSD was simply missing).

Referenced via `[patch.crates-io]` in the workspace `Cargo.toml`. Remove this
once upstream adds OpenBSD support (tracked nowhere yet — file an issue
against `conda/rattler` if one doesn't exist).
