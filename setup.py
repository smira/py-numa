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
    version = '1.1',
    description = "Interface to numa(3) Linux API for Python",
    author = 'Andrey Smirnov',
    author_email = 'me@smira.ru',
    url = 'http://github.com/smira/py-numa',
    long_description = '''
        numa provides interface to numa(3) Linux APIs (version 1).

        It allows to query NUMA state, change memory & scheduling policies.
        ''',
    cmdclass = {"build_ext": build_ext},
    license = 'GPL',
    platforms = ['any'],
    classifiers = [
        'Development Status :: 3 - Alpha',
        'License :: OSI Approved :: GNU General Public License (GPL)',
        'Operating System :: POSIX :: Linux',
            ],
    ext_modules = ext_modules
)

