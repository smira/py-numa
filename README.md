Python Interface to numa(3) Linux library
=========================================

[![Build Status](https://travis-ci.org/smira/py-numa.svg?branch=master)](https://travis-ci.org/smira/py-numa)

API docs available at: http://smira.github.com/py-numa/

Installation:

    pip install numa

Support both PyPy runtime (via ctypes) and CPython (via Cython module).
PyPy3 is not supported, as `ctypes_configure` is not Python3 compatible.

libnuma development package is required for building, for CentOS:

    yum install numactl-devel

For Debian/Ubuntu:

    yum install libnuma-dev
