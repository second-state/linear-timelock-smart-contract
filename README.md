# Linear timelock smart contract
Solidity smart contract which disburses ERC20 tokens linearly, over a specific period of time (all values are dynamic and are set by the contract owner)

## How to deploy this linear timelock smart contract

### Step 1
Compile the LinearTimelock.sol smart contract using remix, as shown below.

![Screen Shot 2022-01-24 at 12 10 43 pm](https://user-images.githubusercontent.com/9831342/150711101-ad2b274a-2b34-4de5-b8ed-5a592b765471.png)

### Step 2
As the contract owner, deploy the LinearTimelock.sol. The only parameter required is the address of the ERC20 contract for which we are locking up tokens for.

![Screen Shot 2022-01-24 at 12 12 14 pm](https://user-images.githubusercontent.com/9831342/150711254-60441ff7-3fd5-4d1d-8005-eb73af1aebe2.png)

### Step 3
Perform the `setTimestamp` function and pass in the two required parameters:
1. the `_cliffTimePeriod` - the amount of seconds from **now** until when the linear **unlocking** (release) period **begins**
2. the `_releaseTimePeriod` - the entire amount of seconds from **now** until when the **unlocking** period **ends** (this is inclusive of the `_cliffTimePeriod`)

![linear-diagram](https://user-images.githubusercontent.com/9831342/150713492-ab7eba3a-207f-4e58-a94c-a2cee8181c37.jpg)

For example if you want to:
- lock the tokens for 1 day 
- then (after 1 day has passed) commence releasing the tokens linearly over an **additional** 2 day period

![cliff_and_release_example](https://user-images.githubusercontent.com/9831342/150714593-0bc77777-c01b-4617-a67d-547fcd3d9e52.jpg)

The `_cliffTimePeriod` will be `86400` (1 day represented in seconds) 
The `_releaseTimePeriod` will be `259200` (3 days represented in seconds).

![Screen Shot 2022-01-24 at 12 47 04 pm](https://user-images.githubusercontent.com/9831342/150713778-6c2d76ec-f0f6-4acb-b401-9991d0c7e781.png)

# How to use this linear timelock DApp
The smart contract is deployed and then coupled with [the official linear timelock user interface](https://www.npmjs.com/package/linear-timelock-token-user-interface). Please follow the instructions in the [linear timelock user interface's README.md](https://github.com/second-state/linear-timelock-user-interface/blob/main/README.md)
