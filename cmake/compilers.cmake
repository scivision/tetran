include(CheckSourceCompiles)
include(CheckLinkerFlag)

set(CMAKE_EXPORT_COMPILE_COMMANDS on)

set(CMAKE_CONFIGURATION_TYPES "Release;RelWithDebInfo;Debug" CACHE STRING "Build type selections" FORCE)

# check C-Fortran ABI compatibility
if(NOT abi_ok)
  message(CHECK_START "checking that C and Fortran compilers can link")
  try_compile(abi_ok ${CMAKE_CURRENT_BINARY_DIR}/abi_check ${CMAKE_CURRENT_LIST_DIR}/abi_check abi_check)
  if(abi_ok)
    message(CHECK_PASS "OK")
  else()
    message(FATAL_ERROR "C compiler ${CMAKE_C_COMPILER_ID} ${CMAKE_C_COMPILER_VERSION} and Fortran compiler ${CMAKE_Fortran_COMPILER_ID} ${CMAKE_Fortran_COMPILER_VERSION} are ABI-incompatible.")
  endif()
endif()


check_source_compiles(Fortran "
program test
call random_init(.false., .false.)
end program"
f18random)

# --- static flags avoid users needing libgfortran etc. on their Windows system
# MacOS and Linux needs more caution as true static linking is an advanced topic.
# this does not guarantee a portable executable, careful testing is needed and possibly further options
set(static_link_flags)
if(MINGW AND CMAKE_Fortran_COMPILER_ID STREQUAL GNU)
  check_linker_flag(C -Wl,--default-image-base-low have_base_low)
  if(have_base_low)
    set(static_link_flags -static -static-libgfortran)
    # MinGW / MSYS2 special considerations: https://www.msys2.org/news/#2021-01-31-aslr-enabled-by-default
    list(APPEND static_link_flags -Wl,--default-image-base-low)
  endif()
endif()

# always do compiler options after all FindXXX and checks

if(CMAKE_Fortran_COMPILER_ID MATCHES "^Intel")

  if(WIN32)
    add_compile_options(/QxHost)
    string(APPEND CMAKE_Fortran_FLAGS " /traceback /warn /heap-arrays")
  else()
    add_compile_options(-xHost)
    string(APPEND CMAKE_Fortran_FLAGS " -traceback -warn -heap-arrays")
  endif()

  string(APPEND CMAKE_Fortran_FLAGS_DEBUG " -fpe0 -debug extended -check all")

elseif(CMAKE_Fortran_COMPILER_ID STREQUAL GNU)
  add_compile_options(-mtune=native -Wall -Wextra)
  string(APPEND CMAKE_Fortran_FLAGS_RELEASE " -fno-backtrace")
  string(APPEND CMAKE_Fortran_FLAGS " -Werror=array-bounds -Wconversion -fimplicit-none")

  string(APPEND CMAKE_Fortran_FLAGS_DEBUG " -fexceptions -ffpe-trap=invalid,zero,overflow -fcheck=all")
endif()
