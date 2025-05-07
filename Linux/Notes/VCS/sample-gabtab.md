https://www.veritas.com/support/en_US/article.100022878 

Procedure for starting one node in the cluster when all nodes are down and unavailable
Article: 100022878
Last Published: 2020-08-05
Product(s): InfoScale & Storage Foundation
Problem

This procedure can be used when the user needs to start VCS on a single node in the cluster, where all other clustered nodes are down and unavailable due to a hardware or external issue.

Solution
 
The following procedure should be followed to bring online a single node when a node or nodes will not be powered up for some time.

In this instance, there are two nodes in the cluster and both nodes have been powered off. One of the systems will not startup due to hardware related errors. The other nodes restarts without any issues.

VERITAS Cluster Server (VCS) will not start automatically, because the working node cannot seed the cluster with just one node.  This is due to the /etc/gabtab file on the system.  


Example of  /etc/gabtab in a two node cluster:

# cat/etc/gabtab
/sbin/gabconfig -c -n2
 
 
NOTE: n2 indicates that there must be at least 2 nodes present to seed the cluster.


Verify the other node or nodes aredown and completely unavailable.  If there is a possibility that anothernode is running and has the diskgroup imported, the following steps could causesplit brain, which could damage data.

Manually seed the node into asingle node cluster:

           # gabconfig-cx

Start the cluster

           # hastart

When the other nodes are repaired, VCS should automatically allow the returning clustered nodes to join the active single node cluster.

Do not use -x in the /etc/gabtab.  

The -cx options are used to manually & temporarily start GAB where all nodes forming the cluster are not available.

NOTE: There is no need to remove other node (system) information from the main.cf file with this procedure.

If there are any questions about the current cluster configuration in relation to this procedure, please contact Veritas Technical Support.