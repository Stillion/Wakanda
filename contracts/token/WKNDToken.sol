// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

/// @title A contract for ERC20 WKND Token
/// @author Milos Dograjic
/// @notice This contract is creating an ERC20 Wakanda Token that is used for Wakanda voting mechanism
contract WKNDToken is ERC20{

    uint private initialSupply = 40000000000000000000000; //40 000 total tokens, decimal 18

    constructor() ERC20 ("Wakanda Token", "WKND"){
        _mint(msg.sender, initialSupply);
    }
}