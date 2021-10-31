---

title: Data Model
state: PROPOSAL
description: |
    This proposal describes a data model as graph
    for an event sourced system where every actor is
	a node with edges representing its capabilities.
	This model can be mapped to an executable 
	directed acyclic graph of instructions 
	for provisioning infrastructure and bootstrapping
	network connectivity.
	
---

# Model

## Vertices
A node represents an actor in the system.
Its capabilities are expressed as edges.

---

vertex: [[Actor]]
edges:
	- can_produce: Capability
	- can_consume: Capability

---

vertex: [[Capability]]
edges:
	- serve: Container

---


## Edges
Defines the relation between nodes.