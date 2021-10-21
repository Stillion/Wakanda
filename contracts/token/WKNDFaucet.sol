// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./WKNDToken.sol";


// A faucet for ERC20 token WKND
contract WKNDFaucet {

	WKNDToken WToken;
	address WKNDOwner;
    address tokenAddress = 0x150458678Acf69224047d3bDa31BA0B944B5d1ff;

	constructor(){
		// Initialize the WKNDToken with the token address
		WToken = WKNDToken(tokenAddress);
		WKNDOwner = msg.sender;
	}

    modifier onlyOwner(){
        require(msg.sender == WKNDOwner);
        _;
    }


	function withdraw(uint withdraw_amount) public {

    	// Limit withdrawal amount to 1 WKND
    	require(withdraw_amount <= 1000000000000000000);

		// Use the transferFrom function of WKNDToken
		WToken.transferFrom(WKNDOwner, msg.sender, withdraw_amount);
    }

    function setTokenAddress(address _tokenAddress) external onlyOwner{
        tokenAddress = _tokenAddress;
    }

	// REJECT any incoming ether
	fallback () external payable { revert(); }

}