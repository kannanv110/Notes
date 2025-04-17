
**huge_pagesன்னா என்ன?**

பொதுவா லினக்ஸ் சிஸ்டம்ல மெமரியை (RAM) சின்னச் சின்ன பக்கங்களா (pages) பிரிச்சு நிர்வகிக்கும். இந்த பக்கங்களோட சைஸ் வழக்கமா 4KB இருக்கும்.

"huge_pages"ங்கிறது இந்த வழக்கமான பக்கங்களை விட ரொம்பப் பெரிய சைஸ்ல இருக்கிற மெமரி பக்கங்கள். இதோட சைஸ் 2MB இல்லன்னா அதைவிட பெருசாக்கூட இருக்கலாம் (சிஸ்டம் கான்பிகரேஷனைப் பொறுத்து).

**ஏன் huge_pages தேவைப்படுது?**

சில அப்ளிகேஷன்கள் ரொம்ப அதிக மெமரியை உபயோகப்படுத்தும். உதாரணத்துக்கு, டேட்டாபேஸ் சிஸ்டம்ஸ் (Database Systems), விர்ச்சுவலைசேஷன் சாஃப்ட்வேர் (Virtualization Software) மாதிரியான அப்ளிகேஷன்கள் பல ஜிகாபைட் கணக்குல மெமரியை யூஸ் பண்ணும்.

இந்த மாதிரி அப்ளிகேஷன்கள் வழக்கமான 4KB பக்கங்களை உபயோகிக்கும்போது, சிஸ்டம் நிறைய நேரத்தை இந்த சின்னச் சின்ன பக்கங்களை நிர்வகிக்கவே செலவழிக்கும். இது சிஸ்டத்தோட பெர்ஃபார்மன்ஸை (performance - செயல்திறன்) குறைக்கும்.

இங்கதான் huge_pages உதவிகரமா இருக்கும்:

* **குறைவான நிர்வாக வேலை:** பெரிய பக்கங்களா இருக்கும்போது, சிஸ்டம் நிர்வகிக்க வேண்டிய பக்கங்களோட எண்ணிக்கை குறையும். இதனால மெமரி மேனேஜ்மென்ட் பண்றதுக்கான ஓவர்ஹெட் (overhead - கூடுதல் வேலை) குறையும்.
* **வேகமான டேட்டா அணுகல்:** சில அப்ளிகேஷன்கள் பெரிய அளவு டேட்டாவை ஒரே நேரத்துல ஆக்சஸ் பண்ணும். huge_pages உபயோகிக்கும்போது, இந்த டேட்டாவை வேகமா அணுக முடியும். ஏன்னா, தேவையான மெமரி ஒரே தொடர்ச்சியான பெரிய блоக்கா இருக்கும்.
* **TLB (Translation Lookaside Buffer) மிஸ் ஆவது குறையும்:** TLBங்கிறது மெய்நிகர் முகவரிகளை (virtual addresses) இயற்பியல் முகவரிகளா (physical addresses) மாத்துற ஒரு சின்ன கேஷ் மெமரி. சின்னப் பக்கங்களா இருந்தா, நிறைய பக்கங்களுக்கான மேப்பிங் தேவைப்படும். அதனால TLBல இடம் பத்தாம அடிக்கடி மிஸ் ஆகும். huge_pages உபயோகிக்கும்போது, குறைவான மேப்பிங் இருந்தா போதும், அதனால TLB மிஸ் ஆகுறது குறைஞ்சு டேட்டா ஆக்சஸ் பண்ற வேகம் அதிகரிக்கும்.

**சுருக்கமா சொன்னா:**

huge_pagesங்கிறது லினக்ஸ்ல இருக்கிற பெரிய சைஸ் மெமரி பக்கங்கள். அதிக மெமரி யூஸ் பண்ற அப்ளிகேஷன்களோட பெர்ஃபார்மன்ஸை அதிகரிக்க இது உதவுது. சின்னச் சின்ன பக்கங்களை நிர்வகிக்கிற வேலையை குறைச்சு, டேட்டா ஆக்சஸ் பண்ற வேகத்தை இது கூட்டுது.

