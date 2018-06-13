using BinaryBuilder

# These are the platforms built inside the wizard
platforms = [
  BinaryProvider.Linux(:i686, :glibc),
  BinaryProvider.Linux(:x86_64, :glibc),
  BinaryProvider.Linux(:aarch64, :glibc),
  BinaryProvider.Linux(:armv7l, :glibc),
  BinaryProvider.Linux(:powerpc64le, :glibc),
  BinaryProvider.MacOS(),
  BinaryProvider.Windows(:i686),
  BinaryProvider.Windows(:x86_64)
]

# Collection of sources required to build openspecfun
sources = [
    "https://github.com/JuliaLang/openspecfun/archive/v0.5.3.tar.gz" =>
    "1505c7a45f9f39ffe18be36f7a985cb427873948281dbcd376a11c2cd15e41e7",
]

script = raw"""
cd $WORKSPACE/srcdir/openspecfun-0.5.3
make
mkpath $prefix/lib
cp libopenspecfun.* $prefix/lib
"""

products(prefix) = [
    LibraryProduct(prefix,"libopenspecfun")
]

# Build the given platforms using the given sources
hashes = build_tarballs(ARGS, "openspecfun", sources, script, platforms, products, [])
