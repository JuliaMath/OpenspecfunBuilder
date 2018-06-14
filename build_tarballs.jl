using BinaryBuilder

platforms = supported_platforms()

# FreeBSD doesn't work yet: BinaryBuilder.jl#277
platforms = filter!(p -> !(p isa FreeBSD), platforms)

# Collection of sources required to build openspecfun
sources = [
    "https://github.com/JuliaLang/openspecfun/archive/v0.5.3.tar.gz" =>
    "1505c7a45f9f39ffe18be36f7a985cb427873948281dbcd376a11c2cd15e41e7",
]

script = raw"""
cd $WORKSPACE/srcdir/openspecfun-*
make CC="$CC" CXX="$CXX" FC="$FC" -j${nproc}
mkdir -p $libdir
cp libopenspecfun*.${dlext}* $libdir
"""

products(prefix) = [
    LibraryProduct(prefix,"libopenspecfun")
]

# Build the given platforms using the given sources
hashes = build_tarballs(ARGS, "openspecfun", sources, script, platforms, products, [])
