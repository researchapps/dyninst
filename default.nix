{ lib
, llvmPackages_14
, cmake
, boost
, libiberty
, elfutils
, libdwarf
, tbb }:

llvmPackages_14.stdenv.mkDerivation rec {
  pname = "dyninst";
  version = "8.2.0";
  
  src = ./.;

  nativeBuildInputs = [ cmake ];
  buildInputs = [ llvmPackages_14.openmp boost libiberty elfutils libdwarf tbb];
  cmakeFlags = [
            "-DBoost_ROOT_DIR=${lib.getDev boost}"
            "-DElfUtils_ROOT_DIR=${lib.getDev elfutils}"
            "-DLibIberty_ROOT_DIR=${lib.getDev libiberty}"
            "-DTBB_ROOT_DIR=${lib.getDev tbb}"
            "-DLibIberty_LIBRARIES=${lib.getDev libiberty}/libs"
            "-DUSE_OpenMP=ON"
            "-DENABLE_STATIC_LIBS=NO"
            "-DSTERILE_BUILD=ON"
  ];

  meta = with lib; {
    homepage = "https://github.com/dyninst/dyninst";
    description = ''
      Tools for binary instrumentation, analysis, and modification. 
    '';
    licencse = licenses.mit;
    platforms = with platforms; linux;
  };
}

