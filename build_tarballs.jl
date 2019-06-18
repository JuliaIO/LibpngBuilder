# Note that this script can accept some limited command-line arguments, run
# `julia build_tarballs.jl --help` to see a usage message.
using BinaryBuilder

# Collection of sources required to build libpng
sources = [
    "https://vorboss.dl.sourceforge.net/project/libpng/libpng16/1.6.37/libpng-1.6.37.tar.gz" =>
    "daeb2620d829575513e35fecc83f0d3791a620b9b93d800b763542ece9390fb4",

]

# Bash recipe for building across all platforms
script = raw"""
cd $WORKSPACE/srcdir
cd libpng-1.6.37/
mkdir build
cd build/
cmake -DCMAKE_INSTALL_PREFIX=$prefix -DCMAKE_TOOLCHAIN_FILE=/opt/$target/$target.toolchain ..
make -j${ncore}
make install
exit

"""

# These are the platforms we will build for by default, unless further
# platforms are passed in on the command line
platforms = supported_platforms()

# The products that we will ensure are always built
products(prefix) = [
    LibraryProduct(prefix, "libpng16", :libpng)
]

# Dependencies that must be installed before this package can be built
dependencies = [
    "https://github.com/bicycle1885/ZlibBuilder/releases/download/v1.0.4/build_Zlib.v1.2.11.jl"
]

# Build the tarballs, and possibly a `build.jl` as well.
build_tarballs(ARGS, "libpng", v"1.6.37", sources, script, platforms, products, dependencies)

