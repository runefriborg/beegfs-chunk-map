# beegfs-chunk-map
Creates a CHUNK -> FILENAME map for BeeGFS mounts.

This tool is written to handle multi-PB filesystems with more than 100.000.000 files.

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
cc -c -I"/project/SystemWork/leveldb/include" -Wall -Wextra -pedantic -std=gnu99 -g -Os  bp-cm-query.c -o bp-cm-query.o
bp-cm-query.c: In function 'main':
bp-cm-query.c:39: warning: unused variable 'filename_fixed'
cc -L"/project/SystemWork/leveldb" -lleveldb bp-cm-query.o -o bp-cm-query
mv -f bp-cm-query ../../bin/
cp -f beegfs-chunkmap-create.sh bp-chunkmap-create
mv -f bp-chunkmap-create ../../bin/
cp -f beegfs-chunkmap-query.sh bp-chunkmap-query
mv -f bp-chunkmap-query ../../bin/
cp -f ../beegfs-conf.sh ../../bin/
</pre>

<h2>Example run</h2>

<pre>
[user@host]$ cd beegfs-chunk-map/bin
[user@host]$ ./bp-chunkmap-create -d /faststorage/folder -o TESTDB -c /tmp/
##### /faststorage/folder #####
Creating file lists /tmp//output.*
.
Total count: 17089
Write entries to LevelDB: /home/../beegfs-chunk-map/bin/TESTDB
       10000 ( 59%) files processed at   12692 files/s
       17089 (100%) files processed at    9686 files/s
</pre>

<h2>Example query</h2>
The query tool reads CHUNK entries from STDIN.
<pre>
[user@host]$ echo 1233-53BD1EC2-2329 | ./bp-chunkmap-query -m TESTDB
/path/to/file.test
</pre>

<h2>Usage</h2>
<pre>
Usage:
  bp-chunkmap-create -d &lt;directory to map&gt; -o &lt;leveldb output file&gt; [-c &lt;cache directory&gt;]

Parameters explained:
  -d    Directory located on a BeeGFS mount
  -o    Output file containing a chunk map in leveldb format (not located in BeeGFS mount!)
  -c    Cache directory used for large temporary files (not located in BeeGFS mount!)
          default cache directory = "."

Usage:
  bp-chunkmap-query -m &lt;leveldb map&gt;

Reads CHUNK IDs from STDIN and outputs the fetched filenames.

Parameters explained:
  -m    Chunk map in leveldb format
</pre>
