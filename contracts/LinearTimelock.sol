// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

import "@openzeppelin/contracts/token/ERC20/utils/TokenTimelock.sol";

contract TokenTimelock_Contributors is TokenTimelock {
    using SafeERC20 for IERC20;

    uint256 private immutable _releaseEndTime;
    uint256 public depositedAmount;
    uint256 public withdrawnAmount;

    constructor(
        IERC20 token_,
        address beneficiary_,
        uint256 releaseTime_,
        uint256 releaseEndTime_
    ) TokenTimelock(token_, beneficiary_, releaseTime_) { 
        require(releaseEndTime_ > releaseTime_, "release end time gt release time");
        _releaseEndTime = releaseEndTime_;
        depositedAmount = token().balanceOf(address(this));
    }

    /**
     * @dev Returns the end time when the tokens are released in seconds since Unix epoch (i.e. Unix timestamp).
     */
    function releaseEndTime() public view virtual returns (uint256) {
        return _releaseEndTime;
    }

    function release() public override {
        require(block.timestamp >= releaseTime(), "TokenTimelock: current time is before release time");
        
        if (token().balanceOf(address(this)) > depositedAmount) {
            depositedAmount += (token().balanceOf(address(this)) - depositedAmount);
        }

        uint256 currentTime = block.timestamp < releaseEndTime() ? block.timestamp : releaseEndTime();
        uint256 amount = depositedAmount + withdrawnAmount;
        amount *= (currentTime / (releaseEndTime() - releaseTime()) - withdrawnAmount);
    
        require(amount > 0, "TokenTimelock: no tokens to release");

        token().safeTransfer(beneficiary(), amount);
    }
}
