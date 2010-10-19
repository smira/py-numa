from distutils.core import setup
from distutils.extension import Extension
from Cython.Distutils import build_ext

ext_modules=[
    Extension("numa",
              ["numa.pyx"],
              libraries=["numa"],
              define_macros = [('NUMA_VERSION1_COMPATIBILITY', 1)],
              ) 
]

setup(
    name = "numa",
    version = '1.0',
    description = "Interface to numa(3) Linux API for Python",
    author = 'Andrey Smirnov',
    author_email = 'me@smira.ru',
    url = 'http://docs.python.org/extending/building',
    long_description = '''
        numa provides interface to numa(3) Linux APIs (version 1).

        It allows to query numa state, change memory & scheduling policies.
        ''',
    cmdclass = {"build_ext": build_ext},
    ext_modules = ext_modules
)

