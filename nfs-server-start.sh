#!/bin/bash

# Start rpcbind
rpcbind

# Start rpc.statd for file locking
rpc.statd

# Start NFS services
rpc.nfsd
rpc.mountd

# Export the filesystem (if /etc/exports exists)
exportfs -a

# Keep container running
tail -f /dev/null