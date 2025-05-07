## vxprint sample

```
# vxprint -g datavg -v mydata
Disk group: datavg
TY NAME        ASSOC        KSTATE   LENGTH   PLOFFS   STATE    TUTIL0  FMTYPE
v  mydata       -            ENABLED  10G      -        ACTIVE   -       -
pl mydata-01    mydata       ENABLED  10G      0        ACTIVE   -       -
sd disk01-01    mydata-01    ENABLED  10G      0        -        -       -

# vxprint -g datavg -v fastdata
Disk group: datavg
TY NAME        ASSOC        KSTATE   LENGTH   PLOFFS   STATE    TUTIL0  FMTYPE
v  fastdata     -            ENABLED  500M     -        ACTIVE   -       -
pl fastdata-01  fastdata     ENABLED  500M     0        ACTIVE   -       STRIPE
sd disk01-01    fastdata-01  ENABLED  250M     0        -        -       -
sd disk02-01    fastdata-01  ENABLED  250M     0        -        -       -

# vxprint -g datavg -v mirrordata
Disk group: datavg
TY NAME        ASSOC        KSTATE   LENGTH   PLOFFS   STATE    TUTIL0  FMTYPE
v  mirrordata   -            ENABLED  20G      -        ACTIVE   -       -
pl mirrordata-01 mirrordata ENABLED  20G      0        ACTIVE   -       CONCAT
sd disk01-01    mirrordata-01 ENABLED  20G      0        -        -       -
pl mirrordata-02 mirrordata ENABLED  20G      0        ACTIVE   -       CONCAT
sd disk02-01    mirrordata-02 ENABLED  20G      0        -        -       -
```

**Explanation of the Output:**

In these examples, we are using the `-v` option with `vxprint` to display detailed information about specific volumes within the `datavg` disk group.

**1. Concatenated Volume (`mydata`):**

* **`v mydata - ENABLED 10G ACTIVE`**: This line describes the volume itself.
    * `v`: Indicates a volume.
    * `mydata`: The name of the volume.
    * `-`: No specific association.
    * `ENABLED`: The volume is enabled.
    * `10G`: The total length (size) of the volume.
    * `ACTIVE`: The volume is currently active and accessible.
* **`pl mydata-01 mydata ENABLED 10G 0 ACTIVE CONCAT`**: This line describes the plex (a component of a volume, in this case, the only one for a simple concatenation).
    * `pl`: Indicates a plex.
    * `mydata-01`: The name of the plex.
    * `mydata`: The volume this plex belongs to.
    * `ENABLED`: The plex is enabled.
    * `10G`: The length of the plex.
    * `0`: The offset within the volume.
    * `ACTIVE`: The plex is active.
    * `CONCAT`: The layout of the plex is concatenation (linear arrangement of disk space).
* **`sd disk01-01 mydata-01 ENABLED 10G 0 - -`**: This line describes the subdisk (a portion of a physical disk allocated to a plex).
    * `sd`: Indicates a subdisk.
    * `disk01-01`: The name of the subdisk, indicating it's using space from the logical disk named `disk01` within the disk group.
    * `mydata-01`: The plex this subdisk belongs to.
    * `ENABLED`: The subdisk is enabled.
    * `10G`: The length of the subdisk.
    * `0`: The offset within the plex.
    * `-`: No specific TUTIL0 (Target Unit Attention) or FMTYPE (Format Type) information in this simple case.

**2. Striped Volume (`fastdata`):**

* The volume (`v fastdata`) and its plex (`pl fastdata-01`) are marked as `STRIPE` in the `FMTYPE` column for the plex, indicating a striped layout.
* You can see two subdisks (`sd disk01-01` and `sd disk02-01`) belonging to the `fastdata-01` plex. Each subdisk has a portion of the total volume size (250M each, totaling 500M). This shows the data is being striped across the space provided by the logical disks `disk01` and `disk02`.

**3. Mirrored Volume (`mirrordata`):**

* The volume (`v mirrordata`) has two plexes (`pl mirrordata-01` and `pl mirrordata-02`), both with a `CONCAT` layout. This indicates that the volume consists of two identical copies of the data.
* Each plex has a corresponding subdisk (`sd disk01-01` for `mirrordata-01` and `sd disk02-01` for `mirrordata-02`), each residing on a different logical disk (`disk01` and `disk02`). Both subdisks have the full size of the volume (20G), confirming the mirroring.

This output provides a basic understanding of how `vxprint` displays the configuration of different volume layouts in Veritas Volume Manager. The key is to look at the `LAYOUT` or `FMTYPE` column for plexes to identify the type of volume (CONCAT, STRIPE, MIRROR, etc.) and to observe the number and association of subdisks to understand how the data is organized across the underlying storage.

