// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./WKND.sol";

/// @title A contract for voting for Wakandan UN Officials
/// @author Milos Dograjic
/// @notice For now this contract is simulating the Wakandan voting mechanism
contract WakandaVoting is WKND{

    event NewChallenger(string name);

    /// @notice This function returns the list of top 3 candidates
    /// @dev implement the function and see if it should be view or pure
    function winningCandidates() public pure returns(string[] memory){ 
        string[] memory currentlyWinning;
        return currentlyWinning;
    }

}