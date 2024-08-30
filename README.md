# Kronos

From NDSS 2025 submission: *"Kronos: A Secure and Generic Sharding Blockchain Consensus with Optimized Overhead"*.

[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.13594519.svg)](https://doi.org/10.5281/zenodo.13594519)

Proof-of-Concept implementation for a sharding blockchain consensus framework. 

In this project, the intra-shard BFT protocol is implemented using asynchronous Speeding-Dumbo (in the main-branch) or partially synchronous Rotating-Hotstuff (in the hotstuff-branch).


### Running on Local Machines

The project can be run on local machines (with Ubuntu 18.04 LTS) after using env-batch.sh to install all dependencies:

`sudo ./env-batch.sh`

*Note: The bash script includes all necessary dependencies to run Kronos on a clean Ubuntu 18.04 LTS machine. If any dependencies are still reported as missing after running the script (likely due to OS differences or other factors), please install the missing dependencies manually. This issue will not occur when using Docker or during distributed deployment. Additionally, some error messages encountered during environment configuration (e.g., the Make Test error from charm) do not affect the overall execution process. Once the configuration is complete, you can run the code without resolving all the errors.*

A quick start to run Kronos with Speeding-Dumbo (*main-branch*) can be:

   `./start.sh 3 4 1 1000 5 0 12 1250 3000`

   This command initiates a quick experiment. Here is a breakdown of the parameters:

   `./start.sh [shard-num] [N] [f] [B] [R] (( i * node )) node [TXs] [cross-shard TXs]`

   * `[shard-num]`: number of shards in the system
   * `[N]`: shard size
   * `[f]`: number of Byzantine nodes inside each shard
   * `[B]`: BFT batch size
   * `[R]`: number of BFT rounds run in each test
   * `(( i * node ))` node: which node to start from (usually at 0)
   * `[TXs]`: size of each node's transaction queue
   * `[cross-shard TXs]`: number of overall cross-shard transactions in the system

When running Kronos with Rotating-Hotstuff (*hotstuff-branch*), the quick start is:

`./start.sh 3 4 1 1000 5 0 12 5000 20000`

 Once the execution is complete, you will see the following message:
        
    All nodes finished. Returning to command line prompt.

#### Running on Local Machines using Docker

We have also created a Dockerfile for quick local deployment, eliminating the need for manual dependency installation. The Docker image has been uploaded to Dockerhub.

To run Kronos using Docker, please ensure that Docker is installed on your machine. You can install it by running the following command: 

`sudo apt install docker.io`

The following steps outline the process for evaluating the Kronos implementation using the Docker image:
1. Pull the docker image to your local machine:
   
    `sudo docker pull hiddeneer/kronos-1.1`

    This command pulls the implementation that uses Speeding-Dumbo as intra-shard BFT protocol. If you wish to run the implementation with Rotating-Hotstuff, use the following command instead:

    `sudo docker pull hiddeneer/kronos-hotstuff-1.0` 
    
2. Run the Docker container:
   
    `sudo docker run -it hiddeneer/kronos-1.1`

    or, for the Rotating-Hotstuff version:

    `sudo docker run -it hiddeneer/kronos-hotstuff-1.0`

    Once inside the Docker container, you should be in the *kronos* directory.

3. Execute the quick start:
   
    `./start.sh 3 4 1 1000 5 0 12 1250 3000`


Please refer to the `/docker` directory for more details on running the Dockerfile.



### Running with Distributed Deployment

#### Key Generation
To generate the necessary keys for distributed deployment, use the following command:

`python3 run_trusted_key_gen.py --N [N] --f [f]`

* `[N]`: shard size
* `[f]`: number of Byzantine nodes inside each shard

#### AWS Deployment

If you would like to run the code among AWS cloud servers (with Ubuntu 18.04 LTS), you can follow the commands in the `/aws` directory to remotely start the protocols on all servers. A detail example of conducting WAN experiments from your PC terminal is as follows:

1. Start the server via the Amazon Cloud web interface. Enter the relevant parameters, such as ***region***, ***N*** (number of servers), and ***node*** (number of nodes per server), in `data/script-generator.py`.
2. Run `data/script-generator.py` to generate the scripts for the nodes and IP sections, and replace the corresponding sections in the files within the `/aws` folder.
3. Adjust the version to be executed by modifing the git clone command in `aws-pre` and configure the run parameters by modifing `./start.sh` in `aws-run`. Then, run the following scripts sequentially.
   
    ```shell
    ./aws-pre
    ./aws-run
    ./aws-log
    ```
    *(For convenience, the script distributes all keys to all servers during aws-run. You can modify the script if you'd prefer to assign specific keys to specific servers.)*


4. Use the scripts in `/data` directory to process the data, which will be stored in `total-log`.



## License

This is released under the CRAPL academic license. See ./CRAPL-LICENSE.txt. Other licenses may be issued at the authors' discretion.
