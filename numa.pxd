cdef extern from "numa.h":
    ctypedef int nodemask_t

    int numa_available()
    int numa_max_node()
    int numa_preferred()
    long numa_node_size(int node, long *freep)
    long long numa_node_size64(int node, long long *freep)

    nodemask_t numa_all_nodes
    nodemask_t numa_no_nodes
    int numa_node_to_cpus(int node, unsigned long *buffer, int bufferlen)

    void nodemask_zero(nodemask_t *mask)
    void nodemask_set(nodemask_t *mask, int node)
    void nodemask_clr(nodemask_t *mask, int node)
    int nodemask_isset(nodemask_t *mask, int node)
    int nodemask_equal(nodemask_t *a, nodemask_t b)

    void numa_set_interleave_mask(nodemask_t *nodemask)
    nodemask_t numa_get_interleave_mask()
    void numa_bind(nodemask_t *nodemask)
    void numa_set_preferred(int node)
    void numa_set_localalloc()
    void numa_set_membind(nodemask_t *nodemask)
    nodemask_t numa_get_membind()

    void *numa_alloc_interleaved_subset(size_t size, nodemask_t *nodemask)
    void *numa_alloc_interleaved(size_t size)
    void *numa_alloc_onnode(size_t size, int node)
    void *numa_alloc_local(size_t size)
    void *numa_alloc(size_t size)
    void numa_free(void *start, size_t size)

    int numa_run_on_node_mask(nodemask_t *nodemask)
    int numa_run_on_node(int node)
    int numa_get_run_node_mask()

    void numa_interleave_memory(void *start, size_t size, nodemask_t *nodemask)
    void numa_tonode_memory(void *start, size_t size, int node)
    void numa_tonodemask_memory(void *start, size_t size, nodemask_t *nodemask)
    void numa_setlocal_memory(void *start, size_t size)
    void numa_police_memory(void *start, size_t size)
    int numa_distance(int node1, int node2)
    void numa_set_bind_policy(int strict)
    void numa_set_strict(int strict)
    void numa_error(char *where)
    void numa_warn(int number, char *where, ...)
    int numa_exit_on_error
    
    
cdef extern from "sched.h":
    ctypedef int pid_t
    ctypedef int cpu_set_t

    int sched_setaffinity(pid_t pid, unsigned int cpusetsize, cpu_set_t *mask)

    int sched_getaffinity(pid_t pid, unsigned int cpusetsize, cpu_set_t *mask)

    void CPU_CLR(int cpu, cpu_set_t *set)
    int CPU_ISSET(int cpu, cpu_set_t *set)
    void CPU_SET(int cpu, cpu_set_t *set)
    void CPU_ZERO(cpu_set_t *set)

