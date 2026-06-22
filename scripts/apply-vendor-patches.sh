#!/bin/sh
# Downloads pristine upstream source for a few crates from crates.io and
# applies the matching patches/*.patch file on top, writing the result to
# target/patch/<name>-<version>/ -- mirroring OpenBSD ports' own
# patches/ convention (small diffs applied to pristine source at build
# time) instead of vendoring full pre-patched crate source in this repo.
#
# Must run BEFORE `cargo build`: cargo resolves [patch.crates-io] path
# entries before any build.rs runs, so target/patch/<crate> has to exist
# before cargo build ever starts.
#
# Only needs base POSIX tools (curl or ftp, tar, patch) -- no new Cargo
# build-dependency, since this also has to run on a real OpenBSD box
# building the bootstrap.packages/conda backend, not just in CI.
set -eu

repo_root="$(cd "$(dirname "$0")/.." && pwd)"
out_dir="$repo_root/target/patch"
mkdir -p "$out_dir"

fetch() {
    # $1 = url, $2 = output file
    if command -v curl >/dev/null 2>&1; then
        curl -sSfL -o "$2" "$1"
    elif command -v ftp >/dev/null 2>&1; then
        ftp -o "$2" "$1"
    else
        echo "apply-vendor-patches.sh: need curl or ftp on PATH" >&2
        exit 1
    fi
}

apply_patch() {
    # $1 = crate name, $2 = version, $3 = patch file (relative to repo root)
    name=$1
    version=$2
    patch_file="$repo_root/$3"
    dest="$out_dir/${name}-${version}"

    if [ -d "$dest" ]; then
        echo "apply-vendor-patches.sh: $dest already exists, skipping"
        return 0
    fi

    tmp_tar="$out_dir/${name}-${version}.crate.tar.gz"
    echo "apply-vendor-patches.sh: fetching ${name} ${version}"
    fetch "https://static.crates.io/crates/${name}/${name}-${version}.crate" "$tmp_tar"

    tar xzf "$tmp_tar" -C "$out_dir"
    rm -f "$tmp_tar"

    echo "apply-vendor-patches.sh: applying $3"
    ( cd "$dest" && patch -p0 < "$patch_file" )
}

apply_patch rattler_pty 0.2.13 patches/rattler_pty-0.2.13-openbsd-ptsname_r.patch
apply_patch envmnt 0.10.4 patches/envmnt-0.10.4-build-std-compat.patch
