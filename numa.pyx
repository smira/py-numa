"""
Interface to numa(3) Linux library.

It allows querying internal NUMA status, changing policies, binding to CPUs, etc.
"""

cimport numa

def available():
    """
    Is numa(3) available?

    @rtype: C{bool}
    """
    return numa_available() != -1

def get_max_node():
    """
    Maximum number of NUMA node.

    @rtype: C{int}
    """
    return numa_max_node()

def get_node_size(node):
    """
    Get size of memory on C{node}.

    @param node: node idx
    @type node: C{int}
    @return: free memory/total memory
    @rtype: C{tuple}(C{int}, C{int})
    """
    cdef long long free
    cdef long long size

    if node < 0 or node > get_max_node():
        raise ValueError, node

    size = numa_node_size64(node, &free)

    return (free, size)

def get_preferred():
    """
    Return preferred node for this process.

    @rtype: C{int}
    """
    return numa_preferred()

def node_to_cpus(node):
    """
    Get CPUs available on C{node}.

    @return: set of CPU ids
    @rtype: C{set}
    """
    cdef unsigned long buf[8]
    cdef int i
    cdef int j

    result = set()

    if node < 0 or node > get_max_node():
        raise ValueError, node

    if numa_node_to_cpus(node, buf, sizeof(buf)) < 0:
        raise RuntimeError, node

    for i in range(0, 8):
        for j in range (0, sizeof(unsigned long)*8):
            if buf[i] & (1L << j) == (1L << j):
                result.add(i*sizeof(unsigned long)*8 + j)

    return result

cdef object numa_nodemask_to_set(nodemask_t mask):
    """
    Convert NUMA nodemask to Python set.
    """
    cdef object result = set()
    cdef int i

    for i in range(0, get_max_node()+1):
        if nodemask_isset(&mask, i):
            result.add(i)

    return result

cdef set_to_numa_nodemask(object mask, nodemask_t *result):
    """
    Convert Python set to NUMA nodemask.
    """
    cdef int i

    nodemask_zero(result)

    for i in range(0, get_max_node()+1):
        if i in mask:
            nodemask_set(result, i)

def set_interleave_mask(nodemask):
    """
    Sets the memory interleave mask for the current thread to C{nodemask}.

    @param nodemask: node mask
    @type nodemask: C{set}
    """
    cdef nodemask_t mask

    set_to_numa_nodemask(nodemask, &mask)

    numa_set_interleave_mask(&mask)

def get_interleave_mask():
    """
    Get interleave mask for current thread.

    @return: node mask
    @rtype: C{set}
    """
    return numa_nodemask_to_set(numa_get_interleave_mask())

def bind(nodemask):
    """
    Binds the current thread and its children to the nodes specified in nodemask.
    They will only run on the CPUs of the specified nodes and only be able to allocate memory from them.

    @param nodemask: node mask
    @type nodemask: C{set}
    """
    cdef nodemask_t mask

    set_to_numa_nodemask(nodemask, &mask)

    numa_bind(&mask)

def set_preferred(node):
    """
    Sets  the preferred node for the current thread to node.

    The preferred node is the node on which memory is preferably allocated before falling back to other
    nodes. The default is to use the node on which the process is currently running (local policy).

    @param node: node idx
    @type node: C{int}
    """
    if node < 0 or node > get_max_node():
        raise ValueError, node

    numa_set_preferred(node)

def set_localalloc():
    """
    Sets a local memory allocation policy for the calling thread.

    Memory is preferably allocated on the node on which the thread is currently running.
    """
    numa_set_localalloc()

def set_membind(nodemask):
    """
    Sets the memory allocation mask.

    The thread will only allocate memory from the nodes set in nodemask.

    @param nodemask: node mask
    @type nodemask: C{set}
    """
    cdef nodemask_t mask

    set_to_numa_nodemask(nodemask, &mask)
    numa_set_membind(&mask)

def get_membind():
    """
    Returns  the  mask of nodes from which memory can currently be allocated.

    @return: node mask
    @rtype: C{set}
    """
    return numa_nodemask_to_set(numa_get_membind())

def set_run_on_node_mask(nodemask):
    """
    Runs the  current thread and its children only on nodes specified in nodemask.

    They will not migrate to CPUs of other nodes until the node affinity is
    reset with a new call to L{set_run_on_node_mask}.

    @param nodemask: node mask
    @type nodemask: C{set}
    """
    cdef nodemask_t mask

    set_to_numa_nodemask(nodemask, &mask)

    if numa_run_on_node_mask(&mask) < 0:
        raise RuntimeError

def get_run_on_node_mask():
    """
    Returns the mask of nodes that the current thread is allowed to run on.

    @return: node mask
    @rtype: C{set}
    """
    return numa_nodemask_to_set(numa_get_run_node_mask())

def get_distance(node1, node2):
    """
    Reports the distance in the machine topology between two nodes.

    The factors are a multiple of 10. It returns 0 when the distance cannot be determined. A node  has
    distance 10 to itself.  Reporting the distance requires a Linux kernel version of 2.6.10 or newer.

    @param node1: node idx
    @type node1: C{int}
    @param node2: node idx
    @type node2: C{int}
    @rtype: C{int}
    """
    if node1 < 0 or node1 > get_max_node():
        raise ValueError, node1
    if node2 < 0 or node2 > get_max_node():
        raise ValueError, node2

    return numa_distance(node1, node2)

def get_affinity(pid):
    """
    Returns the affinity mask of the process whose ID is pid.

    @param pid: process PID (0 == current process)
    @type pid: C{int}
    @return: set of CPU ids
    @rtype: C{set}
    """
    cdef cpu_set_t cpuset
    cdef int i

    result = set()

    sched_getaffinity(pid, sizeof(cpu_set_t), &cpuset)

    for i in range(0, sizeof(cpu_set_t)*8):
        if CPU_ISSET(i, &cpuset):
            result.add(i)

    return result

def set_affinity(pid, cpuset):
    """
    Sets  the  CPU  affinity  mask of the process whose ID is pid to the value specified by mask.

    If pid is zero, then the calling process is used.

    @param pid: process PID (0 == current process)
    @type pid: C{int}
    @param cpuset: set of CPU ids
    @type cpuset: C{set}
    """
    cdef cpu_set_t _cpuset
    cdef int i

    CPU_ZERO(&_cpuset)

    for i in range(0, sizeof(cpu_set_t)*8):
        if i in cpuset:
            CPU_SET(i, &_cpuset)

    if sched_setaffinity(pid, sizeof(cpu_set_t), &_cpuset) < 0:
        raise RuntimeError
