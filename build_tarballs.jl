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


# If the user passed in a platform (or a few, comma-separated) on the
# command-line, use that instead of our default platforms
if length(ARGS) > 0
    platforms = platform_key.(split(ARGS[1], ","))
end
info("Building for $(join(triplet.(platforms), ", "))")

# Collection of sources required to build openspecfun
sources = [
    "https://github.com/JuliaLang/openspecfun/archive/v0.5.3.tar.gz" =>
    "1505c7a45f9f39ffe18be36f7a985cb427873948281dbcd376a11c2cd15e41e7",
]

script = raw"""
cd $WORKSPACE/srcdir
cd openspecfun-0.5.3/
make
cp libopenspecfun.* ../../destdir/

"""

products = prefix -> [
    LibraryProduct(prefix,"libopenspecfun"),
    LibraryProduct(prefix,"libopenspecfun"),
    LibraryProduct(prefix,"libopenspecfun")
]


# Build the given platforms using the given sources
hashes = autobuild(pwd(), "openspecfun", platforms, sources, script, products)

if !isempty(get(ENV,"TRAVIS_TAG",""))
    print_buildjl(pwd(), products, hashes,
        "https://github.com/KristofferC/OpenspecfunBuilder/releases/download/$(ENV["TRAVIS_TAG"])")
end

