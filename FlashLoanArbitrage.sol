// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {FlashLoanSimpleReceiverBase} from "@aave/core-v3/contracts/flashloan/base/FlashLoanSimpleReceiverBase.sol";
import {IPoolAddressesProvider} from "@aave/core-v3/contracts/interfaces/IPoolAddressesProvider.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract FlashLoanArbitrage is FlashLoanSimpleReceiverBase {
    address public owner;

    constructor(address _addressProvider) FlashLoanSimpleReceiverBase(IPoolAddressesProvider(_addressProvider)) {
        owner = msg.sender;
    }

    /**
     * @dev This function is called after your contract has received the flash loaned amount
     */
    function executeOperation(
        address asset,
        uint256 amount,
        uint256 premium,
        address initiator,
        bytes calldata params
    ) external override returns (bool) {
        // 1. ARBITRAGE LOGIC GOES HERE
        // Example: Swap 'amount' of 'asset' on Uniswap, then SushiSwap
        
        // 2. ENSURE PROFITABILITY
        // Logic to check if (currentBalance > amount + premium)

        // 3. APPROVE REPAYMENT
        uint256 amountToReturn = amount + premium;
        IERC20(asset).approve(address(POOL), amountToReturn);

        return true;
    }

    function requestFlashLoan(address _token, uint256 _amount) public {
        address receiverAddress = address(this);
        address asset = _token;
        uint256 amount = _amount;
        bytes memory params = "";
        uint16 referralCode = 0;

        POOL.flashLoanSimple(
            receiverAddress,
            asset,
            amount,
            params,
            referralCode
        );
    }

    function withdraw(address _token) external {
        require(msg.sender == owner, "Only owner");
        IERC20 token = IERC20(_token);
        token.transfer(owner, token.balanceOf(address(this)));
    }

    receive() external payable {}
}
