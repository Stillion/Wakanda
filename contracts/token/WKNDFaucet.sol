// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./WKNDToken.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

// A faucet for ERC20 token WKND
contract WKNDFaucet {

	using SafeMath for uint;

	WKNDToken WToken;
	address WKNDOwner;
    address tokenAddress = 0x53bB7aA27f1Ca45E1683eDf537174be746695d69;

	constructor(){
		// Initialize the WKNDToken with the token address
		WToken = WKNDToken(tokenAddress);
		WKNDOwner = msg.sender;
	}

    modifier onlyOwner(){
        require(msg.sender == WKNDOwner);
        _;
    }


	function withdraw(uint _withdraw_amount) public {

    	// Limit withdrawal amount to 1 WKND
    	require(_withdraw_amount <= 1 && _withdraw_amount > 0);

		uint wkndAmount = _withdraw_amount.mul(1000000000000000000);

		// Use the transferFrom function of WKNDToken
		WToken.transferFrom(WKNDOwner, msg.sender, wkndAmount);
    }

    function setTokenAddress(address _tokenAddress) external onlyOwner{
        tokenAddress = _tokenAddress;
    }

	// REJECT any incoming ether
	receive () external payable { revert(); }

}