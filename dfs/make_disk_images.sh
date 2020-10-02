#!/bin/bash


PREFIX=AcornCmosBasic_disk

rm -rf tmp
mkdir -p tmp/d0
mkdir -p tmp/d2


# Drive 0

cp ../tools/TurMasmDfs  tmp/d0/TurMasm
cp ../tools/MasmDfs     tmp/d0/Masm
cp ../tools/IoMasm      tmp/d0/
cp ../tools/Edit        tmp/d0/
cp ../tools/*.inf       tmp/d0
cp ../dfs/MakeBAS       tmp/d0

# Drive 2

cp ../src/* tmp/d2

# Create a !boot file
cat > tmp/d0/\!BOOT <<EOF
*LIB :0.$
*EXEC MakeBAS
EOF

# Create a dummy header file to switch to reading sources from side 2
cat > tmp/d0/BasHdr <<EOF
        < 2
        
        LNK     CBAS01
EOF

# Convert sources to CR line endings
unix2mac tmp/d0/\!BOOT
unix2mac tmp/d0/MakeBAS
unix2mac tmp/d0/BasHdr
unix2mac tmp/d2/*


# Create disk images
for i in 0 2
do
beeb blank_ssd tmp/d${i}.ssd
beeb putfile   tmp/d${i}.ssd tmp/d${i}/*
beeb title     tmp/d${i}.ssd "Cmos Basic/${i}"
done

# Make drive 0 bootable
beeb opt4      tmp/d0.ssd 3

# Show the final disks
for i in 0 2
do
    beeb info tmp/d${i}.ssd
done

# Generate dsd images
beeb merge_dsd tmp/d0.ssd tmp/d2.ssd tmp/d02.dsd

# Copy into the final directories
mkdir -p ssd
for i in 0 2
do
    mv tmp/d${i}.ssd ssd/${PREFIX}${i}.ssd
done

mkdir -p dsd
for i in 02
do
    mv tmp/d${i}.dsd dsd/${PREFIX}${i}.dsd
done

ls -l ssd dsd
