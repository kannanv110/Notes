# Linux Unified Key Setup(LUKS)

## Links and Reference
 * [Red Hat Blog](https://www.redhat.com/en/blog/disk-encryption-luks)
 
## Install cryptsetup package
```shell
dnf install cryptsetup
```

## Encrypt the disk
```shell
[root@practice-rocky9 ~]# cryptsetup luksFormat /dev/sdb2

WARNING!
========
This will overwrite data on /dev/sdb2 irrevocably.

Are you sure? (Type 'yes' in capital letters): YES
Enter passphrase for /dev/sdb2: 
Verify passphrase: 
[root@practice-rocky9 ~]# 
```

## Open the encrypted disk as sdb2
```shell
[root@practice-rocky9 ~]# cryptsetup luksOpen /dev/sdb2 sdb2
Enter passphrase for /dev/sdb2: 
[root@practice-rocky9 ~]# ls -l /dev/mapper/sdb2
lrwxrwxrwx 1 root root 7 Apr 24 12:06 /dev/mapper/sdb2 -> ../dm-1
[root@practice-rocky9 ~]#
```

## View the details about the crypted device
```shell
[root@practice-rocky9 ~]# cryptsetup luksDump /dev/sdb2
LUKS header information
Version:        2
Epoch:          3
Metadata area:  16384 [bytes]
Keyslots area:  16744448 [bytes]
UUID:           d209694d-7dcc-405b-8ba7-ca19cec3ab3a
Label:          (no label)
Subsystem:      (no subsystem)
Flags:          (no flags)

Data segments:
  0: crypt
        offset: 16777216 [bytes]
        length: (whole device)
        cipher: aes-xts-plain64
        sector: 512 [bytes]

Keyslots:
  0: luks2
        Key:        512 bits
        Priority:   normal
        Cipher:     aes-xts-plain64
        Cipher key: 512 bits
        PBKDF:      argon2id
        Time cost:  4
        Memory:     908502
        Threads:    2
        Salt:       7b c0 86 be a7 ea d0 9e a9 9e a4 0b 51 a3 d5 59 
                    4f e5 95 b0 7d ac f3 95 f9 6f 9b 3b 63 24 c0 41 
        AF stripes: 4000
        AF hash:    sha256
        Area offset:32768 [bytes]
        Area length:258048 [bytes]
        Digest ID:  0
Tokens:
Digests:
  0: pbkdf2
        Hash:       sha256
        Iterations: 72176
        Salt:       7a 74 27 7a 04 9d 14 c6 51 8f 90 ef 18 2a 78 ee 
                    a9 8d 30 10 5a b7 4b b7 0c c6 17 05 d1 7d 5a 1c 
        Digest:     0d 16 bc 03 aa 98 df 97 d7 7c 33 61 b7 e7 29 d8 
                    2a 05 e8 41 04 ed db 37 76 c1 b9 6e f4 7e 65 76 
[root@practice-rocky9 ~]#
```

## Create LVM and mount the file system
```shell
[root@practice-rocky9 ~]# pvcreate /dev/mapper/sdb2 
  Physical volume "/dev/mapper/sdb2" successfully created.
  Creating devices file /etc/lvm/devices/system.devices
[root@practice-rocky9 ~]# vgcreate vg_enc /dev/mapper/sdb2
  Volume group "vg_enc" successfully created
[root@practice-rocky9 ~]# lvcreate -l 100%FREE -n lv_enc vg_en
  Volume group "vg_en" not found
  Cannot process volume group vg_en
[root@practice-rocky9 ~]# lvcreate -l 100%FREE -n lv_enc vg_enc
  Logical volume "lv_enc" created.
[root@practice-rocky9 ~]# lvs
  LV     VG     Attr       LSize Pool Origin Data%  Meta%  Move Log Cpy%Sync Convert
  lv_enc vg_enc -wi-a----- 1.84g                                                    
[root@practice-rocky9 ~]# mkfs.xfs /dev/mapper/vg_enc-lv_enc 
meta-data=/dev/mapper/vg_enc-lv_enc isize=512    agcount=4, agsize=120832 blks
         =                       sectsz=512   attr=2, projid32bit=1
         =                       crc=1        finobt=1, sparse=1, rmapbt=0
         =                       reflink=1    bigtime=1 inobtcount=1 nrext64=0
data     =                       bsize=4096   blocks=483328, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0, ftype=1
log      =internal log           bsize=4096   blocks=16384, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0
[root@practice-rocky9 ~]# mkdir /enc
[root@practice-rocky9 ~]# mount /dev/mapper/vg_enc-lv_enc /enc
[root@practice-rocky9 ~]# df -hTP /enc
Filesystem                Type  Size  Used Avail Use% Mounted on
/dev/mapper/vg_enc-lv_enc xfs   1.8G   45M  1.8G   3% /enc
[root@practice-rocky9 ~]#
```

## Unmount and close the crypt disk
```shell
[root@practice-rocky9 ~]# umount /enc
[root@practice-rocky9 ~]# pvs
  PV               VG     Fmt  Attr PSize PFree
  /dev/mapper/sdb2 vg_enc lvm2 u--  1.84g    0 
[root@practice-rocky9 ~]# cryptsetup luksClose sdb2
Device sdb2 is still in use.
[root@practice-rocky9 ~]# lvchange -a n vg_enc/lv_enc
[root@practice-rocky9 ~]# vgchange -a n vg_enc
  0 logical volume(s) in volume group "vg_enc" now active
[root@practice-rocky9 ~]# pvchange -x n /dev/mapper/sdb2 
  Physical volume "/dev/mapper/sdb2" is already unallocatable.
  Physical volume /dev/mapper/sdb2 not changed
  0 physical volumes changed / 1 physical volume not changed
[root@practice-rocky9 ~]# /Close
-bash: /Close: No such file or directory
[root@practice-rocky9 ~]# cryptsetup luksClose sdb2
[root@practice-rocky9 ~]# pvs
[root@practice-rocky9 ~]# 
```

## Make it mount automatically
```shell
[root@practice-rocky9 ~]# openssl genrsa -out /etc/sdb2_key_file 4096
[root@practice-rocky9 ~]# ls -l /etc/sdb2_key_file
-rw------- 1 root root 3272 Apr 24 12:30 /etc/sdb2_key_file
[root@practice-rocky9 ~]# cat /etc/sdb2_key_file
-----BEGIN PRIVATE KEY-----
MIIJRAIBADANBgkqhkiG9w0BAQEFAASCCS4wggkqAgEAAoICAQDCf1rrEb6fUcxF
TjZIatVBoqAGunq+gIe/G1ecs1L2W4NUKdElZhUlXORJg17JzJpVgjiQYcPORHcT
YaaZ7Wq2PaPZtocMZ8BlR61p0kdQO+Pbk2HrA85f1voKYW4Tfut7aEI9s5EureGy
2axhgHOBjANYlmp0klcUqWBKZTpABDY0m7WU1Db3inCBH0Jm26d4Hs+QPBz03ISm
[root@practice-rocky9 ~]# cryptsetup luksAddKey /dev/sdb2 /etc/sdb2_key_file 
Enter any existing passphrase: 
[root@practice-rocky9 ~]# cat /etc/crypttab 
sdb1 /dev/sdb1 /etc/sdb1_key_file luks
sdb2 /dev/sdb2 /etc/sdb2_key_file luks
[root@practice-rocky9 ~]# ls -l /etc/sdb*
-rw------- 1 root root 3272 Apr 24 11:49 /etc/sdb1_key_file
-rw------- 1 root root 3272 Apr 24 12:30 /etc/sdb2_key_file
[root@practice-rocky9 ~]# grep enc /etc/fstab
/dev/mapper/vg_enc-lv_enc /enc xfs defaults 1 2
[root@practice-rocky9 ~]# 
```
