from distutils.core import setup
from distutils.extension import Extension
import sys

if sys.subversion[0] == 'PyPy':
    options = {'py_modules':['numa']}
else:
    try:
        from Cython.Distutils import build_ext

        source_file = "numa.pyx"
        cython_available = True
    except ImportError:
        source_file = "numa.c"
        cython_available = False

    options = { 'ext_modules'  : [
                Extension("numa",
                          [source_file],
                          libraries=["numa"],
                          define_macros = [('NUMA_VERSION1_COMPATIBILITY', 1)],
                          ) 
                                 ]
              }

    if cython_available:
        options['cmdclass'] = {"build_ext": build_ext}

setup(
    name = "numa",
    version = '1.4.2',
    description = "Interface to numa(3) Linux API for Python",
    author = 'Andrey Smirnov',
    author_email = 'me@smira.ru',
    url = 'http://github.com/smira/py-numa',
    long_description = '''
        numa provides interface to numa(3) Linux APIs (version 1/2).

        It allows to query NUMA state, change memory & scheduling policies.

        Supports PyPy (via ctypes) and CPython (via Cython).
        ''',
    license = 'MIT',
    platforms = ['any'],
    classifiers = [
        'Development Status :: 3 - Alpha',
        'License :: OSI Approved :: MIT License',
        'Operating System :: POSIX :: Linux',
            ],
    **options
)

