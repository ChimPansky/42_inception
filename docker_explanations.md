# Docker == Container == Standard Unit?

Containers are isolated groups of process running on a single host, which fulfill a set of "common" features...

# Namespacing

in Linux you can run a program in a new namespace using:
```sudo unshare ./executable_name arg1, arg2```
if you don't specify a executable name, then the default shell (e.g. BASH, ZSH or whatever is in $SHELL...) is run in that new namespace
basically unshare will create a new process that can have separate namespaces from the ones that unshare is called from...

If you create a new container, you create new namespaces. The namespaces can be thought of as virtual layers used for separation. For example you could have a PID (Process ID) 1234 on the host machine and a PID 1234 in a container running on the host machine. Those 2 processes would be totally separated from each other.

You can also create (```unshare```) namespaces for Networks (-n), Users (-U), Groups (-C), Mounts (-m), UTS(=domain- and hostname) (-u), time (-T), IPC (-i)(=Inter-Process-Communication)...

# Process namespacing

If you create a new container, you create a new PID namespace. This PID namespace starts with process 1 (PID 1 also init process), so PIDs on the host machine and in the container are not the same (host.PID1 != container.PID1). To identify a process running inside a container (separate namespace) you would need the process ID of the unshare process in the "parent system" as well as the process ID of the process insinde the container.
If you create a container inside of a container, then you would add another layer (nested namespaces aka namespaceception...)

The first process (PID 1) has special treatment...

# Network namespacing

If you create a new container, you create a new Network namespace. Every network interface (physical or virtual) is present exactly once per namespace. Each namespace contains its own set of IP addresses, own routing table, socket listing, connection tracking table, firewall, etc...

# Composing namespaces

It is possible to join namespaces. For example you could have isolated PID namespaces share the same network interface
To do this we use the nsenter command (lets us run a program in a different namespace):

```sudo unshare -fp --mount-proc
ps aux
USER       PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
root         1  0.1  0.6  18688  6904 pts/0    S    23:36   0:00 -bash
root        39  0.0  0.1  35480  1836 pts/0    R+   23:36   0:00 ps aux```
The setns(2) syscall with its appropriate wrapper program nsenter can now be used to join the namespace. For this we have to find out which namespace we want to join:

```
export PID=$(pgrep -u root bash)
sudo ls -l /proc/$PID/ns```
Now, it is easily possible to join the namespace via nsenter:

```sudo nsenter --pid=/proc/$PID/ns/pid unshare --mount-proc
ps aux
root         1  0.1  0.0  10804  8840 pts/1    S+   14:25   0:00 -bash
root        48  3.9  0.0  10804  8796 pts/3    S    14:26   0:00 -bash
root        88  0.0  0.0   7700  3760 pts/3    R+   14:26   0:00 ps aux```
We can now see that we are member of the same PID namespace! It is also possible to enter already running containers via nsenter, but this topic will be covered later on.
