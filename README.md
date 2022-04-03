# Linear timelock smart contract
Solidity smart contract which disburses ERC20 tokens linearly, over a specific period of time (all values are dynamic and are set by the contract owner)

## How to deploy this linear timelock smart contract

### Step 1

- [ ] Create a brand new account (a new private/public key pair); and do not share the private key with anyone. 
- [ ] Ensure that the aforementioned account is selected in your wallet software i.e. MetaMask or similar.
- [ ] Ensure that your wallet software is connected to the correct network.
- [ ] Compile the [LinearTimelock.sol](https://github.com/second-state/linear-timelock-smart-contract/blob/main/LinearTimelock.sol) contract using Solidity `0.8.11` via the [Remix IDE](https://remix.ethereum.org/). Using version `0.8.11` is important because it provides overflow checks and is compatible with the version of SafeMath which the contract uses.

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

### Step 4
Check the timestamp variables are correct, before transferring any tokens. This is your final opportunity to discard this contract if any mistakes have been made with the timestamps.

**timestampSet**

Check that the `timestampSet` variable is `true`

![Screen Shot 2022-01-24 at 12 58 00 pm](https://user-images.githubusercontent.com/9831342/150715021-63881e4f-02d8-43d5-a421-452ce2155461.png)

**initialTimestamp**

Check the `initialTimestamp` variable, and confirm its value in proper date format by using [an online epoch to date converter](https://www.epochconverter.com/)

![Screen Shot 2022-01-24 at 1 00 20 pm](https://user-images.githubusercontent.com/9831342/150715109-8ef231f7-45f3-48a8-8c1a-25bc9b561a66.png)

For example, the value in the above image, `1642993044` is equivalent to `Monday, 24 January 2022 12:57:24 GMT+10:00`

**cliffEdge**

Check the `cliffEdge` variable, and confirm its value is what your lockup period is intended to be.

![Screen Shot 2022-01-24 at 1 03 23 pm](https://user-images.githubusercontent.com/9831342/150715310-3c0d4511-9648-421b-b755-216adfc1ce09.png)

For example, the value in the above image, `1643079444` is equivalent to `Tuesday, 25 January 2022 12:57:24 GMT+10:00` (which is exactly one day ahead of the `initialTimestamp` which is correct)

**releaseEdge**

Check the `releaseEdge` variable, and confirm its value is what your release period is intended to be.

![Screen Shot 2022-01-24 at 1 05 20 pm](https://user-images.githubusercontent.com/9831342/150715477-ebdef460-0802-4e44-b3b3-ae0dbd16af01.png)

For example, the value in the above image, `1643252244` is equivalent to `Thursday, 27 January 2022 12:57:24 GMT+10:00` (which is exactly 2 days ahead of the `cliffEdge` which is the same as being 3 days ahead of the `initialTimestamp`, which is correct).

### Checking the associated ERC20 contract

First of all, please check to make absolutely sure that the ERC20 contract associated with this linear timelock contract is correct. This can be done by calling the `erc20Contract` variable, as shown below.

![Screen Shot 2022-01-24 at 1 09 22 pm](https://user-images.githubusercontent.com/9831342/150715931-edfe5dde-1c6c-4651-8239-c6cb01b27971.png)

### Allocating user tokens into the timelock contract

Tokens can be allocated to users one at a time using the `depositToken` function, as shown below.

![Screen Shot 2022-01-24 at 1 11 21 pm](https://user-images.githubusercontent.com/9831342/150716076-6d6bed3b-25ac-48ce-b54a-f7d7a3e94b26.png)

Tokens can also be allocated in bulk using the `bulkDepositTokens` function. 

Always keep an exact record of how many tokens (sum total of all ERC20 tokens) which you allocated to the users. This sum total figure is required for the next step (and ensures that there will be the exact amount of tokens in the linear timelock contract to service all of the users, who will be performing the unlock).

### Transfer ERC20 tokens to the linear timelock contract
From the ERC20 token contract, use the `transfer` function to transfer ERC20 tokens to the linear timelock smart contract's address.

![Screen Shot 2022-01-24 at 1 15 46 pm](https://user-images.githubusercontent.com/9831342/150716642-b2d63734-e928-4513-aa44-860e016be358.png)

You can confirm that these tokens have been transferred by pasting the linear timelock contract's address into the ERC20 contract's `balanceOf` function, as shown below.

![Screen Shot 2022-01-24 at 1 19 48 pm](https://user-images.githubusercontent.com/9831342/150716797-ec250368-538d-4105-80c2-8427031b57c6.png)

### Finalize owner participation
Once all allocations have been made and the ERC20 tokens have been transferred into the linear timelock contract, the owner can call the linear timelock contract's `finalizeAllIncomingDeposits()` function. This makes the linear timelock non-custodial, whereby the contract owner has no ability to alter token amounts and so forth. The operation of the linear timelock contract is purely based on the math in the `transferTimeLockedTokensAfterTimePeriod` function from this point forward.


# How to use this linear timelock DApp
The smart contract is deployed and then coupled with [the official linear timelock user interface](https://www.npmjs.com/package/linear-timelock-token-user-interface). Please follow the instructions in the [linear timelock user interface's README.md](https://github.com/second-state/linear-timelock-user-interface/blob/main/README.md)