```
# vxprint -pht -g datavg mydata fastdata mirrordata

DG NAME           NCONFIG   NLOG    MINORS  GROUP-ID
datavg          default   default 0       1683374785.1234

DM NAME           DEVICE       TYPE      PRIVLEN   PUBLEN    STATE
disk01          /dev/sdb     sliced    512       20479999  online
disk02          /dev/sdc     sliced    512       20479999  online

V  NAME         USETYPE   KSTATE    STATE   LENGTH  READPOL   PREFPLEX
v  mydata       fsgen     ENABLED   ACTIVE  10G     SELECT    -
v  fastdata     fsgen     ENABLED   ACTIVE  500M    SELECT    -
v  mirrordata   fsgen     ENABLED   ACTIVE  20G     SELECT    -

PL NAME         VOLUME      KSTATE    STATE   LENGTH  LAYOUT    NCOL/WID  MODE
pl mydata-01    mydata      ENABLED   ACTIVE  10G     CONCAT    -         RW
pl fastdata-01  fastdata    ENABLED   ACTIVE  500M    STRIPE    2/64      RW
pl mirrordata-01 mirrordata ENABLED   ACTIVE  20G     CONCAT    -         RW
pl mirrordata-02 mirrordata ENABLED   ACTIVE  20G     CONCAT    -         RW

SD NAME         PLEX        DISK        DISKOFFS  LENGTH    [COL/]OFF DEVICE     MODE
sd disk01-01    mydata-01   disk01      0         10G       -         /dev/sdb1  ENA
sd disk01-01    fastdata-01 disk01      0         250M      0/0       /dev/sdb2  ENA
sd disk02-01    fastdata-01 disk02      0         250M      1/0       /dev/sdc1  ENA
sd disk01-01    mirrordata-01 disk01      0         20G       -         /dev/sdb3  ENA
sd disk02-01    mirrordata-02 disk02      0         20G       -         /dev/sdc2  ENA
```

**Explanation of the Output for `vxprint -pht`:**

The `-pht` options provide a hierarchical, type-oriented view of the Veritas Volume Manager objects for the specified disk groups and volumes.

* **`DG NAME`, `NCONFIG`, `NLOG`, `MINORS`, `GROUP-ID`**: This section describes the disk group (`datavg`).
    * `NCONFIG`: Number of configuration copies.
    * `NLOG`: Number of log copies.
    * `MINORS`: Number of minor numbers allocated.
    * `GROUP-ID`: Unique identifier for the disk group.

* **`DM NAME`, `DEVICE`, `TYPE`, `PRIVLEN`, `PUBLEN`, `STATE`**: This section describes the disk media records (physical disks) within the disk group.
    * `DM NAME`: Logical name of the disk media record (`disk01`, `disk02`).
    * `DEVICE`: Device path of the physical disk (`/dev/sdb`, `/dev/sdc`).
    * `TYPE`: Type of disk (`sliced`).
    * `PRIVLEN`: Length of the private region (in sectors).
    * `PUBLEN`: Length of the public region (in sectors).
    * `STATE`: Current state of the disk (`online`).

* **`V NAME`, `USETYPE`, `KSTATE`, `STATE`, `LENGTH`, `READPOL`, `PREFPLEX`**: This section describes the volumes (`mydata`, `fastdata`, `mirrordata`).
    * `V NAME`: Name of the volume.
    * `USETYPE`: Usage type of the volume (`fsgen` for general file systems).
    * `KSTATE`: Kernel state of the volume (`ENABLED`).
    * `STATE`: Utility state of the volume (`ACTIVE`).
    * `LENGTH`: Size of the volume.
    * `READPOL`: Read policy (`SELECT` typically means it reads from any available plex).
    * `PREFPLEX`: Preferred plex for reading (if any).

* **`PL NAME`, `VOLUME`, `KSTATE`, `STATE`, `LENGTH`, `LAYOUT`, `NCOL/WID`, `MODE`**: This section describes the plexes associated with the volumes.
    * `PL NAME`: Name of the plex.
    * `VOLUME`: Volume the plex belongs to.
    * `KSTATE`: Kernel state of the plex (`ENABLED`).
    * `STATE`: Utility state of the plex (`ACTIVE`).
    * `LENGTH`: Size of the plex.
    * `LAYOUT`: Layout type of the plex (`CONCAT`, `STRIPE`).
    * `NCOL/WID`: Number of columns and stripe width (for striped volumes).
    * `MODE`: I/O mode of the plex (`RW` for read-write).

* **`SD NAME`, `PLEX`, `DISK`, `DISKOFFS`, `LENGTH`, `[COL/]OFF`, `DEVICE`, `MODE`**: This section describes the subdisks that make up the plexes.
    * `SD NAME`: Name of the subdisk.
    * `PLEX`: Plex the subdisk belongs to.
    * `DISK`: Logical disk the subdisk resides on (`disk01`, `disk02`).
    * `DISKOFFS`: Offset of the subdisk on the physical disk (in sectors).
    * `LENGTH`: Size of the subdisk.
    * `[COL/]OFF`: Column and offset within the stripe (for striped volumes).
    * `DEVICE`: Underlying device path for the subdisk (`/dev/sdb1`, `/dev/sdc1`, etc.).
    * `MODE`: Mode of the subdisk (`ENA` for enabled).

