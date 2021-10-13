// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

/// @title A contract for WKND NFT
/// @author Milos Dograjic
/// @notice This contract is creating an NFT WKND that is used for Wakanda voting mechanism
contract WKND is ERC20{
    constructor(uint256 initialSupply) ERC20 ("WakandaToken", "WKND"){
        _mint(msg.sender, initialSupply);
    }
}