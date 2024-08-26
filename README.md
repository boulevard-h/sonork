# kronos

*From the NDSS 2025 paper: "Kronos: A Secure and Generic Sharding Blockchain Consensus with Optimized Overhead"*

Proof-of-Concept implementation for a sharding asynchronous BFT consensus framework.

Two protocols are currently available as intra-shard protocols: Speeding-Dumbo(main-branch), Rotating-Hotstuff(hotstuff-branch).

### Quick Start

#### ubuntu

1. To run the benchmarks at your local machine (with Ubuntu 18.04 LTS), use env-batch.sh to  install all dependencies:

    `sudo ./env-batch.sh`
*Note: Some underlying dependencies may be missing when configuring the local environment, such as **libssl-dev** or **libgmp3-dev**. Please install it yourself. This issue will not occur with subsequent docker and aws environments.
Some error messages during environment configuration do not affect the overall running process of the test code (for example, the Make Test error of charm). After the configuration is complete, you can run the code first without having to solve all the errors.*

2. A quick start to run kronos can be:

   `./start.sh 3 4 1 1000 5 0 12 1250 3000`

   This command initiates a quick experiment. Here is a breakdown of the parameters:

   `./start.sh [shard-num] [N] [f] [B] [R] (( i * node )) node [TXs] [cross-shard TXs]`

   * `[shard-num]`: number of shards in the system
   * `[N]`:shard size
   * `[f]`: number of Byzantine nodes inside each shard
   * `[B]`: BFT batch size
   * `[R]`: number of BFT rounds run in each test
   * `(( i * node ))` node: which node to start from (usually at 0)
   * `[TXs]`: size of each node's transaction queue
   * `[cross-shard TXs]`: number of overall cross-shard transactions in the system

    Once the execution is complete, you will see the following message

#### docker

We have created a Dockerfile for quick local deployment and uploaded the image to Dockerhub. See the `docker` folder for details.

### Distributed deployment

#### key generation

`python3 run_trusted_key_gen.py --N [N] --f [f]`

* `[N]`:shard size
* `[f]`: number of Byzantine nodes inside each shard

#### aws deployment

If you would like to test the code among AWS cloud servers (with Ubuntu 18.04 LTS). You can follow the commands inside /aws to remotely start the protocols at all servers. A detail example to conduct the WAN tests from your PC side terminal can be:

* Start the server on the Amazon Cloud web interface. Enter the relevant parameters (***region***, ***N*** (number of servers), ***node*** (number of nodes per server)) in the corresponding places in `data/script-generator.py`.
* Run `data/script-generator.py` to generate the script for the nodes and IP sections, and replace them in the files within the `aws` folder.
* Adjust the version to be run (modify the git clone content in `aws-pre`) and the run parameters (modify the `./start.sh` parameters in `aws-run`), then run `aws-pre`, `aws-config`, `aws-run`, and `aws-log` sequentially.
 ```shell
 ./aws-pre
 ./aws-config --keys
 ./aws-run
 ./aws-log
 ```

（For convenience, all keys are distributed here to all servers in *aws-config*. You can modify the script to send a specific key to a specific server.）


* Use the scripts in the `data` folder to process the retrieved data (stored in `total-log`).



## License

This is released under the CRAPL academic license. See ./CRAPL-LICENSE.txt Other licenses may be issued at the authors' discretion.
