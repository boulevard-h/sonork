The Kronos implementation is packaged into a Docker image and uploaded to Docker Hub for easy access and execution.

To get started, ensure that Docker is installed on your machine. You can install it by running the following command: 

`sudo apt install docker.io`

The following steps outline the process for evaluating the Kronos implementation using the Docker image:
1. Pull the docker image to your local machine:
   
    `sudo docker pull hiddeneer/kronos-1.1:latest`

2. Run the Docker container:
   
    `sudo docker run -it hiddeneer/kronos-1.1:latest`

    (At this point, it's inside the docker container, and the directory should be *kronos*)

3. Execute the Kronos project:
   
    `./start.sh 3 4 1 1000 5 0 12 1250 3000`

    This command initiates a quick experiment. Here is a breakdown of the parameters:

    `./start.sh [shard-num] [N] [f] [B] [R] (( i * node )) node [TXs] [cross-shard TXs]`

   * `[shard-num]`: number of shards in the system
   *  `[N]`:shard size
   *  `[f]`: number of Byzantine nodes inside each shard
   *  `[B]`: BFT batch size
   *  `[R]`: number of BFT rounds run in each test
   *  `(( i * node ))` node: which node to start from (usually at 0)
   *  `[TXs]`: size of each node's transaction queue
   *  `[cross-shard TXs]`: number of overall cross-shard transactions in the system

    Once the execution is complete, you will see the following message:
        
        All nodes finished. Returning to command line prompt.
    
    At this point, a command prompt will appear. 
(If you encounter the message "./start.sh: 36: exec: : Permission denied", you can safely ignore it as long as the finish message is displayed. This error does not affect the outcome of the execution.)

4. Collect and analyze the data:
   
    Navigate to the data directory and execute the following Python script to collect TPS-related data:

    `cd data`

    `python3 TPS_latency-log.py`

    After the execution is complete, the output will display the following information:
    
        Average TPS and latency for each group:    
        Group x1: TPS = xxx, Latency = xxx
        .......
        Group xn: TPS = xxx, Latency = xxx
        Number of data groups actually received: x
        Total TPS sum across different groups: xxx
        Average latency across all groups: xxx

    For more detailed data about latency, you can execute another script: `python3 delay-log.py`

1. Exit

    When all tests are completed, exit the current container by typing:
    
    `exit`