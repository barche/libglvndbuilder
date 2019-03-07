# Note that this script can accept some limited command-line arguments, run
# `julia build_tarballs.jl --help` to see a usage message.
using BinaryBuilder

name = "libglvnd"
version = v"1.1.0"

# Collection of sources required to build libglvnd
sources = [
    "https://github.com/NVIDIA/libglvnd/archive/v1.1.0.tar.gz" =>
    "49aebc4eccebd6baffc53852a15c9f76433dd57ab593e44ad5ba5f0c20c63259",

]

# Bash recipe for building across all platforms
script = raw"""
cd $WORKSPACE/srcdir
cd libglvnd-1.1.0/
apk add  libx11-dev libxext-dev glproto
./autogen.sh 
CFLAGS=-I/usr/include LDFLAGS=-L/usr/lib ./configure --prefix=$prefix --host=$target
make -j16
make install

"""

# These are the platforms we will build for by default, unless further
# platforms are passed in on the command line
platforms = [
    Linux(:x86_64, libc=:glibc),
    Linux(:x86_64, libc=:musl)
]

# The products that we will ensure are always built
products(prefix) = [
    LibraryProduct(prefix, "libOpenGL", :libopengl),
    LibraryProduct(prefix, "libGLESv2", :libgles2),
    LibraryProduct(prefix, "libGL", :libgl),
    LibraryProduct(prefix, "libGLESv1_CM", :libglesv1),
    LibraryProduct(prefix, "libGLX", :libglx),
    LibraryProduct(prefix, "libGLdispatch", :libgldispatch),
    LibraryProduct(prefix, "libEGL", :libegl)
]

# Dependencies that must be installed before this package can be built
dependencies = [
    
]

# Build the tarballs, and possibly a `build.jl` as well.
build_tarballs(ARGS, name, version, sources, script, platforms, products, dependencies)

