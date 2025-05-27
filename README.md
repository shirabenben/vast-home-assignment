# Docker NFS Setup

A Docker Compose setup for running NFS server and client containers.

## Components

- **mizar**: CentOS 7 based container running NFS daemon
- **alcor**: Container for testing NFS mounts

## Usage

### 1. Start the services
```bash
docker-compose up -d
```

### 2. Setup NFS exports on the server
```bash
docker-compose exec mizar bash
# Create and configure /exports directory
mkdir -p /exports
chmod 777 /exports
echo "/exports alcor(rw)" > /etc/exports
# Apply the export configuration
exportfs -a
# Verify export configuration
exportfs -v
exit
```

### 3. Access the NFS client
```bash
docker-compose exec alcor bash
```

### 4. Mount the NFS share from within the client
```bash
mkdir -p /mnt/nfs
mount -t nfs -o nolock mizar:/exports /mnt/nfs
```

### 5. Create a user and group
```bash
useradd star
groupadd trek
usermod -aG trek star
```

### 6. Switch to star user and create files
```bash
su star
# Create 1000 files as star user
for i in $(seq 1 1000); do head -c 2048 </dev/urandom > /mnt/nfs/file_$i; done
# Switch back to root
exit
```

### 7. Test root squashing behavior
```bash
# Create a file as root (should be squashed)
touch /mnt/nfs/root_squash
```

### 8. Enable no_root_squash and test
```bash
# Exit alcor container
exit
# Update exports to disable root squashing
docker-compose exec mizar bash
echo "/exports alcor(rw,no_root_squash)" > /etc/exports
exportfs -a
exportfs -v
exit
# Re-enter alcor container
docker-compose exec alcor bash
# Create a file as root (should not be squashed)
touch /mnt/nfs/no_squash
ls -lah /mnt/nfs/ | grep squash
```

## Ports

The following port is exposed by the mizar container:
- `2049`: NFS service (required)

## Security Note

Both containers run in privileged mode, which is required for NFS functionality but reduces security isolation.