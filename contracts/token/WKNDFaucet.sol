// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./WKNDToken.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

/// @title A contract for ERC20 WKND token distribution
/// @author Milos Dograjic
/// @notice This contract is used to distribute Wakanda token to the addresses
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

    /// @notice Modifier that checks if the owner of the contract sent the transaction
    modifier onlyOwner(){
        require(msg.sender == WKNDOwner);
        _;
    }

	/// @notice This function is used for sending one token to the transaction sender
    /// @param _withdraw_amount amount of WKND token to be sent
	function withdraw(uint _withdraw_amount) public {

    	// Limit withdrawal amount to 1 WKND
    	require(_withdraw_amount <= 1 && _withdraw_amount > 0);

		uint wkndAmount = _withdraw_amount.mul(1000000000000000000);

		// Use the transferFrom function of WKNDToken
		WToken.transferFrom(WKNDOwner, msg.sender, wkndAmount);
    }

	/// @notice This function is used for setting the WKND tokent contract address
    /// @param _tokenAddress address of the WKND token contract
    function setTokenAddress(address _tokenAddress) external onlyOwner{
        tokenAddress = _tokenAddress;
    }

	/// @notice This function is used for rejecting any incoming ether
	receive () external payable { revert(); }

}