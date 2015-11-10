# beegfs-chunk-map
Creates a CHUNK -> FILENAME map for BeeGFS mounts.

<h2>Compile</h2>

First edit beegfs-conf.sh to match your setup.

beegfs-conf.sh:
<pre>
# LevelDB dependency
CONF_LEVELDB_LIBPATH="/project/SystemWork/leveldb"
CONF_LEVELDB_INCLUDEPATH="/project/SystemWork/leveldb/include"

# Settings
CONF_BEEGFS_MOUNT="/faststorage"
</pre>

Next. Run make.
<pre>
[user@host]$ cd beegfs-chunk-map/src/bp-chunkmap
[user@host]$ make
cc -c -I"/project/SystemWork/leveldb/include" -Wall -Wextra -pedantic -std=gnu99 -g -Os  filelist-runner.c -o filelist-runner.o
filelist-runner.c: In function 'dir_worker':
filelist-runner.c:76: warning: comparison between signed and unsigned integer expressions
cc -L"/project/SystemWork/leveldb" -lpthread filelist-runner.o -o bp-cm-filelist
mv -f bp-cm-filelist ../../bin/
cc -c -I"/project/SystemWork/leveldb/include" -Wall -Wextra -pedantic -std=gnu99 -g -Os  perf.c -o perf.o
cc -c -I"/project/SystemWork/leveldb/include" -Wall -Wextra -pedantic -std=gnu99 -g -Os  getentry-runner.c -o getentry-runner.o
cc -L"/project/SystemWork/leveldb" -lleveldb -lpthread perf.o getentry-runner.o -o bp-cm-getentry
mv -f bp-cm-getentry ../../bin/
cp -f beegfs-chunkmap.sh bp-chunkmap
mv -f bp-chunkmap ../../bin/
cp -f ../beegfs-conf.sh ../../bin/
</pre>

<h2>Example run</h2>

<pre>
[user@host]$ cd beegfs-chunk-map/bin
[user@host]$ ./bp-chunkmap -d /faststorage/folder -o TESTDB -c /tmp/
##### /faststorage/folder #####
Creating file lists /tmp//output.*
.
Total count: 17089
Write entries to LevelDB: /home/../beegfs-chunk-map/bin/TESTDB
       10000 ( 59%) files processed at   12692 files/s
       17089 (100%) files processed at    9686 files/s
</pre>

<h2>Example lookup</h2>

TODO

<h2>Usage</h2>
<pre>
Usage:
  bp-chunkmap -d <directory to map> -o <leveldb output file> [-c <cache directory>]

Parameters explained:
  -d    Directory located on a BeeGFS mount
  -o    Output file containing a chunk map in leveldb format (not located in BeeGFS mount!)
  -c    Cache directory used for large temporary files (not located in BeeGFS mount!)
          default cache directory = "."
</pre>