This hierarchical output clearly shows the relationships between the disk group, physical disks, logical volumes, plexes, and the subdisks that constitute them, along with their key attributes and states.
```
# vxprint -pht -g datavg mydata_fail fastdata_degraded mirror_disabled

DG NAME           NCONFIG   NLOG    MINORS  GROUP-ID
datavg          default   default 0       1683374785.1234

DM NAME           DEVICE       TYPE      PRIVLEN   PUBLEN    STATE
disk01          /dev/sdb     sliced    512       20479999  online
disk02          /dev/sdc     sliced    512       20479999  online
disk03          /dev/sdd     sliced    512       20479999  online   <<<--- Failed Disk

V  NAME              USETYPE   KSTATE    STATE     LENGTH  READPOL   PREFPLEX
v  mydata_fail       fsgen     ENABLED   ACTIVE    10G     SELECT    -
v  fastdata_degraded fsgen     ENABLED   DEGRADED  500M    SELECT    -
v  mirror_disabled   fsgen     ENABLED   DEGRADED  20G     SELECT    -

PL NAME             VOLUME            KSTATE    STATE      LENGTH  LAYOUT    NCOL/WID  MODE
pl mydata_fail-01   mydata_fail       ENABLED   ACTIVE     10G     CONCAT    -         RW
pl fastdata-01      fastdata_degraded ENABLED   DEGRADED   500M    STRIPE    2/64      RW
pl mirror_disabled-01 mirror_disabled DISABLED  DISABLED   20G     CONCAT    -         RW
pl mirror_disabled-02 mirror_disabled ENABLED   ACTIVE     20G     CONCAT    -         RW

SD NAME             PLEX              DISK        DISKOFFS  LENGTH    [COL/]OFF DEVICE     MODE
sd disk01-01        mydata_fail-01    disk01      0         10G       -         /dev/sdb1  ENA
sd disk01-01        fastdata-01       disk01      0         250M      0/0       /dev/sdb2  ENA
sd disk02-01        fastdata-01       disk02      0         250M      1/0       /dev/sdc1  ENA
sd disk03-01        fastdata-01       disk03      -         -         -         -          NDEV  <<<--- Subdisk on Failed Disk
sd disk01-01        mirror_disabled-01 disk01      0         20G       -         /dev/sdb3  DIS   <<<--- Subdisk on Disabled Plex
sd disk02-01        mirror_disabled-02 disk02      0         20G       -         /dev/sdc2  ENA
```

**Key Observations in this Sample Output:**

* **Failed Disk:**
    * Under `DM NAME`, you see `disk03` with the `STATE` as `online`. While `vxprint` itself might not explicitly show "failed" here, in a real failure scenario, the `STATE` could be `error`, `failed`, or `LFAILED` (local node has no access). The key indicator is often the subsequent impact on subdisks.

* **Degraded Striped Volume (`fastdata_degraded`):**
    * The volume `fastdata_degraded` has a `STATE` of `DEGRADED`.
    * One of its subdisks (`sd disk03-01`) shows `DISK` as `disk03` (our simulated failed disk) and the `MODE` as `NDEV` (No Device). This indicates that a component of the stripe is inaccessible due to the failed underlying disk. The volume remains accessible (in a degraded state) if redundancy mechanisms aren't in place for this layout.

* **Disabled Plex and Subdisk (`mirror_disabled`):**
    * The volume `mirror_disabled` also has a `STATE` of `DEGRADED` because one of its mirrors is disabled.
    * The plex `mirror_disabled-01` has a `KSTATE` and `STATE` of `DISABLED`. This signifies that this entire copy of the data is currently inactive.
    * The subdisk `sd disk01-01` belonging to the disabled plex `mirror_disabled-01` has a `MODE` of `DIS` (Disabled). This subdisk is not contributing to the active volume.
    * The other mirror (`pl mirror_disabled-02`) and its subdisk (`sd disk02-01`) are still `ENABLED` and `ACTIVE`, allowing access to the data.

**Important Notes:**

* The exact `STATE` of a failed disk (`DM`) can vary depending on the nature of the failure.
* A degraded volume indicates that it's operating with reduced redundancy or performance due to a component failure.
* A disabled plex means that copy of the data is not currently being used or updated.
* A subdisk with `NDEV` means the underlying disk device is not accessible.
* A subdisk with `DIS` means it has been administratively disabled or belongs to a disabled plex.

This sample demonstrates how `vxprint -pht` can provide valuable information about the health and status of your Veritas Volume Manager configuration, highlighting components that are experiencing issues.