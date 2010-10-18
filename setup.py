from distutils.core import setup
from distutils.extension import Extension
from Cython.Distutils import build_ext

ext_modules=[
    Extension("numa",
              ["numa.pyx"],
              libraries=["numa"]) # Unix-like specific
]

setup(
  name = "numa",
  description = "Interface to numa(3) Linux API for Python",
  cmdclass = {"build_ext": build_ext},
  ext_modules = ext_modules
)