உதாரணத்துக்கு, ஒரு பெரிய டேட்டாபேஸ் சிஸ்டம் huge_pages உபயோகிச்சா, டேட்டாவை தேடுறதும், எழுதுறதும் ரொம்ப வேகமா நடக்கும்.



**What are huge_pages?**

In a standard Linux system, memory (RAM) is managed in small units called **pages**. The typical size of these pages is 4KB.

**Huge pages** are memory pages that are significantly larger than the standard 4KB size. They are typically 2MB or even larger (depending on the system configuration).

**Why are huge_pages needed?**

Certain applications, especially those that are memory-intensive, like database systems and virtualization software, can utilize gigabytes of RAM. When these applications rely on the standard 4KB pages, the system spends a considerable amount of time managing these numerous small pages. This management overhead can negatively impact the system's performance.

This is where huge_pages come into play:

* **Reduced Management Overhead:** With larger page sizes, the total number of pages the system needs to manage decreases significantly. This reduces the overhead associated with memory management.
* **Faster Data Access:** Applications dealing with large datasets can experience faster data access when using huge_pages. This is because the required memory can be allocated in larger contiguous blocks.
* **Improved TLB (Translation Lookaside Buffer) Hit Rate:** The TLB is a small cache that stores the mappings between virtual addresses and physical addresses. With smaller pages, more mappings are needed, increasing the chances of a TLB miss (when the required mapping isn't in the TLB). Huge pages reduce the number of mappings required, leading to a higher TLB hit rate and faster memory access.

**In simple terms:**

Huge pages in Linux are like using larger pieces of paper instead of many small slips of paper to manage a large document. It reduces the effort of handling numerous small pieces, making the overall process more efficient, especially for applications that work with a lot of memory. By using larger memory chunks, the system can manage memory more efficiently and improve the performance of memory-intensive applications.

For example, a large database system using huge_pages can potentially perform queries and data manipulation much faster.

You can configure huge_pages in Linux through a few different methods. Here's a breakdown of the common approaches:

**1. Using Kernel Boot Parameters (Recommended for Persistent Configuration):**

This is the most reliable method as it allocates huge pages early in the boot process before memory fragmentation occurs.

* **Determine the Huge Page Size:**
    ```bash
    grep Hugepagesize /proc/meminfo
    ```
    The output will show the huge page size in KB (e.g., `Hugepagesize: 2048 kB` for 2MB pages). Note this value.

* **Calculate the Number of Huge Pages:**
    Determine the total amount of memory you want to allocate to huge pages and divide it by the huge page size. For example, to allocate 4GB (4096MB) with a 2MB page size:
    ```
    4096 MB / 2 MB = 2048 huge pages
    ```

* **Edit the Bootloader Configuration File:**
    You'll need to modify your bootloader configuration file (usually `/etc/default/grub` for GRUB). Find the line starting with `GRUB_CMDLINE_LINUX` and add the following parameters:

    * For a specific size (e.g., 2MB and 2048 pages):
        ```
        GRUB_CMDLINE_LINUX="... default_hugepagesz=2M hugepagesz=2M hugepages=2048"
        ```
    * For a specific size (e.g., 1GB and 4 pages):
        ```
        GRUB_CMDLINE_LINUX="... default_hugepagesz=1G hugepagesz=1G hugepages=4"
        ```
    * To allocate a number of default-sized huge pages (without explicitly specifying the size again):
        ```
        GRUB_CMDLINE_LINUX="... hugepages=2048"
        ```

* **Update the Bootloader:**
    After editing the file, you need to update the bootloader configuration:
    * For Debian/Ubuntu:
        ```bash
        sudo update-grub
        ```
    * For Red Hat/CentOS/Fedora (using GRUB2):
        ```bash
        sudo grub2-mkconfig -o /boot/grub2/grub.cfg
        ```
    * For older systems using GRUB (GRUB Legacy):
        ```bash
        sudo grub-mkconfig -o /boot/grub/menu.lst
        ```

* **Reboot the System:**
    The huge pages will be allocated during the boot process.

* **Verify Huge Page Allocation:**
    After rebooting, check the allocated huge pages:
    ```bash
    grep Huge /proc/meminfo
    ```
    You should see the `HugePages_Total` value reflecting the number you configured. `HugePages_Free` will show how many are currently unused.

**2. Using `sysctl` (Temporary Configuration):**

You can dynamically allocate huge pages while the system is running using the `sysctl` command. However, these allocations might fail if contiguous memory is not available, and they are not persistent across reboots.

* **Set the Number of Huge Pages:**
    ```bash
    sudo sysctl -w vm.nr_hugepages=2048
    ```
    Replace `2048` with the desired number of huge pages.

* **Verify Allocation:**
    ```bash
    grep Huge /proc/meminfo
    ```

* **Make it Persistent (Optional):**
    To make this setting persistent across reboots, add the following line to the `/etc/sysctl.conf` file:
    ```
    vm.nr_hugepages = 2048
    ```
    Then apply the changes:
    ```bash
    sudo sysctl -p
    ```

**3. Using `/sysfs` (Alternative Temporary Configuration):**

You can also interact with the `/sys` filesystem to allocate huge pages.

* **Navigate to the Huge Pages Directory:**
    The directory will be something like `/sys/kernel/mm/hugepages/hugepages-<size>kB/`, where `<size>` is the huge page size in KB (e.g., `hugepages-2048kB`).

* **Echo the Number of Pages:**
    ```bash
    echo 2048 | sudo tee /sys/kernel/mm/hugepages/hugepages-2048kB/nr_hugepages
    ```
    Replace `2048` and `2048kB` with your desired values.

* **Verification:**
    Use `grep Huge /proc/meminfo` to check.

**4. Setting `memlock` Limits:**

Applications need permission to lock huge pages in memory. You need to configure the `memlock` limits for the user running the application.

* **Edit `/etc/security/limits.conf`:**
    Add or modify the following lines for the relevant user or group (e.g., for the `oracle` user):
    ```
    oracle soft memlock unlimited
    oracle hard memlock unlimited
    ```
    Or to set a specific limit (in KB):
    ```
    oracle soft memlock 6291456  # 6GB (example)
    oracle hard memlock 6291456  # 6GB (example)
    ```

* **Log Out and Back In:**
    The user needs to log out and back in for these limits to take effect.

* **Verify the Limit:**
    Log in as the user and run:
    ```bash
    ulimit -l
    ```
    This should show the `memlock` limit.

**Mounting the `hugetlbfs` Filesystem (for Applications using `mmap` with `MAP_HUGETLB`):**

Some applications use the `mmap` system call with the `MAP_HUGETLB` flag to allocate memory from the huge page pool. For this to work, you might need to mount the `hugetlbfs` filesystem.

* **Create a Mount Point (if it doesn't exist):**
    ```bash
    sudo mkdir /mnt/huge
    ```

* **Mount `hugetlbfs`:**
    ```bash
    sudo mount -t hugetlbfs nodev /mnt/huge
    ```

* **Make it Persistent (Optional):**
    Add the following line to `/etc/fstab`:
    ```
    nodev   /mnt/huge   hugetlbfs rw,mode=1777 0 0
    ```
    The `mode=1777` allows any user to read and write within the mount point (with the sticky bit set). Adjust permissions as needed.

**Choosing the Right Method:**

* For production environments and persistent huge page allocation, **using kernel boot parameters is highly recommended**.
* `sysctl` is useful for temporary adjustments or testing.
* `/sysfs` provides a direct interface but is also temporary.
* Setting `memlock` limits is crucial for applications to be able to use huge pages.
* Mounting `hugetlbfs` is necessary for applications that explicitly use the `MAP_HUGETLB` flag.

Remember to adjust the number of huge pages based on your system's total memory and the requirements of your memory-intensive applications. Oracle recommends reserving no more than 70% of the total memory for huge pages, leaving at least 30% for standard page allocations.