You're asking about the essential network port numbers used by common services in Linux. These ports allow different applications and services to communicate over a network. Here's a breakdown of some of the most important ones:

**Well-Known Ports (0-1023):** These are reserved for standard services.

* **20/TCP, 21/TCP:** **FTP (File Transfer Protocol)** - Used for transferring files between systems. Port 20 is for data transfer (active mode), and port 21 is for control commands.
* **22/TCP:** **SSH (Secure Shell)** - Provides secure, encrypted remote access to the command line of a Linux system.
* **23/TCP:** **Telnet** - An unencrypted protocol for remote terminal access (less secure than SSH and rarely used now).
* **25/TCP:** **SMTP (Simple Mail Transfer Protocol)** - Used for sending email between mail servers.
* **53/TCP, 53/UDP:** **DNS (Domain Name System)** - Translates domain names into IP addresses. TCP is typically used for zone transfers, and UDP for regular queries.
* **67/UDP, 68/UDP:** **DHCP (Dynamic Host Configuration Protocol)** - Used for automatically assigning IP addresses and network configuration to clients. Port 67 is for the server, and port 68 is for the client.
* **80/TCP:** **HTTP (Hypertext Transfer Protocol)** - The foundation of the World Wide Web, used for unencrypted web traffic.
* **110/TCP:** **POP3 (Post Office Protocol version 3)** - Used by email clients to retrieve email from a mail server (older protocol).
* **143/TCP:** **IMAP (Internet Message Access Protocol)** - Used by email clients to manage and retrieve email from a mail server (more modern than POP3).
* **443/TCP:** **HTTPS (HTTP Secure)** - The secure version of HTTP, using TLS/SSL encryption for secure web communication.
* **445/TCP:** **SMB/CIFS (Server Message Block/Common Internet File System)** - Used for file and printer sharing, especially in Windows environments.
* **993/TCP:** **IMAPS (IMAP over SSL/TLS)** - Secure, encrypted version of IMAP.
* **995/TCP:** **POP3S (POP3 over SSL/TLS)** - Secure, encrypted version of POP3.

**Registered Ports (1024-49151):** These are used by applications and services that are not as widely standardized as the well-known ports.

* **1521/TCP:** **Oracle Database** - Default port for the Oracle database listener.
* **3306/TCP:** **MySQL/MariaDB** - Default port for MySQL and MariaDB database servers.
* **5432/TCP:** **PostgreSQL** - Default port for the PostgreSQL database server.
* **5900/TCP:** **VNC (Virtual Network Computing)** - Used for remote desktop access.
* **6379/TCP:** **Redis** - Default port for the Redis in-memory data structure store.
* **8080/TCP:** **HTTP Alternate** - Often used for development web servers or proxy servers.

**Dynamic/Private Ports (49152-65535):** These ports are typically used for temporary or short-lived connections and are often assigned dynamically by the operating system.

**How to Check Open Ports in Linux:**

You can use various commands to see which ports are currently open and listening on your Linux system:

* **`netstat -tuln`**: Displays a list of listening TCP and UDP ports along with the associated processes.
* **`ss -tuln`**: A newer and often faster alternative to `netstat` for displaying socket statistics.
* **`sudo lsof -i -P -n | grep LISTEN`**: Lists open files related to network sockets that are in a listening state.

Understanding these common port numbers is crucial for network administration, security, and troubleshooting on Linux systems. Knowing which services are running on which ports helps in configuring firewalls, diagnosing connectivity issues, and understanding network traffic.