#!/usr/bin/env python
# -*- coding: utf-8 -*-
#
#
import sys
from twisted.trial import unittest

import numa

class NumaTestCast(unittest.TestCase):
    def test_available(self):
        self.failUnlessEqual(True, numa.available())

    def test_node_size(self):
        for node in range(numa.get_max_node()+1):
            print 'Node: %d, size: %r' % (node, numa.get_node_size(node))

    def test_preferred(self):
        print 'Preferred node:', numa.get_preferred()

    def test_node_to_cpus(self):
        print 'Node CPUs:', numa.node_to_cpus(numa.get_preferred())

    def test_nodemask(self):
        self.failUnlessEqual(set([0]), numa.numa_nodemask_to_set(numa.set_to_numa_nodemask(set([0]))))

    def test_interleave(self):
        numa.set_interleave_mask(set([0]))
        self.failUnlessEqual(set([0]), numa.get_interleave_mask())

    def test_zz_bind(self):
        # conflicts with test_node_to_cpus
        numa.bind(set([0]))

    def test_preferred(self):
        numa.set_preferred(0)

    def test_localalloc(self):
        numa.set_localalloc()

    def test_membind(self):
        numa.set_membind([0])
        self.failUnlessEqual(set([0]), numa.get_membind())

    def test_run_on_nodemask(self):
        numa.set_run_on_node_mask(set([0]))
        self.failUnlessEqual(set([0]), numa.get_run_on_node_mask())

    def test_get_distance(self):
        self.failUnlessEqual(10, numa.get_distance(0, 0))

    def test_affinity(self):
        numa.set_affinity(0, set([0]))
        self.failUnlessEqual(set([0]), numa.get_affinity(0))
